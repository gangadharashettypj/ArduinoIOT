#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <EEPROM.h>
#include <Arduino.h>
#include <OneWire.h>
#include <DallasTemperature.h>
#include "DHT.h"

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200
#define DHTPIN 2
#define DHTTYPE DHT11
#define ONE_WIRE_BUS 22

DHT dht(DHTPIN, DHTTYPE);

OneWire oneWire(ONE_WIRE_BUS);

DallasTemperature sensors(&oneWire);

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
WebServer server(80);
String clientServerIP = "10.10.10.2";
String clientServerPort = "2345";


bool waterPumpStatus = false;
bool nutritionPumpStatus = false;
bool lightStatus = false;

float pH;
float humidity;
float airTemperature;
float waterTemperature;


void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void setWaterPump() {
  waterPumpStatus = !waterPumpStatus;
  server.send(200, "text/plain", "success");
}

void setNutritionPump() {
   nutritionPumpStatus = true;
  server.send(200, "text/plain", "success");
}

void setLightState() {
  lightStatus = !lightStatus;
  server.send(200, "text/plain", "success");
}


void getPH(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=pH&pH="+ pH +"&humidity="+ humidity + "&airTemperature="+ airTemperature + "&waterTemperature="+ waterTemperature;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}

void getHumidity(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=humidity&humidity="+ humidity;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();
}

void getAirTemperature(){
   HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=airTemperature&airTemperature="+ airTemperature;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
}

void getWaterTemperature(){
   HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=waterTemperature&waterTemperature="+ waterTemperature;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
}

void setup(void){
  Serial.begin(115200);

  EEPROM.begin(512);
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");

  server.on("/setClientIP", setIP);
  server.on("/waterPump", setWaterPump);
  server.on("/nutritionPump", setNutritionPump);
  server.on("/light", setLightState);

  server.begin();

  dht.begin();

  pinMode(32,INPUT); // ph
  pinMode(12, OUTPUT); // water pump
  pinMode(14, OUTPUT); // light
  pinMode(27, OUTPUT); // nutrition pump  
}

long int timer = 0;

void loop() {
   server.handleClient();
  digitalWrite(12, waterPumpStatus);
  digitalWrite(14, lightStatus);
  if(nutritionPumpStatus){
    nutritionPumpStatus = false;
    timer = millis();
    digitalWrite(27, HIGH);
  }

  if(millis() - timer > 3000){
    digitalWrite(27, LOW);
  }

   // water temperature
  sensors.requestTemperatures();
  waterTemperature = sensors.getTempCByIndex(0);

  // ph
  int value= analogRead(32);
  float voltage=value*(3.3/4095.0);
  pH=(3.3*voltage);

  // dht 11
  humidity = dht.readHumidity();
  airTemperature = dht.readTemperature();
  
  getPH();
//  getHumidity();
//  getAirTemperature();
//  getWaterTemperature();
}
