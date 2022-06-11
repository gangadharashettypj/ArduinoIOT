#include <Arduino.h>
#include <ESP8266WebServer.h>
#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <ESP8266WiFiMulti.h>
#include <ESP8266HTTPClient.h>
#include <WiFiClient.h>


#include <Wire.h>
#include <Adafruit_GFX.h>
#include <Adafruit_SSD1306.h>


#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200

#define SCREEN_WIDTH 128 
#define SCREEN_HEIGHT 64 

Adafruit_SSD1306 display(SCREEN_WIDTH, SCREEN_HEIGHT, &Wire, -1);



char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

WiFiClient client;

// CUSTOM

bool swutch = false;
String motion = "NOT DETECTED";
int moisture = 0;


void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}


void sendHumidity(){
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=motion&moisture="+ String(moisture) + "&motion="+motion;
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
  WiFi.softAP("GreenHouse", "");

  server.on("/setClientIP", setIP);
  server.on("/turnOnLight", turnOnLight);
  pinMode(D7, INPUT);
  pinMode(D5, OUTPUT);
  pinMode(D8, OUTPUT);
  server.begin();
  Serial.println("HTTP server started");

  // initialize with the I2C addr 0x3C
  display.begin(SSD1306_SWITCHCAPVCC, 0x3C);  

  // Clear the buffer.
  display.clearDisplay();
}

long int last = 0;

void loop(void){
  server.handleClient();

  
  moisture = analogRead(0);
  moisture = moisture / 10;
  if(moisture > 100) moisture = 100;
  moisture = 100 - moisture;
  digitalWrite(D5, moisture < 51);
  
  if(digitalRead(D7)) {
    motion = "DETECTED";
    digitalWrite(D8, HIGH);
  }
  else {
    motion = "NOT DETECTED";
    digitalWrite(D8, LOW);
  }
  
  display.clearDisplay();
  display.setTextSize(1);
  display.setTextColor(WHITE);
  
  display.setCursor(0,20);
  display.println("Moisture: " + String(moisture));
  display.setCursor(0,40);
  display.println("Motion: " + motion);
  display.display();
  
  last = millis();
  sendHumidity();
  delay(100);
}
