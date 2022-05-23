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


int currentPeople = 0;
int sensor1[] = {D7,D3};
int sensor2[] = {D6,D5};
int sensor1Initial = 60;
int sensor2Initial = 60;

String sequence = "";

int timeoutCounter = 0;

bool swutch = false;
int tem = -1;
int humi = -1;


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
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=dht&humidity="+ String(humi) + "&temperature="+String(tem);
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

  server.begin();
  Serial.println("HTTP server started");
  sensor1Initial = measureDistance(sensor1);
  sensor2Initial = measureDistance(sensor2);

  pinMode(D0, OUTPUT);
  pinMode(D8, OUTPUT);

  dht.begin();
}

long long int last = 0;

void loop(void){
  server.handleClient();


  //Read ultrasonic sensors
  int sensor1Val = measureDistance(sensor1);
  int sensor2Val = measureDistance(sensor2);

  //Process the data
  if(sensor1Val < sensor1Initial - 30 && sequence.charAt(0) != '1'){
    sequence += "1";
  }else if(sensor2Val < sensor2Initial - 30 && sequence.charAt(0) != '2'){
    sequence += "2";
  }

  if(sequence.equals("12")){
    currentPeople++;
    sequence="";
    delay(550);
  }else if(sequence.equals("21") && currentPeople > 0){
    currentPeople--;
    sequence="";
    delay(550);
  }

  //Resets the sequence if it is invalid or timeouts
  if(sequence.length() > 2 || sequence.equals("11") || sequence.equals("22") || timeoutCounter > 200){
    sequence="";
  }

  if(sequence.length() == 1){ //
    timeoutCounter++;
  }else{
    timeoutCounter=0;
  }

  //Print values to serial
//  Serial.print("Seq: ");
//  Serial.print(sequence);
//  Serial.print(" S1: ");
//  Serial.print(sensor1Val);
//  Serial.print(" S2: ");
//  Serial.println(sensor2Val);
//
//
//  Serial.print(" TOTAL: ");
//  Serial.println(currentPeople);

  if(currentPeople > 0){
    digitalWrite(D0, LOW);
  }else{
    digitalWrite(D0, HIGH);
  }

  digitalWrite(D8, swutch);

  float h = dht.readHumidity();
  float t = dht.readTemperature();
  if(h<100) humi = h;
  if(t<100) tem = t;


  if(millis()- last > 2000){
    last = millis();
    sendHumidity();
  }

}
