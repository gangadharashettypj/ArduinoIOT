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

#define LIR D2
#define RIR D1


#define addr IPAddress(224, 10, 10, 10)
#define addr1 IPAddress(225, 10, 10, 10)
#define BUFFER_SIZE 512
#define port 4200

char buffer[512];

WiFiUDP udpReceiver;

int autoMode = 1;

unsigned long int lastCommandTime = -1;

String lastCommand = "";



void readBuffer() {
  int len = udpReceiver.parsePacket();
  if (len > 0) {
    int readLen = udpReceiver.read(buffer, BUFFER_SIZE);
    buffer[readLen] = '\0';
    String str(buffer);
    Serial.println(str);

    if (autoMode == 1) {
      if (lastCommandTime != -1 && lastCommand != "") {
        Serial.println("Sending command to Slave 1 IMMEDIATE");
        sendUdpMsg(lastCommand);
        lastCommand = str;
        unsigned long int currentTime = millis();
        lastCommandTime = currentTime - (2000 - (currentTime - lastCommandTime));
      } else {
        lastCommand = str;
        lastCommandTime = millis();
      }
    }

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
  if (command == "FRONT" && (autoMode == 1 || autoMode == 3)) {
    moveForward();
  } else if (command == "BACK" && (autoMode == 1 || autoMode == 3)) {
    moveBackward();
  } else if (command == "LEFT" && (autoMode == 1 || autoMode == 3)) {
    moveLeft();
  } else if (command == "RIGHT" && (autoMode == 1 || autoMode == 3)) {
    moveRight();
  } else if (command == "STOP" && (autoMode == 1 || autoMode == 3)) {
    stop();
  } else if (command == "AUTO") {
    stop();
    autoMode = 2;
  } else if (command == "MANUAL") {
    stop();
    autoMode = 3;
  } else if (command == "PLATOON") {
    stop();
    autoMode = 1;
  }
}


void sendUdpMsg(String data) {
  udpReceiver.beginPacket(addr, 4202);
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
  pinMode(LIR, INPUT);
  pinMode(RIR, INPUT);

  digitalWrite(D4, HIGH);

  WiFi.begin("Sumeru", "sumeru@Jio");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  Serial.println("HTTP server started");
  udpReceiver.beginMulticast(WiFi.localIP(), addr, 4200);

  digitalWrite(D4, LOW);
}

void lfr() {
  if (!digitalRead(LIR) && !digitalRead(RIR)) {
    stop();
    delay(10);
  } else if (!digitalRead(LIR)) {
    moveLeft();
    delay(10);
    stop();
  } else if (!digitalRead(RIR)) {
    moveRight();
    delay(10);
    stop();
  } else {
    moveForward();
  }
}

void loop(void) {
  readBuffer();

  if (autoMode == 2) {
    lfr();
  }

  if (lastCommandTime != -1 && lastCommand != "") {
    if ((millis() - lastCommandTime) > 2000) {
      Serial.println("Sending command to Slave 1");
      sendUdpMsg(lastCommand);
      lastCommandTime = -1;
      lastCommand = "";
    }
  }
}
