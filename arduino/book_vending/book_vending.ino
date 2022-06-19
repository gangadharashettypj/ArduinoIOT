#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <EEPROM.h>
#include <Arduino.h>
#include <MFRC522.h>
#include <LiquidCrystal_I2C.h>
#include <SPI.h>
#include <MFRC522.h>

#define SS_PIN  4  // ESP32 pin GIOP5 
#define RST_PIN 5 // ESP32 pin GIOP27 
#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200


LiquidCrystal_I2C lcd(0x27, 16, 2);

MFRC522 rfid(SS_PIN, RST_PIN);

String UID = "5A 86 27 AF";
String UID1 = "BA 4B AA B0";

char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
WebServer server(80);
String clientServerIP = "";
String clientServerPort = "2345";


void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void setWaterPump() {
  server.send(200, "text/plain", "success");
  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Selected Book:");
  lcd.setCursor(0,1);
  lcd.print(server.arg("book"));
  delay(2000);

  lcd.clear();
  lcd.setCursor(0,0);
  lcd.print("Place your card:");

  while(true){
    if ( ! rfid.PICC_IsNewCardPresent())
      continue;
    if ( ! rfid.PICC_ReadCardSerial())
      continue;
  
    String ID = "";
    for (byte i = 0; i < rfid.uid.size; i++) {
      lcd.print(".");
      ID.concat(String(rfid.uid.uidByte[i] < 0x10 ? " 0" : " "));
      ID.concat(String(rfid.uid.uidByte[i], HEX));
      delay(300);
    }
    ID.toUpperCase();
    Serial.println(ID);
  
    if (ID.substring(1) == UID) {
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Card Detected");
      lcd.setCursor(0,1);
      lcd.print("Press Enter!");

      while(digitalRead(15)) delay(10);
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Dispatching book");
      digitalWrite(server.arg("pin").toInt(), HIGH);
      delay(2000);
      digitalWrite(server.arg("pin").toInt(), LOW);
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Book Dispatched");
      lcd.setCursor(0,1);
      lcd.print("Thank You!");
      
      delay(2000);
    } else{
      lcd.clear();
      lcd.setCursor(0,0);
      lcd.print("Wrong Card");
      delay(2000);
    }
    lcd.clear();
    lcd.print("Welcome to BVM!");
    break;
  }
}

void setup(void){
  Serial.begin(115200);

  EEPROM.begin(512);
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("Book", "");

  server.on("/setClientIP", setIP);
  server.on("/bookSelected", setWaterPump);

  server.begin();
  lcd.begin();
  lcd.backlight();
  delay(1000);
  SPI.begin();
  rfid.PCD_Init();

  pinMode(15, INPUT_PULLUP);
  pinMode(13, OUTPUT);
  pinMode(12, OUTPUT);
  pinMode(14, OUTPUT);
  pinMode(27, OUTPUT);
  pinMode(26, OUTPUT);
  pinMode(25, OUTPUT);
  pinMode(33, OUTPUT);
  pinMode(32, OUTPUT);
  pinMode(2, OUTPUT);
  lcd.clear();
  lcd.print("Welcome to BVM!");
}


long long int lastTime = 0;

void loop() {
  server.handleClient();

 

  if((millis() - lastTime ) > 3000){
    lastTime = millis();
    
  }
  
}
