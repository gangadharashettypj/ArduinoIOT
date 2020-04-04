#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <Servo.h>
#include <WiFiUdp.h>
#include <ArduinoJson.h>


#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200

StaticJsonDocument<200> doc;
char buffer[512];
IPAddress    apIP(10, 10, 10, 1);  
Servo myservo; 
ESP8266WebServer server(80);
String clientServerIP = "";
String clientServerPort = "";

WiFiUDP udpReceiver;

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void controllCar() {
  Serial.println(server.arg("direction"));
  server.send(200, "text/plain", "success");
}
void controllerChat() {
  Serial.println(server.arg("msg"));
  server.send(200, "text/plain", "success");
}

void sendHTTPMsg(String msg){
  Serial.println("sendHTTPMsg"); 
  HTTPClient http;  
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=chat&msg="+msg+"&name=Ole";
  url.replace(" ", "%20");
  Serial.println(url);
  http.begin(url);  
  int httpCode = http.GET();                                                                 
  String payload = http.getString();   
  Serial.println(payload); 
  http.end();
  
}


int readBuffer(){
  int len = udpReceiver.parsePacket();
  if(len > 0){
    int readLen = udpReceiver.read(buffer,BUFFER_SIZE);
    buffer[readLen]='\0';
    String str(buffer);
    Serial.println(str);
    DeserializationError error = deserializeJson(doc, str);
    if (error) {
      Serial.print(F("deserializeJson() failed: "));
      Serial.println(error.c_str());
      return 0;
    }
    Serial.println((const char*)doc["msg"]);
    Serial.println((const char*)doc["direction"]);
    Serial.println((const char*)doc["path"]);
    return len;
  }
  return 0;
}


void sendUdpMsg(String data){
  udpReceiver.beginPacket(addr1,4202);
  udpReceiver.print(data);
  udpReceiver.endPacket();
}


void sendUdpResponse(String data){
  udpReceiver.beginPacket(addr,4200);
  udpReceiver.print(data);
  udpReceiver.endPacket();
}


void setup(void){
  Serial.begin(115200);
  Serial.println("");
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");
 
  server.on("/setClientIP", setIP);
  server.on("/carController", controllCar);
  server.on("/chat", controllerChat);
  
  server.begin();
  Serial.println("HTTP server started");
  udpReceiver.beginMulticast(WiFi.localIP(),addr,4200);
}
int i = 0;
void loop(void){
  server.handleClient();
  readBuffer();
  delay(10);
}
