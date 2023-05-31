#include <LiquidCrystal_I2C.h>
#include <SoftwareSerial.h>
#include <PZEM004Tv30.h>

#define FLOW 2
#define RELAY 13
#define PUSH 6
#define BUZZER 4

unsigned long int lastTime = -1;
unsigned long int lastLogged = -1;

bool motor = false;

const float OffSet = 0.483;


SoftwareSerial MySerial(9, 8);

LiquidCrystal_I2C lcd(0x27, 16, 2);


PZEM004Tv30 pzem(11, 12);

void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);

  pinMode(BUZZER, OUTPUT);
  pinMode(RELAY, OUTPUT);
  pinMode(PUSH, INPUT);
  digitalWrite(FLOW, HIGH);

  attachInterrupt(digitalPinToInterrupt(FLOW), flow, RISING);  // Setup Interrupt

  digitalWrite(BUZZER, LOW);

  lcd.init();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(4, 0);
  lcd.print("DRY RUN");
  lcd.setCursor(2, 1);
  lcd.print("DETECTION");
  delay(1000);
}

void loop() {
  bool waterFlow = false;
  if ((millis() - lastTime) < 5000) {
    waterFlow = true;
  } else {
    if (motor) {
      lcd.clear();
      lcd.setCursor(4, 0);
      lcd.print("DRY RUN");
      digitalWrite(BUZZER, HIGH);
      delay(3000);
      digitalWrite(BUZZER, LOW);
    }
    motor = false;
  }


  if (digitalRead(6)) {
    while (digitalRead(6)) delay(10);
    motor = !motor;
    lastTime = millis();
  }

  digitalWrite(13, motor);

  float voltage = pzem.voltage();

  float power = pzem.power();

  float V = analogRead(A0) * 5.00 / 1024;  //Sensor output voltage
  float P = (V - OffSet) * 400;

  if(P < 0){
    P = 0;
  }

  // Serial.println(String(voltage) + "," + String(power));

  String str = "<" + String(waterFlow) + "," + String(motor) + "," + String(voltage) + "," + String(power) + "," + String(P) + ">";
  if ((millis() - lastLogged) > 1000) {

    lcd.clear();
    lcd.setCursor(0, 0);

    if (motor)
      lcd.print("MOTOR: ON");
    else lcd.print("MOTOR: OFF");


    Serial.println(str);
    MySerial.write(str.c_str());
    lastLogged = millis();
  }

  delay(100);
}


void flow() {
  lastTime = millis();
}