#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";
int bikeStatus = 2;

double latitude = 0;
double longitude = 0;


static const int RXPin = 4, TXPin = 5;
static const uint32_t GPSBaud = 9600;

// The TinyGPS++ object
TinyGPSPlus gps;

// The serial connection to the GPS device
SoftwareSerial ss(RXPin, TXPin);

WiFiClient client;

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

bool locked = false;
void turnOnBike() {
//  Serial.println("Turn on bike called");
  bikeStatus = 1;
  locked = false;
  server.send(200, "text/plain", "success");
}
void turnOffBike() {
//  Serial.println("Turn off bike called");
  locked = true;
  bikeStatus = 2;
  server.send(200, "text/plain", "success");
}
void getBikeStatus() {
  server.send(200, "text/plain", "bike status "+String(bikeStatus));
}


void sendBikeStatusMsg(){
//  Serial.println("sendHTTPMsg");
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=bikeStatus&bikeStatus="+ bikeStatus;
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}

void sendBikeLocationMsg(){
//  Serial.println("sendBikeLocationMsg");
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=bikeLocation&lat="+ String(latitude, 6) + "&lng=" + String(longitude, 6);
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
  WiFi.softAP("DreamTech", "");

  server.on("/setClientIP", setIP);
  server.on("/turnOnBike", turnOnBike);
  server.on("/turnOffBike", turnOffBike);
  server.on("/getBikeStatus", getBikeStatus);

  server.begin();
  Serial.println("HTTP server started");

  ss.begin(GPSBaud);

  pinMode(D5, INPUT);
  pinMode(D6, INPUT);

}
int i = 0;
void loop(void){
  server.handleClient();
  if(digitalRead(D5)){
    bikeStatus = 2;
  }
  else if(digitalRead(D6)){
    bikeStatus = 3;
  }
  else{
    bikeStatus = 1;
  }
  sendBikeStatusMsg();
}

void displayInfo()
{
//  Serial.print(F("Location: "));
  if (gps.location.isValid())
  {
    latitude = gps.location.lat();
    longitude = gps.location.lng();
//    Serial.print(gps.location.lat(), 6);
//    Serial.print(F(","));
//    Serial.print(gps.location.lng(), 6);
  }
//  else
//  {
//    Serial.print(F("INVALID"));
//  }

//  Serial.print(F("  Date/Time: "));
//  if (gps.date.isValid())
//  {
//    Serial.print(gps.date.month());
//    Serial.print(F("/"));
//    Serial.print(gps.date.day());
//    Serial.print(F("/"));
//    Serial.print(gps.date.year());
//  }
//  else
//  {
//    Serial.print(F("INVALID"));
//  }
//
//  Serial.print(F(" "));
//  if (gps.time.isValid())
//  {
//    if (gps.time.hour() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.hour());
//    Serial.print(F(":"));
//    if (gps.time.minute() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.minute());
//    Serial.print(F(":"));
//    if (gps.time.second() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.second());
//    Serial.print(F("."));
//    if (gps.time.centisecond() < 10) Serial.print(F("0"));
//    Serial.print(gps.time.centisecond());
//  }
//  else
//  {
//    Serial.print(F("INVALID"));
//  }

//  Serial.println();
//  delay(1000);
}
