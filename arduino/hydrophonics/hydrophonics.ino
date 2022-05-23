#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <EEPROM.h>
#include <Arduino.h>

#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200




char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
WebServer server(80);
String clientServerIP = "";
String clientServerPort = "2345";



String acc = "";
int gsr = -1;
int ecg = -1;
double gsrc=  -1;

//ACC
const int xInput = A6;
const int yInput = A7;
const int zInput = A4;

// initialize minimum and maximum Raw Ranges for each axis
int RawMin = 0;
int RawMax = 1023;

// Take multiple samples to reduce noise
const int sampleSize = 10;
//ACC END

//GSR
const int GSR=A5;

int BPM = 0;

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void setWaterPump() {
  server.send(200, "text/plain", "success");
}

void setNutritionPump() {
  server.send(200, "text/plain", "success");
}

void setLightState() {
  server.send(200, "text/plain", "success");
}


void updateData(){
  if(clientServerIP == "") return;
  HTTPClient http;
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=DATA&ecg="+ String(ecg) +"&gsr="+ String(gsr) + "&acc="+ acc + "&bpm=100&gsrc=" + String(gsrc);
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
  http.end();
}


void readAcc(){
  //Read raw values
  int xRaw = ReadAxis(xInput);
  int yRaw = ReadAxis(yInput);
  int zRaw = ReadAxis(zInput);

  // Convert raw values to 'milli-Gs"
  long xScaled = map(xRaw, RawMin, RawMax, -1023, 1023);
  long yScaled = map(yRaw, RawMin, RawMax, -1023, 1023);
  long zScaled = map(zRaw, RawMin, RawMax, -1023, 1023);

  Serial.print("X, Y, Z  :: ");
  Serial.print(xRaw);
  Serial.print(", ");
  Serial.print(yRaw);
  Serial.print(", ");
  Serial.println(zRaw);
  acc = "X: " + String(xRaw) + " Y: " + String(yRaw) + " Z: " + String(zRaw);
}

int ReadAxis(int axisPin)
{
  long reading = 0;
  analogRead(axisPin);
  delay(1);
  for (int i = 0; i < sampleSize; i++)
  {
  reading += analogRead(axisPin);
  }
  return reading/sampleSize;
}

float getGSR(){
  float conductivevoltage;
  int sensorValue=analogRead(GSR);
  conductivevoltage = sensorValue*(5.0/1023.0);
  Serial.print("GSR: ");
  Serial.println(sensorValue);
  gsr = sensorValue;
  gsrc = conductivevoltage;
  return sensorValue;
}

int getECG(){
  ecg = analogRead(A3);
  Serial.print("ECG: ");
  Serial.println(ecg);
  return analogRead(A3);
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


  //ecg
  pinMode(23, INPUT); // Setup for leads off detection LO +
  pinMode(22, INPUT); 

}

long int timer = 0;

void loop() {
  server.handleClient();
  getECG();
  getGSR();
  readAcc();
  updateData();
  delay(1000);
}
