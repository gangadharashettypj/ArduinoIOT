#include <SoftwareSerial.h>
#include <LiquidCrystal_I2C.h>
#include "DHT.h"

#define DHTTYPE DHT11


const byte numChars = 200;
char receivedChars[numChars];

LiquidCrystal_I2C lcd(0x27, 16, 2);

SoftwareSerial MySerial(12, 13);

bool newData = false;

#define SP_1 50
#define SP_2 44
#define SP_3 46

#define SOIL_1 A2
#define SOIL_2 A1
#define SOIL_3 A0

#define DHTP_1 7
#define DHTP_2 8
#define DHTP_3 2

#define LDR_1 26
#define LDR_2 24
#define LDR_3 22

#define TEMP_R_1 36
#define TEMP_R_2 34
#define TEMP_R_3 32

#define LDR_R_1 42
#define LDR_R_2 40
#define LDR_R_3 38

#define SOIL_R_1 30
#define SOIL_R_2 28
#define SOIL_R_3 48


DHT dht1(DHTP_1, DHTTYPE);
DHT dht2(DHTP_2, DHTTYPE);
DHT dht3(DHTP_3, DHTTYPE);

int t1, t2, t3, h1, h2, h3;
int s1, s2, s3;
bool l1 = true, l2 = true, l3 = true;
bool sp1 = true, sp2 = true, sp3 = true;

void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);

  pinMode(SP_1, OUTPUT);
  pinMode(SP_2, OUTPUT);
  pinMode(SP_3, OUTPUT);

  pinMode(TEMP_R_1, OUTPUT);
  pinMode(TEMP_R_2, OUTPUT);
  pinMode(TEMP_R_3, OUTPUT);

  pinMode(SOIL_R_1, OUTPUT);
  pinMode(SOIL_R_2, OUTPUT);
  pinMode(SOIL_R_3, OUTPUT);

  pinMode(LDR_R_1, OUTPUT);
  pinMode(LDR_R_2, OUTPUT);
  pinMode(LDR_R_3, OUTPUT);

  digitalWrite(LDR_R_1, HIGH);
  digitalWrite(LDR_R_2, HIGH);
  digitalWrite(LDR_R_3, HIGH);

  digitalWrite(SOIL_R_1, HIGH);
  digitalWrite(SOIL_R_2, HIGH);
  digitalWrite(SOIL_R_3, HIGH);

  digitalWrite(TEMP_R_1, HIGH);
  digitalWrite(TEMP_R_2, HIGH);
  digitalWrite(TEMP_R_3, HIGH);

  pinMode(LDR_1, INPUT);
  pinMode(LDR_2, INPUT);
  pinMode(LDR_3, INPUT);

  dht1.begin();
  dht2.begin();
  dht3.begin();


  lcd.init();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(3, 0);
  lcd.print("WELCOME TO");
  lcd.setCursor(3, 1);
  lcd.print("GREEN HOUSE");
  delay(1000);
}


unsigned long int last = 0;

void processData() {

  String str = String(receivedChars);
  Serial.println(str);
  last = -1;
  if (str == "SPRINKLER1_ON") {
    sp1 = false;
  }
  if (str == "SPRINKLER2_ON") {
    sp2 = false;
  }
  if (str == "SPRINKLER3_ON") {
    sp3 = false;
  }
  if (str == "SPRINKLER1_OFF") {
    sp1 = true;
  }
  if (str == "SPRINKLER2_OFF") {
    sp2 = true;
  }
  if (str == "SPRINKLER3_OFF") {
    sp3 = true;
  }
  newData = false;
}

void readDht() {
  dht1.read(DHTP_1);
  dht2.read(DHTP_2);
  dht3.read(DHTP_3);

  t1 = dht1.readTemperature();
  t2 = dht2.readTemperature();
  t3 = dht3.readTemperature();
  h1 = dht1.readHumidity();
  h2 = dht2.readHumidity();
  h3 = dht3.readHumidity();

  digitalWrite(TEMP_R_1, t1 <= 35);
  digitalWrite(TEMP_R_2, t2 <= 35);
  digitalWrite(TEMP_R_3, t3 <= 35);
}

void readSoil() {
  s1 = map(analogRead(SOIL_1), 1023, 0, 100, 0);
  s2 = map(analogRead(SOIL_2), 1023, 0, 100, 0);
  s3 = map(analogRead(SOIL_3), 1023, 0, 100, 0);

  digitalWrite(SOIL_R_1, s1 > 80);
  digitalWrite(SOIL_R_2, s2 > 80);
  digitalWrite(SOIL_R_3, s3 > 80);
}


void readLDR() {
  l1 = digitalRead(LDR_1);
  l2 = digitalRead(LDR_2);
  l3 = digitalRead(LDR_3);

  digitalWrite(LDR_R_1, l1);
  digitalWrite(LDR_R_2, l2);
  digitalWrite(LDR_R_3, l3);
}


void sendData() {
  String fd1 = l1 ? "true" : "false";
  String fd2 = l2 ? "true" : "false";
  String fd3 = l3 ? "true" : "false";
  String fs1 = sp1 ? "true" : "false";
  String fs2 = sp2 ? "true" : "false";
  String fs3 = sp3 ? "true" : "false";

  String data = "<[{\"sprinkler\":" + fs1 + ",\"humidity\":\"" + String(h1) + "\",\"temp\":\"" + String(t1) + "\",\"soil\":\"" + String(s1) + "\",\"light\":" + fd1 + "},    {\"sprinkler\":" + fs2 + ",\"humidity\":\"" + String(h2) + "\",\"temp\":\"" + String(t2) + "\",\"soil\":\"" + String(s2) + "\",\"light\":" + String(fd2) + "},   {\"sprinkler\":" + fs3 + ",\"humidity\":\"" + String(h3) + "\",\"temp\":\"" + String(t3) + "\",\"soil\":\"" + String(s3) + "\",\"light\":" + fd3 + "}]>";
  Serial.println(data);
  MySerial.write(data.c_str());
}


void loop() {

  recvWithStartEndMarkers();
  if (newData) {
    processData();
  }


  digitalWrite(SP_1, sp1);
  digitalWrite(SP_2, sp2);
  digitalWrite(SP_3, sp3);

  if ((millis() - last) > 5000) {
    readDht();
    readSoil();
    readLDR();
    sendData();

    lcd.init();
    lcd.clear();
    lcd.backlight();
    lcd.setCursor(0, 0);
    lcd.print("S1: " + String(100 - s1) + "  S2: " + String(100 - s2));
    lcd.setCursor(0, 1);
    lcd.print("S3: " + String(100 - s3) + " Wetness");

    last = millis();
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
