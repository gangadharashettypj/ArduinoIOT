#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>

#define PH A0
#define ALC A1
#define BUZZER 12
#define RED_LED 11
#define GREEN_LED 10
#define PUSH1 5
#define PUSH2 6

#define DHTPIN 2
#define DHTTYPE DHT11
#include "DHT.h"

DHT dht(DHTPIN, DHTTYPE);

unsigned long int lastLogged = -1;


SoftwareSerial MySerial(9, 8);

LiquidCrystal_I2C lcd(0x3F, 16, 2);

String foodSpoiled = "NA";

int foodSelected = 0;


void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);

  pinMode(RED_LED, OUTPUT);
  pinMode(GREEN_LED, OUTPUT);
  pinMode(BUZZER, OUTPUT);
  pinMode(PUSH1, INPUT);
  pinMode(PUSH2, INPUT);
  dht.begin();


  lcd.init();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(4, 0);
  lcd.print("FOOD SPOIL");
  lcd.setCursor(4, 1);
  lcd.print("DETECTION");
  delay(1000);
}

void loop() {
  int humi = dht.readHumidity();
  int temp = dht.readTemperature();
  int alch = analogRead(ALC);

  int phval = 0;
  unsigned long int avgval;
  int buffer_arr[10], tempVal;

  for (int i = 0; i < 10; i++) {
    buffer_arr[i] = analogRead(A0);
    delay(30);
  }
  for (int i = 0; i < 9; i++) {
    for (int j = i + 1; j < 10; j++) {
      if (buffer_arr[i] > buffer_arr[j]) {
        tempVal = buffer_arr[i];
        buffer_arr[i] = buffer_arr[j];
        buffer_arr[j] = tempVal;
      }
    }
  }
  avgval = 0;
  for (int i = 2; i < 8; i++)
    avgval += buffer_arr[i];
  float volt = (float)avgval * 5.0 / 1024 / 6;
  float ph_act = 3.5 * volt;


  lcd.clear();
  lcd.setCursor(2, 0);
  lcd.print("Select Food");

  if (digitalRead(PUSH1)) {
    while (digitalRead(PUSH1)) delay(10);
    lcd.clear();
    lcd.setCursor(2, 0);
    lcd.print("Food Selected");
    lcd.setCursor(2, 1);
    lcd.print("RICE");
    foodSelected = true;
    delay(1000);
  }
  if (digitalRead(PUSH2)) {
    while (digitalRead(PUSH2)) delay(10);
    lcd.clear();
    lcd.setCursor(2, 0);
    lcd.print("Food Selected");
    lcd.setCursor(2, 1);
    lcd.print("CHATNI");
    foodSelected = true;
    delay(1000);
  }

  if (foodSelected) {


    int count = 15;
    while (count > 0) {
      count--;
      lcd.clear();
      lcd.setCursor(1, 0);
      lcd.print("DIP ELECTRODE");
      lcd.setCursor(1, 7);
      lcd.print(count);
      delay(1000);
    }
    if (ph_act < 4.3) {
      foodSpoiled = "Food Spoiled";
      digitalWrite(BUZZER, HIGH);
      digitalWrite(RED_LED, HIGH);
    } else {
      foodSpoiled = "Good Food";
      digitalWrite(GREEN_LED, HIGH);
    }

    lcd.clear();
    lcd.setCursor(1, 0);
    lcd.print("pH: " + String(ph_act));
    lcd.setCursor(1, 1);
    lcd.print(foodSpoiled);
    delay(4000);
  }


  digitalWrite(GREEN_LED, LOW);
  digitalWrite(RED_LED, LOW);
  digitalWrite(BUZZER, LOW);


  foodSelected = false;
  String str = "<" + String(humi) + "," + String(temp) + "," + String(ph_act) + "," + String(alch) + "," + foodSpoiled + ">";
  if ((millis() - lastLogged) > 1000) {

    // Serial.println(str);
    MySerial.write(str.c_str());
    lastLogged = millis();
  }

  delay(100);
}