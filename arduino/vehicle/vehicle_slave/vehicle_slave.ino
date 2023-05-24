#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <TinyGPS++.h>

#include <SoftwareSerial.h>

#define ssid "vehicle"
#define password ""


WiFiUDP UDP;
IPAddress remote_IP(192, 168, 4, 1);
#define UDP_PORT 4210

int GPSBaud = 9600;

TinyGPSPlus gps;

SoftwareSerial mySerial(4, 5);

String lat = "", lon = "", dateG = "", timeG = "";

unsigned long int lastTime = -1;

void setup() {
  Serial.begin(115200);
  mySerial.begin(GPSBaud);
  Serial.println();

  WiFi.begin(ssid, password);
  WiFi.mode(WIFI_STA);

  Serial.print("UDP client\nConnecting to ");
  while (WiFi.status() != WL_CONNECTED) {
    delay(100);
    Serial.print(".");
  }

  UDP.begin(UDP_PORT);
  pinMode(D5, INPUT);
  pinMode(D6, INPUT);
}

void loop() {
  getGPSData();
  if ((millis() - lastTime) > 2000) {
    lastTime = millis();
    UDP.beginPacket(remote_IP, UDP_PORT);
    String str = lat + "," + lon + "," + dateG + "," + timeG + "," + String(digitalRead(D5)) + "," + digitalRead(D6);
    Serial.println(str);
    UDP.print(str);
    UDP.endPacket();
  }
}

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
