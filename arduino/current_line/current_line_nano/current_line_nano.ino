#include <SPI.h>
#include <MFRC522.h>
#include <SoftwareSerial.h>
#include <LiquidCrystal_I2C.h>
#include <Servo.h>

#define GREEN 2
#define RED 3

const byte numChars = 200;
char receivedChars[numChars];

Servo myservo;

LiquidCrystal_I2C lcd(0x3F, 16, 2);

boolean newData = false;
#define SS_PIN 10
#define RST_PIN 9

MFRC522 rfid(SS_PIN, RST_PIN);

MFRC522::MIFARE_Key key;

SoftwareSerial MySerial(7, 8);

bool isOpen = false;

bool oldStatus = true;

float currentValue = 0;

String loadStatus = "";

String oldLoadStatus = "-";

unsigned long int lastTime = -1;

void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);

  SPI.begin();
  rfid.PCD_Init();

  pinMode(GREEN, OUTPUT);
  pinMode(RED, OUTPUT);

  myservo.attach(5);

  lcd.init();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(3, 0);
  lcd.print("WELCOME TO");
  lcd.setCursor(2, 1);
  lcd.print("B E S C O M");
  delay(1000);
}

void readCurrent() {
  float AcsValue = 0.0, Samples = 0.0, AvgAcs = 0.0, AcsValueF = 0.0;

  for (int x = 0; x < 150; x++) {
    AcsValue = analogRead(A0);
    Samples = Samples + AcsValue;
    delay(3);
  }
  AvgAcs = Samples / 150.0;
  currentValue = (2.5 - (AvgAcs * (5 / 1024.0))) / 0.185;

  currentValue = (-1 * currentValue) + 0.25;

  if (currentValue > 0.45) {
    loadStatus = "OVER LOAD: " + String(currentValue);
  } else {
    loadStatus = "LOAD: " + String(currentValue);
  }
}

void loop() {

  readCurrent();

  recvWithStartEndMarkers();

  checkRFCARD();

  if (oldStatus != isOpen || loadStatus != oldLoadStatus) {

    lcd.clear();
    if (isOpen) {
      digitalWrite(GREEN, LOW);
      digitalWrite(RED, HIGH);

      myservo.write(0);

      lcd.setCursor(0, 0);
      lcd.print("OPEN CIRCUIT");
    } else {
      digitalWrite(GREEN, HIGH);
      digitalWrite(RED, LOW);

      myservo.write(90);

      lcd.setCursor(0, 0);
      lcd.print("CLOSED CIRCUIT");
    }

    if (loadStatus != "") {
      lcd.setCursor(0, 1);
      lcd.print(loadStatus.c_str());
    }
  }



  oldLoadStatus = loadStatus;
  oldStatus = isOpen;

  if ((millis() - lastTime) > 1500) {
    lastTime = millis();
    myservo.detach();
    String str = "<" + String(loadStatus.c_str()) + "," + String(isOpen) + ">";
    // Serial.println(str);
    MySerial.write(str.c_str());
    myservo.attach(5);
  }

  if (newData) {
    newData = false;
    if (String(receivedChars).startsWith("NEGATE")) {
      isOpen = !isOpen;
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



void checkRFCARD() {
  if (!rfid.PICC_IsNewCardPresent())
    return;

  if (!rfid.PICC_ReadCardSerial())
    return;

  MFRC522::PICC_Type piccType = rfid.PICC_GetType(rfid.uid.sak);

  if (piccType != MFRC522::PICC_TYPE_MIFARE_MINI && piccType != MFRC522::PICC_TYPE_MIFARE_1K && piccType != MFRC522::PICC_TYPE_MIFARE_4K) {
    Serial.println(F("Your tag is not of type MIFARE Classic."));
    return;
  }
  String strUID0 = String(rfid.uid.uidByte[0]) + " " + String(rfid.uid.uidByte[1]) + " " + String(rfid.uid.uidByte[2]) + " " + String(rfid.uid.uidByte[3]);
  if (strUID0 == "242 206 200 203") {
    if (isOpen) {
      isOpen = false;
    } else {
      isOpen = true;
    }
  }


  // Halt PICC
  rfid.PICC_HaltA();

  // Stop encryption on PCD
  rfid.PCD_StopCrypto1();
}
