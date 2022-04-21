#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include <Servo.h>
#include <LiquidCrystal_I2C.h>

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200

#define echoPin D6
#define trigPin D5

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

WiFiClient client;


Servo myservo;
LiquidCrystal_I2C lcd(0x3F, 16, 2); 

long duration; 
int distance;
int getDistance(){
  digitalWrite(trigPin, LOW);
  delayMicroseconds(2);
  
  digitalWrite(trigPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(trigPin, LOW);
  
  duration = pulseIn(echoPin, HIGH);
  
  distance = duration * 0.034 / 2;
   
  return distance;
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
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getHumidity&humidity="+ String(123);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}
void turnOnLight() {
  server.send(200, "text/plain", "success");
}


void setup(void){
  Serial.begin(115200);
  Serial.println("");
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("GreenHouse", "");

  server.on("/setClientIP", setIP);
  server.on("/turnOnLight", turnOnLight);

  server.begin();
  Serial.println("HTTP server started");

  pinMode(trigPin, OUTPUT);
  pinMode(echoPin, INPUT); 
  myservo.attach(D8);
  myservo.write(1); 
  lcd.begin(16,2);
  lcd.init();

  // Turn on the backlight.
  lcd.backlight();

  // Move the cursor characters to the right and
  // zero characters down (line 1).
  lcd.setCursor(5, 0);

  // Print HELLO to the screen, starting at 5,0.
  lcd.print("HELLO");

}
int i = 0;
void loop(void){
  server.handleClient();

  int dis = getDistance();
  if(dis>30){
    dis = 30;
  }
  if(dis<0){
    dis = 0;
  }
  int percent = 100 - (dis*100/30);


  
  if(percent > 50){
    myservo.write(percent*1.5);  
    delay(100);
  }
  else{
    myservo.write(0);  
    delay(100);
  }
  Serial.print("Percent: ");
  Serial.println(percent);
}
