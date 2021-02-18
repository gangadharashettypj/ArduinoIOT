#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <TinyGPS++.h>
#include <SoftwareSerial.h>
#include <EEPROM.h>
#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200
#include <Arduino.h>
#include <TM1637Display.h>

// Module connection pins (Digital Pins)
#define CLK D6
#define DIO D5

TM1637Display display(CLK, DIO);

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

int ledpin = D7;


void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

int waterTiming, waterLiters;
int noOfCoins = 0;
void setWaterTiming() {
//  Serial.println("Turn off bike called");
  String temp = server.arg("time");
  waterTiming = temp.toInt();
  Serial.println(waterTiming);
  EEPROM.write(1, waterTiming);
  EEPROM.commit();
  server.send(200, "text/plain", "success");
}
void setWaterLiters() {
   String temp = server.arg("liters");
   waterLiters = temp.toInt();
   Serial.println(waterLiters);
   EEPROM.write(2, waterLiters);
   EEPROM.commit();
  server.send(200, "text/plain", "success");
}

void resetCoins() {
   noOfCoins = 0;
   Serial.println("Resetting");
   EEPROM.write(3, 0);
   EEPROM.commit();
  server.send(200, "text/plain", "success");
}


void getWaterTiming(){
//  Serial.println("sendHTTPMsg");
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getWaterTiming&getWaterTiming="+ waterTiming;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}

void getWaterLiters(){
//  Serial.println("sendBikeLocationMsg");
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=getWaterLiters&getWaterLiters="+ waterLiters;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}
void numberOfCoins(){
//  Serial.println("sendBikeLocationMsg");
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=noOfCoins&noOfCoins="+ noOfCoins;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();

}


void setup(void){
  Serial.begin(115200);

  EEPROM.begin(512);
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");

  server.on("/setClientIP", setIP);
  server.on("/setWaterTiming", setWaterTiming);
  server.on("/setWaterLiters", setWaterLiters);
  server.on("/resetCoins", resetCoins);

  server.begin();

  pinMode(ledpin, OUTPUT);
  waterTiming = EEPROM.read(1);
  waterLiters = EEPROM.read(2);
  noOfCoins = EEPROM.read(3);
  pinMode(4, INPUT_PULLUP);
  pinMode(LED_BUILTIN, OUTPUT);
  attachInterrupt(digitalPinToInterrupt(4), coinInterrupt, RISING);
  digitalWrite(ledpin, LOW);
  display.setBrightness(0x0f);

}
long int count = 0;
long int timer = 0;
void loop(void){
  waterTiming = EEPROM.read(1);
  waterLiters = EEPROM.read(2);
  noOfCoins = EEPROM.read(3);
  server.handleClient();

  getWaterTiming();
  getWaterLiters();
  numberOfCoins();
  if((millis() - timer) < count && count != 0 && timer != 0){
    digitalWrite(ledpin, HIGH);
    int left = count - (millis() - timer);
    left /= 1000;
    display.showNumberDec(left, false);
  }
  else{
    timer = 0;
    count = 0;
    digitalWrite(ledpin, LOW);
    uint8_t data[] = { 0xff, 0xff, 0xff, 0xff };
    uint8_t blank[] = { 0x00, 0x00, 0x00, 0x00 };
    display.setSegments(blank);
  }


}



ICACHE_RAM_ATTR void coinInterrupt(){
  Serial.println("Coing detected");
  Serial.print(" ");
  Serial.print(timer);
  Serial.print(" ");
  Serial.print(count);
  Serial.println("");
  noOfCoins++;
  EEPROM.write(3, noOfCoins);
  EEPROM.commit();
  if(count > 0)
    count = count - (millis() - timer);
  timer = millis();
  count += (waterTiming*1000);
}