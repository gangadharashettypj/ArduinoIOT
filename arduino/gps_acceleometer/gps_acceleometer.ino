#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <Wire.h> 
#include <LiquidCrystal_I2C.h>

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200

LiquidCrystal_I2C lcd(0x27, 16, 2);




char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

WiFiClient client;



// CUSTOM
bool isPanic = false;
bool isEmergency = false;
String accident = "";


int measureDistance(int a[]) {
  pinMode(a[1], OUTPUT);
  digitalWrite(a[1], LOW);
  delayMicroseconds(2);
  digitalWrite(a[1], HIGH);
  delayMicroseconds(10);
  digitalWrite(a[1], LOW);
  pinMode(a[0], INPUT);
  long duration = pulseIn(a[0], HIGH, 100000);
  return duration / 29 / 2;
}

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}


void sendHumidity(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=data&accident="+ String(accident) + "&isPanic="+String(isPanic) + "&isEmergency=" + String(isEmergency);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}


void setup(void){
  Serial.begin(115200);
  Serial.println("");
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("BIKE", "");

  server.on("/setClientIP", setIP);
  
  server.begin();
  Serial.println("HTTP server started");

  pinMode(D7, INPUT_PULLUP);
  pinMode(D6, INPUT_PULLUP);
  pinMode(D3, INPUT);
  pinMode(D4, INPUT);
  pinMode(D5, OUTPUT);

  lcd.begin();


  lcd.backlight();
}

long long int last = 0;
long long int lastIsEmergency = -1;
long long int lastIsPanic = -1;
long long int lastIsAccident= -1;

void loop(void){
  server.handleClient();

  if(!digitalRead(D6)){
    isPanic=true;
    lastIsPanic= millis();
    Serial.println("PANIC");
    while(!digitalRead(D6)) delay(100);
    digitalWrite(D5, HIGH);
  }

  if(!digitalRead(D7)){
    isEmergency=true;
    lastIsEmergency  = millis();
    Serial.println("EMERGENCY");
    while(!digitalRead(D7)) delay(100);
    digitalWrite(D5, HIGH);
  }

  if(!digitalRead(D3)){
    accident="LEFT ACCIDENT";
    lastIsAccident = millis();
    sendHumidity();
    digitalWrite(D5, HIGH);
  }

  else if(!digitalRead(D4)){
    accident="RIGHT ACCIDENT";
    lastIsAccident = millis();
    sendHumidity();
    digitalWrite(D5, HIGH);
  } 

  if((millis()- lastIsAccident) > 10000 && lastIsAccident != -1){
    accident = "";
    lastIsAccident = -1;
    digitalWrite(D5, LOW);
  }
  

  if((millis()- lastIsEmergency) > 10000 && lastIsEmergency  != -1){
    isEmergency = false;
    lastIsEmergency = -1;
    digitalWrite(D5, LOW);
  }
  
  if((millis()- lastIsPanic) > 10000 && lastIsPanic != -1 ){
    isPanic = false;
    lastIsPanic = -1;
    digitalWrite(D5, LOW);
  }
  
  if(millis()- last > 2000){
    last = millis();
    sendHumidity();
    lcd.clear();
    lcd.setCursor(0,0);
    lcd.print(accident);
    if(isEmergency){
      
      lcd.setCursor(0,1);
      lcd.print("EMERGENCY");
    }
    if(isPanic){
      lcd.setCursor(10,1);
      lcd.print("PANIC");
    }
//    lcd.print();
  }

}
