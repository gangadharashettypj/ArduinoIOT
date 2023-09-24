
#include <SoftwareSerial.h>
#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <Arduino.h>
#include <TinyGPS++.h>


const int RXPin = 13, TXPin = 12;
const uint32_t GPSBaud = 9600;  //Default baud of NEO-6M is 9600


TinyGPSPlus gps;                      
SoftwareSerial mySerial(RXPin, TXPin);  



#define addr IPAddress(224, 10, 10, 10)
#define addr1 IPAddress(225, 10, 10, 10)
#define BUFFER_SIZE 512
#define port 4200

char buffer[512];
IPAddress apIP(10, 10, 10, 1);
WebServer server(80);
String clientServerIP = "10.10.10.2";
String clientServerPort = "2345";

bool light = false;

String lat = "", lon = "", dateG = "", timeG = "";


void setIP() {
  Serial.println("Setting IP");
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void toggle() {
  Serial.println("Toggle");
  light = !light;

  server.send(200, "text/plain", "success");
}

void getData() {
  HTTPClient http;
  http.setTimeout(3);
  String url = "http://" + clientServerIP + ":" + clientServerPort + "/?type=data&lat=" + lat + "&lon=" + lon + "&date=" + dateG + "&time=" + timeG;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
}

void setup(void) {
  Serial.begin(115200);
  mySerial.begin(GPSBaud);


  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("GPS", "");

  server.on("/setClientIP", setIP);
  server.on("/toggle", toggle);

  pinMode(2, OUTPUT);

  server.begin();
  Serial.println("Server Started");
}

unsigned long int timer = 0;


void getGPSData() {
  while (mySerial.available() > 0) {
    if (gps.encode(mySerial.read())) {
      if (gps.location.isValid()) {
        lat = String(gps.location.lat(), 6);
        lon = String(gps.location.lng(), 6);
      }

      if (gps.date.isValid()) {
        dateG = String(gps.date.day()) + "/" + String(gps.date.month()) + "/" + String(gps.date.year());
      }

      if (gps.time.isValid()) {
        timeG = String(gps.time.hour()) + ":" + String(gps.time.minute()) + ":" + String(gps.time.second());
      }
    }
  }
  if (millis() > 5000 && gps.charsProcessed() < 10) {
    Serial.println("No GPS detected");
    while (true)
      ;
  }
}


void loop() {
  server.handleClient();
  getGPSData();

  if (millis() - timer > 2000) {
    getData();
    timer = millis();
  }

  digitalWrite(2, light);
}
