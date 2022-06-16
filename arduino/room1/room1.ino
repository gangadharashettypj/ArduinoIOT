#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>
#include "DHT.h"


#define DHTPIN D4
#define DHTTYPE DHT11


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

DHT dht(DHTPIN, DHTTYPE);

String sequence = "";

int timeoutCounter = 0;

bool swutch = false;
int tem = -1;
int humi = -1;

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}


void sendHumidity(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=dht&humidity="+ String(humi) + "&temperature="+String(tem) + "&moisture="+ digitalRead(D5);
  url.replace(" ", "%20");
  http.begin(client, url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}
void turnOnLight() {
  swutch = !swutch;
  server.send(200, "text/plain", "success");
}


void setup(void){
  Serial.begin(115200);
  Serial.println("");
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");

  server.on("/setClientIP", setIP);
  server.on("/turnOnLight", turnOnLight);

  server.begin();
  Serial.println("HTTP server started");

  pinMode(D5, INPUT);
  pinMode(D6, OUTPUT);

  dht.begin();
}

long long int last = 0;

void loop(void){
  server.handleClient();

  float h = dht.readHumidity();
  float t = dht.readTemperature();
  if(h<100) humi = h;
  if(t<100) tem = t;

  digitalWrite(D6, digitalRead(D5));


  if(millis()- last > 2000){
    last = millis();
    sendHumidity();
  }

}