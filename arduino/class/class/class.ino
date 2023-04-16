#include <SoftwareSerial.h>
#include <LiquidCrystal_I2C.h>
#include <SPI.h>
#include <MFRC522.h>
#include <Wire.h>

LiquidCrystal_I2C lcd(0x27, 16, 2);

unsigned long lastTime = 0;

const byte rxPin = 9;
const byte txPin = 8;

// Set up a new SoftwareSerial object
SoftwareSerial mySerial(rxPin, txPin);

#define SS_PIN 10
#define RST_PIN A0
#define LED_R A1

MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance.

bool s1 = false;
bool s2 = false;
bool s3 = false;
bool s4 = false;

bool classGoingOn = true;


void setup() {

  Serial.begin(115200);
  mySerial.begin(115200);
  lcd.init();
  lcd.backlight();
  SPI.begin();         // Initiate SPI bus
  mfrc522.PCD_Init();  // Initiate MFRC522
  pinMode(LED_R, OUTPUT);

  pinMode(6, OUTPUT);
  pinMode(5, OUTPUT);

  lcd.setCursor(1, 0);
  lcd.print("Welcome to CIT");
  lcd.setCursor(3, 1);
  lcd.print("EEE CLASS");
  delay(2000);
  lcd.clear();
}


void loop() {

  String str = "<ABC," + String(s1) + "," + String(s2) + "," + String(s3) + "," + String(s4) + ",dsfk>";
  mySerial.write(str.c_str());

  if (classGoingOn) {
    if ((millis() - lastTime) > 180000) {
      classGoingOn = false;
      lastTime = millis();
      lcd.clear();
    }
  } else {
    if ((millis() - lastTime) > 60000) {
      classGoingOn = true;
      lastTime = millis();
      lcd.clear();
    }
  }

  // Look for new cards
  if (!mfrc522.PICC_IsNewCardPresent()) {

    if (classGoingOn) {
      lcd.setCursor(3, 0);
      lcd.print("SHOW YOUR");
      lcd.setCursor(4, 1);
      lcd.print("ID CARD");
    } else {
      lcd.setCursor(6, 0);
      lcd.print("LUNCH");
      lcd.setCursor(6, 1);
      lcd.print("BREAK");
    }

    return;
  } else {
    lcd.clear();
  }
  // Select one of the cards
  if (!mfrc522.PICC_ReadCardSerial()) {
    return;
  }
  //Show UID on serial monitor
  Serial.print("UID tag :");
  String content = "";
  byte letter;
  for (byte i = 0; i < mfrc522.uid.size; i++) {
    Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
    Serial.print(mfrc522.uid.uidByte[i], HEX);
    content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
    content.concat(String(mfrc522.uid.uidByte[i], HEX));
  }
  Serial.println();
  content.toUpperCase();
  unsigned long int timeDiff = (millis() - lastTime) / 1000;
  if (!classGoingOn) {
    return;
  }
  Serial.println(timeDiff);
  if (content.substring(1) == "C6 5D 66 FA")  //change here the UID of the card/cards that you want to give access
  {
    if (timeDiff <= 60) {
      s1 = true;
      lcd.print("DARSHAN");
      lcd.setCursor(0, 1);
      lcd.print("PRESENT");
      delay(2000);
      lcd.clear();
    } else if (timeDiff <= 120) {
      s1 = true;
      lcd.print("DARSHAN");
      lcd.setCursor(0, 1);
      lcd.print("ONOGING");
      delay(2000);
      lcd.clear();
    } else {
      lcd.print("You are late");
      delay(2000);
      lcd.clear();
    }

  } else if (content.substring(1) == "E2 C7 4D 1A")  //change here the UID of the card/cards that you want to give access
  {
    if (timeDiff <= 60) {
      s2 = true;
      lcd.print("KANISHKA");
      lcd.setCursor(0, 1);
      lcd.print("PRESENT");
      delay(2000);
      lcd.clear();
    } else if (timeDiff <= 120) {
      s2 = true;
      lcd.print("KANISHKA");
      lcd.setCursor(0, 1);
      lcd.print("ONOGING");
      delay(2000);
      lcd.clear();
    } else {

      lcd.print("You are late");
      delay(2000);
      lcd.clear();
    }
  } else if (content.substring(1) == "59 B3 80 C2")  //change here the UID of the card/cards that you want to give access
  {
    if (timeDiff <= 60) {
      s3 = true;
      lcd.print("MANOJ");
      lcd.setCursor(0, 1);
      lcd.print("PRESENT");
      delay(2000);
      lcd.clear();
    } else if (timeDiff <= 120) {
      s3 = true;
      lcd.print("MANOJ");
      lcd.setCursor(0, 1);
      lcd.print("ONOGING");
      delay(2000);
      lcd.clear();
    } else {

      lcd.print("You are late");
      delay(2000);
      lcd.clear();
    }
  } else if (content.substring(1) == "40 67 68 1B")  //change here the UID of the card/cards that you want to give access
  {
    if (timeDiff <= 60) {
      s4 = true;
      lcd.print("SANDEEP");
      lcd.setCursor(0, 1);
      lcd.print("PRESENT");
      delay(2000);
      lcd.clear();
    } else if (timeDiff <= 120) {
      s4 = true;
      lcd.print("SANDEEP");
      lcd.setCursor(0, 1);
      lcd.print("ONOGING");
      delay(2000);
      lcd.clear();
    } else {

      lcd.print("You are late");
      delay(2000);
      lcd.clear();
    }
  } else {
    lcd.print("UNAUTHORIZE");
    lcd.setCursor(0, 1);
    lcd.print("STUDENT");
    digitalWrite(LED_R, HIGH);
    delay(2000);
    digitalWrite(LED_R, LOW);
    lcd.clear();
  }
  delay(1000);
}
