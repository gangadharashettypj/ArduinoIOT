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


const byte numChars = 200;
char receivedChars[numChars];
char tempChars[numChars];    

boolean newData = false;

SoftwareSerial MySerial(D2, D3);


WiFiClient wifiClient;



void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void sendHTTPMsg(){
  Serial.println("sendHTTPMsg"); 
  HTTPClient http;  
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=flood&data="+String(tempChars);
  url.replace(" ", "%20");
  Serial.println(url);
  http.begin(wifiClient, url);  
  int httpCode = http.GET();                                                                 
  String payload = http.getString();   
  Serial.println(payload); 
  http.end();
  
}


void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);


  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("CLASS", "");
 
  server.on("/setClientIP", setIP);
  
  server.begin();
  Serial.println("HTTP server started");
  udpReceiver.beginMulticast(WiFi.localIP(),addr,4200);
}

void loop() {
  server.handleClient();
  recvWithStartEndMarkers();
  if (newData) {
    Serial.println(">>>>");
    strcpy(tempChars, receivedChars);
    showParsedData();
    sendHTTPMsg();
    newData = false;
  }
}

void recvWithStartEndMarkers() {
    static boolean recvInProgress = false;
    static byte ndx = 0;
    char startMarker = '<';
    char endMarker = '>';
    char rc;

    while (MySerial.available() > 0 && newData == false) {
        rc = MySerial.read();

        if (recvInProgress == true) {
            if (rc != endMarker) {
                receivedChars[ndx] = rc;
                ndx++;
                if (ndx >= numChars) {
                    ndx = numChars - 1;
                }
            }
            else {
                receivedChars[ndx] = '\0'; // terminate the string
                recvInProgress = false;
                ndx = 0;
                newData = true;
            }
        }

        else if (rc == startMarker) {
            recvInProgress = true;
        }
    }
}

//============

void showParsedData() {
  Serial.println("==========");
  Serial.println(tempChars);
  // Serial.println(s2);
  // Serial.println(s3);
  // Serial.println(s4);
  // Serial.println(">>>>>>>>");
}
