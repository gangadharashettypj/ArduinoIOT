#include <SoftwareSerial.h>
#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <WiFiUdp.h>


#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);  

ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

WiFiUDP udpReceiver;


SoftwareSerial MySerial(D2, D3);

WiFiClient wifiClient;



void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void controller() {
  Serial.println("controller");
  Serial.println(server.arg("command"));
  MySerial.write(String("<" + String(server.arg("command")) + ">").c_str());
  server.send(200, "text/plain", "success");
}

bool r1Status = false;
bool r2Status = false;


void r1() {
  Serial.println("r1");
  r1Status = !r1Status;
  server.send(200, "text/plain", "success");
}


void r2() {
  Serial.println("r2");
  r2Status = !r2Status;
  server.send(200, "text/plain", "success");
}


void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);


  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("SOLAR", "");
 
  server.on("/setClientIP", setIP);
  server.on("/controller", controller);
  server.on("/r1", r1);
  server.on("/r2", r2);
  pinMode(D7, OUTPUT);
  pinMode(D8, OUTPUT);
  
  server.begin();
  Serial.println("HTTP server started");
  udpReceiver.beginMulticast(WiFi.localIP(),addr,4200);
}

void loop() {
  server.handleClient();
  digitalWrite(D8, r1Status);
  digitalWrite(D7, r2Status);
}
