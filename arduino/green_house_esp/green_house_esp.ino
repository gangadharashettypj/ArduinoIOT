#include <Arduino.h>
#include <ESP8266WiFi.h>
#include <FirebaseESP8266.h>

#include <addons/TokenHelper.h>

#include <addons/RTDBHelper.h>

#define WIFI_SSID "Gangadhar"
#define WIFI_PASSWORD "gs@airtel"

#define API_KEY "AIzaSyACT02uBKOnSN1dGXSOW0eXjmEnbueUwkE"

#define DATABASE_URL "vish-7b9b2.firebaseio.com"

#define USER_EMAIL "hardware@gmail.com"
#define USER_PASSWORD "12345678"

FirebaseData fbdo;
FirebaseAuth auth;
FirebaseConfig config;


FirebaseData stream1;
FirebaseData stream2;
FirebaseData stream3;

#include <SoftwareSerial.h>

const byte numChars = 500;
char receivedChars[numChars];
char tempChars[numChars];

boolean newData = false;

SoftwareSerial MySerial(D2, D3);

FirebaseData fbdo1;

void setup() {

  Serial.begin(115200);
  MySerial.begin(19200);

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);

  Serial.print("Connecting to Wi-Fi");
  unsigned long ms = millis();
  while (WiFi.status() != WL_CONNECTED) {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  config.api_key = API_KEY;


  config.database_url = DATABASE_URL;

  config.token_status_callback = tokenStatusCallback;

  Firebase.reconnectNetwork(true);

  fbdo.setBSSLBufferSize(4096, 1024);

  Firebase.begin(&config, &auth);

  Firebase.setDoubleDigits(5);

  if (!Firebase.beginStream(fbdo1, "/GREEN_HOUSE_SPRINKLER"))
    Serial.printf("sream begin error, %s\n\n", fbdo1.errorReason().c_str());
}


void loop() {

  recvWithStartEndMarkers();

  if (Firebase.ready() && newData) {

    Serial.println(receivedChars);
    newData = false;

    FirebaseJson json;
    json.setJsonData(receivedChars);

    Serial.printf("Set json... %s\n", Firebase.set(fbdo, F("/GREEN_HOUSE"), json) ? "ok" : fbdo.errorReason().c_str());
    Serial.println();
  }

  if (Firebase.ready()) {
    if (!Firebase.readStream(fbdo1))
      Serial.printf("sream read error, %s\n\n", fbdo1.errorReason().c_str());

    if (fbdo1.streamTimeout()) {
      Serial.println("stream timed out, resuming...\n");

      if (!fbdo1.httpConnected())
        Serial.printf("error code: %d, reason: %s\n\n", fbdo1.httpCode(), fbdo1.errorReason().c_str());
    }

    if (fbdo1.streamAvailable()) {
      Serial.printf("sream path, %s\nevent path, %s\ndata type, %s\nevent type, %s\nvalue, %s\n\n",
                    fbdo1.streamPath().c_str(),
                    fbdo1.dataPath().c_str(),
                    fbdo1.dataType().c_str(),
                    fbdo1.eventType().c_str(),
                    fbdo1.stringData().c_str());
      if (fbdo1.dataPath() == "/0") {
        if (fbdo1.boolData() == true) {
          MySerial.write("<SPRINKLER1_ON>");
        } else {
          MySerial.write("<SPRINKLER1_OFF>");
        }
      }
      if (fbdo1.dataPath() == "/1") {
        if (fbdo1.boolData() == true) {
          MySerial.write("<SPRINKLER2_ON>");
        } else {
          MySerial.write("<SPRINKLER2_OFF>");
        }
      }
      if (fbdo1.dataPath() == "/2") {
        if (fbdo1.boolData() == true) {
          MySerial.write("<SPRINKLER3_ON>");
        } else {
          MySerial.write("<SPRINKLER3_OFF>");
        }
      }
    }
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
      } else {
        receivedChars[ndx] = '\0';  // terminate the string
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
