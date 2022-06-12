#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <LiquidCrystal_I2C.h>
#include <Servo.h>

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200


char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

WiFiClient client;



// CUSTOM

LiquidCrystal_I2C lcd(0x27, 16, 2);

Servo servo;

bool valveOpened = false;
bool manual = false;


long long int last = 0;

const float  OffSet = 0.483 ;

float V = 0, P = 0;
int servoLevel = 0;
String level = "EMPTY";

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}


void sendHumidity(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=data&level="+ String(level) + "&pressure="+String(P) + "&workType=" + String(manual);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();
}

void manualMode() {
  manual = true;
  server.send(200, "text/plain", "success");
}

void autoMode() {
  manual = false;
  server.send(200, "text/plain", "success");
}

void up() {
  if(servoLevel == 0){
    servoLevel = 90;
  }else if(servoLevel == 90){
    servoLevel = 180;
  } else{
    servoLevel = 180;
  }
  server.send(200, "text/plain", "success");
}

void down() {
  if(servoLevel == 180){
    servoLevel = 90;
  }else if(servoLevel == 90){
    servoLevel = 0;
  } else{
    servoLevel = 0;
  }
  server.send(200, "text/plain", "success");
}


void setup(void){
  Serial.begin(115200);
  Serial.println("");
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DamProject", "");

  server.on("/setClientIP", setIP);
  server.on("/manual", manualMode);
  server.on("/auto", autoMode);
  server.on("/up", up);
  server.on("/down", down);

  server.begin();
  Serial.println("HTTP server started");

  pinMode(D4, INPUT_PULLUP);
  pinMode(D6, INPUT_PULLUP);
  pinMode(D7, INPUT_PULLUP);
  
  servo.attach(D8);
  servo.write(0);
  
  lcd.begin(16,2);
  lcd.init();

  lcd.backlight();
}

void loop(void){
  server.handleClient();

  if(!manual){
  servoLevel = 0;
   level = "EMPTY";
   if(digitalRead(D4)){
      servoLevel = 0;
      level = "LOW";
   }
   if(digitalRead(D6)){
      servoLevel = 90;
      level = "MEDIUM";
   }

   if(digitalRead(D7)){
      servoLevel = 180;
      level = "HIGH";
   }

   if(valveOpened){
    servoLevel = 100;
   }
  }
  V = analogRead(A0) * 5.00 / 1024;     //Sensor output voltage
  P = (V - OffSet) * 400;             //Calculate water pressure

  P = P- 150;
  if(P<0) P=0;
  

  if((millis()- last) > 2000){
    last = millis();
    lcd.clear();
    lcd.setCursor(0, 1);
  
    lcd.print("PRESSURE: ");
    lcd.setCursor(10,1);
    lcd.print(String(P).toInt());

    lcd.setCursor(0, 0);
    // print message
    lcd.print("LEVEL:");
    lcd.setCursor(7, 0);
    lcd.print(level);

    servo.write(servoLevel);
    sendHumidity();
  }
  delay(10);
}
