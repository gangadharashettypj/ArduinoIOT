#include <ESP8266WiFi.h>
#include <WiFiClient.h>
#include <ESP8266WebServer.h>
#include <ESP8266HTTPClient.h>
#include <WiFiUdp.h>
#include <Adafruit_Fingerprint.h>


#define addr IPAddress(224, 10, 10, 10)
#define addr1 IPAddress(225, 10, 10, 10)
#define BUFFER_SIZE 512
#define port 4200

char buffer[512];

WiFiUDP udpReceiver;

SoftwareSerial mySerial(D2, D3);

Adafruit_Fingerprint finger = Adafruit_Fingerprint(&mySerial);

uint8_t id = 0;


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


void processCommand(String command) {
  if (command.startsWith("setId")) {
    id = command.substring(5).toInt();
    Serial.println(id);
    sendUdpMsg("INFO: ID Set successful");
  } else if (command == "ENROLL") {
    if (id < 1) {
      sendUdpMsg("ERROR: Please set valid id and proceed");
      return;
    }
    getFingerprintEnroll();
  } else if (command == "EMPTY") {
    finger.emptyDatabase();
    sendUdpMsg("INFO: Cleared fingerprint data");
  } else if (command == "SEARCH") {
    sendUdpMsg("INFO: PLACE FINGER");
    int id = getFingerprintID();
    
    if (id == -1) {
      Serial.println("Not Found");
      sendUdpMsg("ERROR: Not Found");
    } else {
      Serial.println("Found: " + String(id));
      sendUdpMsg("RESULT: Found with id: " + String(id));
    }
  }
}


void sendUdpMsg(String data) {
  udpReceiver.beginPacket(addr, 4202);
  udpReceiver.print(data);
  udpReceiver.endPacket();
}


int getFingerprintID() {
  uint8_t p = -1;

  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
  };

  p = finger.image2Tz();
  if (p != FINGERPRINT_OK) return -1;

  p = finger.fingerFastSearch();
  if (p != FINGERPRINT_OK) return -1;

  // found a match!
  Serial.print("Found ID #");
  Serial.print(finger.fingerID);
  Serial.print(" with confidence of ");
  Serial.println(finger.confidence);
  return finger.fingerID;
}



void initFingerPrintSensor() {
  finger.begin(57600);
  delay(1000);

  if (finger.verifyPassword()) {
    Serial.println("Found fingerprint sensor!");
  } else {
    Serial.println("Did not find fingerprint sensor :(");
    while (1) { delay(1); }
  }

  Serial.println(F("Reading sensor parameters"));
  finger.getParameters();
  Serial.print(F("Status: 0x"));
  Serial.println(finger.status_reg, HEX);
  Serial.print(F("Sys ID: 0x"));
  Serial.println(finger.system_id, HEX);
  Serial.print(F("Capacity: "));
  Serial.println(finger.capacity);
  Serial.print(F("Security level: "));
  Serial.println(finger.security_level);
  Serial.print(F("Device address: "));
  Serial.println(finger.device_addr, HEX);
  Serial.print(F("Packet len: "));
  Serial.println(finger.packet_len);
  Serial.print(F("Baud rate: "));
  Serial.println(finger.baud_rate);
}


uint8_t getFingerprintEnroll() {

  int p = -1;
  Serial.print("Waiting for valid finger to enroll as #");
  sendUdpMsg("INFO: Waiting for valid finger to enroll.");
  Serial.println(id);
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
      case FINGERPRINT_OK:
        Serial.println("Image taken");
        sendUdpMsg("INFO: Image taken");
        break;
      case FINGERPRINT_NOFINGER:
        Serial.println(".");
        break;
      case FINGERPRINT_PACKETRECIEVEERR:
        Serial.println("Communication error");
        sendUdpMsg("ERROR: Communication error");
        break;
      case FINGERPRINT_IMAGEFAIL:
        Serial.println("Imaging error");
        sendUdpMsg("ERROR: Imaging error");
        break;
      default:
        Serial.println("Unknown error");
        sendUdpMsg("ERROR: Unknwn error");
        break;
    }
  }

  // OK success!

  p = finger.image2Tz(1);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      sendUdpMsg("INFO: Image Converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      sendUdpMsg("ERROR: Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      sendUdpMsg("ERROR: Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      sendUdpMsg("ERROR: Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      sendUdpMsg("ERROR: Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      sendUdpMsg("ERROR: Unknown error");
      return p;
  }

  Serial.println("Remove finger");
  sendUdpMsg("INFO: Remove Finger");
  delay(2000);
  p = 0;
  while (p != FINGERPRINT_NOFINGER) {
    p = finger.getImage();
  }
  Serial.print("ID ");
  Serial.println(id);
  p = -1;
  Serial.println("Place same finger again");
  sendUdpMsg("INFO: Place same finger again");
  while (p != FINGERPRINT_OK) {
    p = finger.getImage();
    switch (p) {
      case FINGERPRINT_OK:
        Serial.println("Image taken");
        sendUdpMsg("INFO: Image taken");
        break;
      case FINGERPRINT_NOFINGER:
        Serial.print(".");
        break;
      case FINGERPRINT_PACKETRECIEVEERR:
        Serial.println("Communication error");
        sendUdpMsg("ERROR: Communication error");
        break;
      case FINGERPRINT_IMAGEFAIL:
        Serial.println("Imaging error");
        sendUdpMsg("ERROR: Imaging error");
        break;
      default:
        Serial.println("Unknown error");
        sendUdpMsg("ERROR: Unknown error");
        break;
    }
  }

  // OK success!

  p = finger.image2Tz(2);
  switch (p) {
    case FINGERPRINT_OK:
      Serial.println("Image converted");
      sendUdpMsg("INFO: Image Converted");
      break;
    case FINGERPRINT_IMAGEMESS:
      Serial.println("Image too messy");
      sendUdpMsg("ERROR: Image too messy");
      return p;
    case FINGERPRINT_PACKETRECIEVEERR:
      Serial.println("Communication error");
      sendUdpMsg("ERROR: Communication error");
      return p;
    case FINGERPRINT_FEATUREFAIL:
      Serial.println("Could not find fingerprint features");
      sendUdpMsg("ERROR: Could not find fingerprint features");
      return p;
    case FINGERPRINT_INVALIDIMAGE:
      Serial.println("Could not find fingerprint features");
      sendUdpMsg("ERROR: Could not find fingerprint features");
      return p;
    default:
      Serial.println("Unknown error");
      sendUdpMsg("ERROR: Unknown error");
      return p;
  }

  // OK converted!
  Serial.print("Creating model for #");
  Serial.println(id);
  sendUdpMsg("INFO: Creating model");

  p = finger.createModel();
  if (p == FINGERPRINT_OK) {
    Serial.println("Prints matched!");
    sendUdpMsg("INFO: Both prints matched");
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    sendUdpMsg("ERROR: Communication error");
    return p;
  } else if (p == FINGERPRINT_ENROLLMISMATCH) {
    Serial.println("Fingerprints did not match");
    sendUdpMsg("ERROR: Fingerprints did not match");
    return p;
  } else {
    Serial.println("Unknown error");
    sendUdpMsg("ERROR: Unknown error");
    return p;
  }

  Serial.print("ID ");
  Serial.println(id);
  p = finger.storeModel(id);
  if (p == FINGERPRINT_OK) {
    Serial.println("Stored!");
    sendUdpMsg("RESULT: User Registered successfully with id " + String(id));
  } else if (p == FINGERPRINT_PACKETRECIEVEERR) {
    Serial.println("Communication error");
    sendUdpMsg("ERROR: Communication error");
    return p;
  } else if (p == FINGERPRINT_BADLOCATION) {
    Serial.println("Could not store in that location");
    return p;
  } else if (p == FINGERPRINT_FLASHERR) {
    Serial.println("Error writing to flash");
    sendUdpMsg("ERROR: Error writing to flash");
    return p;
  } else {
    Serial.println("Unknown error");
    sendUdpMsg("ERROR: Unknown error");
    return p;
  }

  return true;
}

void setup(void) {
  Serial.begin(115200);

  WiFi.begin("Sumeru", "sumeru@Jio");
  while (WiFi.status() != WL_CONNECTED) {
    delay(500);
    Serial.print(".");
  }
  Serial.println("");
  Serial.println("WiFi connected");

  Serial.println("HTTP server started");

  udpReceiver.beginMulticast(WiFi.localIP(), addr, 4200);

  initFingerPrintSensor();
}

void loop(void) {
  readBuffer();
}
