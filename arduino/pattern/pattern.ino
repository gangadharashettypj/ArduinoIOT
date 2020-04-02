#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <Servo.h>

IPAddress    apIP(10, 10, 10, 1);  
Servo myservo; 
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";
void setIP() {
  Serial.println(server.arg("ip"));
  Serial.println(server.arg("port"));
  clientServerIP = server.arg("ip");
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void controllCar() {
  Serial.println(server.arg("direction"));
}

void setup(void){
  Serial.begin(9600);
  Serial.println("");
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");
 
  server.on("/setClientIP", setIP);
  server.on("/carController", controllCar);
  
  server.begin();
  Serial.println("HTTP server started");
}
int i = 0;
void loop(void){
  server.handleClient();
  
  delay(10);
}
