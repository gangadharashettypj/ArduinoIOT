#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <Servo.h>
#include <WiFiUdp.h>
#include <ArduinoJson.h>

#define M3 D6
#define M4 D5
#define M1 D7
#define M2 D8


#define addr IPAddress(224, 10, 10, 10)
#define addr1 IPAddress(225, 10, 10, 10)
#define BUFFER_SIZE 512
#define port 4200

char buffer[512];

WiFiUDP udpReceiver;

bool autoMode = false;



void readBuffer() {
  int len = udpReceiver.parsePacket();
  if (len > 0) {
    int readLen = udpReceiver.read(buffer, BUFFER_SIZE);
    buffer[readLen] = '\0';
    String str(buffer);
    Serial.println(str);
    processCommand(str);
  }
}


void moveBackward() {
  digitalWrite(M1, LOW);
  digitalWrite(M2, HIGH);
  digitalWrite(M3, LOW);
  digitalWrite(M4, HIGH);
}

void moveForward() {
  digitalWrite(M1, HIGH);
  digitalWrite(M2, LOW);
  digitalWrite(M3, HIGH);
  digitalWrite(M4, LOW);
}
void moveLeft() {
  digitalWrite(M1, LOW);
  digitalWrite(M2, HIGH);
  digitalWrite(M3, HIGH);
  digitalWrite(M4, LOW);
}
void moveRight() {
  digitalWrite(M1, HIGH);
  digitalWrite(M2, LOW);
  digitalWrite(M3, LOW);
  digitalWrite(M4, HIGH);
}
void stop() {
  digitalWrite(M1, LOW);
  digitalWrite(M2, LOW);
  digitalWrite(M3, LOW);
  digitalWrite(M4, LOW);
}

void processCommand(String command) {
  if (command == "FRONT") {
    moveForward();
  } else if (command == "BACK") {
    moveBackward();
  } else if (command == "LEFT") {
    moveLeft();
  } else if (command == "RIGHT") {
    moveRight();
  } else if (command == "STOP") {
    stop();
  } else if (command == "AUTO") {
    autoMode = true;
  } else if (command == "MANUAL") {
    autoMode = false;
  }
}


void sendUdpMsg(String data) {
  udpReceiver.beginPacket(addr1, 4206);
  udpReceiver.print(data);
  udpReceiver.endPacket();
}

void setup(void) {
  Serial.begin(115200);


  pinMode(M1, OUTPUT);
  pinMode(M2, OUTPUT);
  pinMode(M3, OUTPUT);
  pinMode(M4, OUTPUT);
  pinMode(D4, OUTPUT);

  digitalWrite(D4, HIGH);

  WiFi.begin("Sumeru", "sumeru@Jio");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  Serial.println("HTTP server started");
  udpReceiver.beginMulticast(WiFi.localIP(), addr, 4204);

  digitalWrite(D4, LOW);
}

void loop(void) {
  readBuffer();
}
