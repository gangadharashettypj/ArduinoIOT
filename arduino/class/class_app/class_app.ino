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


const byte numChars = 100;
char receivedChars[numChars];
char tempChars[numChars];        
char windDirection[20] = {0};
int s1 = 0;
int s2 = 0;
int s3 = 0;
int s4 = 0;

boolean newData = false;

SoftwareSerial MySerial(D3, D2);


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
  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=flood&s1="+String(s1)+"&s2="+String(s2)+"&s3="+String(s3)+"&s4="+String(s4);
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
  MySerial.begin(115200);


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
    strcpy(tempChars, receivedChars);
    parseData();
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

void parseData() {  // split the data into its parts

  char* strtokIndx;  // this is used by strtok() as an index
  Serial.println(tempChars);
  strtokIndx = strtok(tempChars, ",");  // get the first part - the string
  strcpy(windDirection, strtokIndx);    // copy it to messageFromPC

  strtokIndx = strtok(NULL, ",");    // this continues where the previous call left off
  s1 = atoi(strtokIndx);  // convert this part to an integer

  strtokIndx = strtok(NULL, ",");
  s2 = atoi(strtokIndx);  // convert this part to a float

  strtokIndx = strtok(NULL, ",");
  s3 = atoi(strtokIndx);  // convert this part to a float

  strtokIndx = strtok(NULL, ",");
  s4 = atoi(strtokIndx);  // convert this part to a float
}

//============

void showParsedData() {
  // Serial.println("==========");
  // Serial.println(s1);
  // Serial.println(s2);
  // Serial.println(s3);
  // Serial.println(s4);
  // Serial.println(">>>>>>>>");
}