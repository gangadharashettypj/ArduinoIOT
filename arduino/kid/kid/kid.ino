#define SS 4
#define DH 2
#define WS A1
#define BUZ 5
#define SERVO1 6

#define R1 12
#define R2 13

#define DHTTYPE DHT11

#define USE_ARDUINO_INTERRUPTS true

#include <SoftwareSerial.h>
#include <Servo.h>
#include "DHT.h"
#include <PulseSensorPlayground.h>

SoftwareSerial MySerial(8, 9);

DHT dht(DH, DHTTYPE);

Servo myservo;


const int PulseWire = 0;  // 'S' Signal pin connected to A0
const int LED13 = 7;      // The on-board Arduino LED
int Threshold = 550;      // Determine which Signal to "count as a beat" and which to ignore

PulseSensorPlayground pulseSensor;

unsigned long int lastTime = -1;

unsigned long int lastTime1 = -1;

unsigned long int lastTime3 = -1;

bool servoFlag = false;

void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);

  myservo.attach(SERVO1);
  myservo.write(0);

  pinMode(R1, OUTPUT);
  pinMode(R2, OUTPUT);
  pinMode(BUZ, OUTPUT);
  pinMode(SS, INPUT);


  pulseSensor.analogInput(PulseWire);
  pulseSensor.blinkOnPulse(LED13);
  pulseSensor.setThreshold(Threshold);

  if (pulseSensor.begin()) {
    Serial.println("PulseSensor object created!");
  }

  dht.begin();
}

void loop() {

  int humi = dht.readHumidity();

  int temp = dht.readTemperature();

  int myBPM = pulseSensor.getBeatsPerMinute();

  bool micData = digitalRead(SS);

  
  int waterData = analogRead(WS);

  if(waterData > 250){
    delay(100);
    waterData = analogRead(WS);
  }

  if (temp > 35) {
    digitalWrite(R1, HIGH);
  } else {
    digitalWrite(R1, LOW);
  }

  if (waterData > 250) {
    digitalWrite(BUZ, HIGH);
  }else{
    digitalWrite(BUZ, LOW);
  }

  if (waterData <= 250 && micData && lastTime1 == -1) {
    lastTime1 = millis();
  }

  if ((millis() - lastTime1) < 15000 && lastTime1 != -1) {
    digitalWrite(R2, HIGH);
    if ((millis() - lastTime3) > 1000) {
      if (servoFlag) {
        for(int i = 0; i < 80; i++){
          myservo.write(i);
          delay(10);
        }
      } else {
        for(int i = 80; i >= 0; i--){
          myservo.write(i);
          delay(10);
        }
      }
      servoFlag = !servoFlag;
      lastTime3 = millis();
    }
  } else {
    digitalWrite(R2, LOW);
    lastTime1 = -1;
    lastTime3 = -1;
  }
  myservo.detach();
  String dataString = "KID," + String(temp) + "," + String(humi) + "," + String(myBPM) + "," + String(waterData) + "," + String(micData);
  MySerial.write(String("<" + dataString + ">").c_str());
  myservo.attach(SERVO1);
  
}
