#include <SPI.h>
#include <MFRC522.h>
#include <Wire.h>
#include <LiquidCrystal_I2C.h>
// Set the LCD address to 0x27 for a 16 chars and 2 line display
LiquidCrystal_I2C lcd(0x27, 16, 2);
#define SS_PIN 10
#define RST_PIN 9
#define LED_G 5 //define green LED pin
#define LED_R 4 //define red LED pin
#define BUZZER 2 //buzzer pin
MFRC522 mfrc522(SS_PIN, RST_PIN);  // Create MFRC522 instance.
void setup()
{
Serial.begin(9600);  // Initiate a serial communication
SPI.begin();   // Initiate SPI bus
mfrc522.PCD_Init();  // Initiate MFRC522
lcd.begin();
lcd.backlight(); // Turn on the blacklight and print a message.
pinMode(LED_G, OUTPUT);
pinMode(LED_R, OUTPUT);
pinMode(BUZZER, OUTPUT);
noTone(BUZZER);
}
void loop()
{
// Look for new cards
if ( ! mfrc522.PICC_IsNewCardPresent())
{
lcd.setCursor(3,0);
lcd.print("SHOW YOUR");
lcd.setCursor(4,1);
lcd.print("ID CARD");
return;
}
else{
lcd.clear();
}
// Select one of the cards
if ( ! mfrc522.PICC_ReadCardSerial())
{
return;
}
//Show UID on serial monitor
Serial.print("UID tag :");
String content= "";
byte letter;
for (byte i = 0; i < mfrc522.uid.size; i++)
{
Serial.print(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " ");
Serial.print(mfrc522.uid.uidByte[i], HEX);
content.concat(String(mfrc522.uid.uidByte[i] < 0x10 ? " 0" : " "));
content.concat(String(mfrc522.uid.uidByte[i], HEX));
}
Serial.println();
content.toUpperCase();
if (content.substring(1) == "C6 5D 66 FA") //change here the UID of the card/cards that you want to give access
{
lcd.print("STUDENT 01");
lcd.setCursor(0,1);
lcd.print("PRESENT");
digitalWrite(LED_G, HIGH);
tone(BUZZER, 500);
delay(300);
noTone(BUZZER);
delay(3000);
digitalWrite(LED_G, LOW);
lcd.clear();
}
else if (content.substring(1) == "E2 C7 4D 1A") //change here the UID of the card/cards that you want to give access
{
lcd.print("STUDENT 02");
lcd.setCursor(0,1);
lcd.print("PRESENT");
digitalWrite(LED_G, HIGH);
tone(BUZZER, 500);
delay(300);
noTone(BUZZER);
delay(3000);
digitalWrite(LED_G, LOW);
lcd.clear();
}
else if (content.substring(1) == "59 B3 80 C2") //change here the UID of the card/cards that you want to give access
{
lcd.print("STUDENT 03");
lcd.setCursor(0,1);
lcd.print("PRESENT");
digitalWrite(LED_G, HIGH);
tone(BUZZER, 500);
delay(300);
noTone(BUZZER);
delay(3000);
digitalWrite(LED_G, LOW);
lcd.clear();
}
else  {
lcd.print("UNAUTHORIZE");
lcd.setCursor(0,1);
lcd.print("ACCESS");
digitalWrite(LED_R, HIGH);
tone(BUZZER, 300);
delay(2000);
digitalWrite(LED_R, LOW);
noTone(BUZZER);
lcd.clear();
}
}