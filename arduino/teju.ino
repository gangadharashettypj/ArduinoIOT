#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include "DHT.h"

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200


#define DHTPIN 2
#define DHTTYPE DHT11

DHT dht(DHTPIN, DHTTYPE);

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";


int temperature = 0;
int moisture = 0;
int humidity = 0;
String raining = "--";

WiFiClient client;

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}


void sendHumidity(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getHumidity&humidity="+ String(humidity);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}

void sendTemperature(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getTemperature&temperature="+ String(temperature);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}

void sendMoisture(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getMoisture&moisture="+ String(moisture);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}

void sendRaining(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getRaining&raining="+ raining;
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();
}

void sendLight(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getLight&light="+ (digitalRead(D6)?"NIGHT": "MORNING");
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();
}

bool light = false;
bool fan = false;
bool sprinkler = false;
void turnOnLight() {
  light = true;
  server.send(200, "text/plain", "success");
}
void turnOffLight() {
  light = false;
  server.send(200, "text/plain", "success");
}
void turnOnFan() {
  fan = true;
  server.send(200, "text/plain", "success");
}
void turnOffFan() {
  fan = false;
  server.send(200, "text/plain", "success");
}
void turnOnSprinkler() {
  sprinkler = true;
  server.send(200, "text/plain", "success");
}
void turnOffSprinkler() {
  sprinkler = false;
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
  server.on("/turnOffLight", turnOffLight);
  server.on("/turnOnFan", turnOnFan);
  server.on("/turnOffFan", turnOffFan);
  server.on("/turnOnSprinkler", turnOnSprinkler);
  server.on("/turnOffSprinkler", turnOffSprinkler);

  server.begin();
  Serial.println("HTTP server started");

  pinMode(D6, INPUT);
  pinMode(D7, INPUT);
  pinMode(D1, OUTPUT);
  pinMode(D2, OUTPUT);
  pinMode(D8, OUTPUT);

  dht.begin();

}
int i = 0;
void loop(void){
  server.handleClient();

  moisture = analogRead(A0);
  delay(30);
  raining = digitalRead(D7) ? "SUNNY" : "RAINY";
  humidity = (int)dht.readHumidity();
  temperature =  (int)dht.readTemperature();

  sendMoisture();
  sendHumidity();
  sendRaining();
  sendTemperature();
  sendLight();

  digitalWrite(D1, light);
  digitalWrite(D2, fan);
  digitalWrite(D8, sprinkler);
}