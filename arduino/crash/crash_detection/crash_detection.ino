#include <Wire.h>
#include "SD.h"
#include "SPI.h"
#include <TinyGPS++.h>
#include <SoftwareSerial.h>

int GPSBaud = 9600;

TinyGPSPlus gps;

SoftwareSerial mySerial(8, 9);

String lat = "", lon = "", dateG = "", timeG = "";

#define T1P 6
#define T2P 5
#define CP 7
#define FP 3
#define AP 4

const int MPU = 0x68;
float AccX, AccY, AccZ;
float AccErrorX, AccErrorY;
int c = 0;


const int CSpin = 53;
String dataString = "";       // holds the data to be written to the SD card
float sensorReading1 = 0.00;  // value read from your first sensor
float sensorReading2 = 0.00;  // value read from your second sensor
float sensorReading3 = 0.00;  // value read from your third sensor
File sensorData;


void setup() {
  pinMode(T1P, INPUT);
  pinMode(T2P, INPUT);
  pinMode(CP, INPUT);
  pinMode(FP, INPUT);
  pinMode(AP, INPUT);

  Serial.begin(19200);
  mySerial.begin(19200);
  Serial1.begin(9600);
  Serial1.begin(GPSBaud);

  Wire.begin();                 // Initialize comunication
  Wire.beginTransmission(MPU);  // Start communication with MPU6050 // MPU=0x68
  Wire.write(0x6B);             // Talk to the register 6B
  Wire.write(0x00);             // Make reset - place a 0 into the 6B register
  Wire.endTransmission(true);

  calculate_IMU_error();
  delay(20);


  Serial.println("Initializing SD card...");
  pinMode(CSpin, OUTPUT);
  //
  // see if the card is present and can be initialized:
  if (!SD.begin(CSpin)) {
    Serial.println("Card failed, or not present");
    // don't do anything more:
    return;
  }
  Serial.println("card initialized.");

  sensorData = SD.open("data.csv", FILE_WRITE);
  sensorData.close();
}

void loop() {
  getAccData();

  getGPSData();

  processAndSave();


  // displayInfo();


  // delay(1000);
}

void processAndSave() {
  if (!digitalRead(CP)) {
    while (!digitalRead(CP)) delay(100);
    dataString = "Crash," + dateG + "," + timeG + "," + lat + "," + lon + "," + String(AccX) + "," + String(AccY) + "," + String(AccZ);
    mySerial.write(String("<" + dataString + ">").c_str());
    saveData();
  }
  if (!digitalRead(FP)) {
    while (!digitalRead(FP)) delay(100);
    dataString = "Flame," + dateG + "," + timeG + "," + lat + "," + lon + "," + String(AccX) + "," + String(AccY) + "," + String(AccZ);
    mySerial.write(String("<" + dataString + ">").c_str());
    saveData();
  }
  if (!digitalRead(AP)) {
    while (!digitalRead(AP)) delay(100);
    dataString = "Alchoal," + dateG + "," + timeG + "," + lat + "," + lon + "," + String(AccX) + "," + String(AccY) + "," + String(AccZ);
    mySerial.write(String("<" + dataString + ">").c_str());
    saveData();
  }
  if (!digitalRead(T1P)) {
    while (!digitalRead(T1P)) delay(100);
    dataString = "Left Tilt," + dateG + "," + timeG + "," + lat + "," + lon + "," + String(AccX) + "," + String(AccY) + "," + String(AccZ);
    mySerial.write(String("<" + dataString + ">").c_str());
    saveData();
  }
  if (!digitalRead(T2P)) {
    while (!digitalRead(T2P)) delay(100);
    dataString = "Right Tilt," + dateG + "," + timeG + "," + lat + "," + lon + "," + String(AccX) + "," + String(AccY) + "," + String(AccZ);
    mySerial.write(String("<" + dataString + ">").c_str());
    saveData();
  }
}

void displayInfo() {
  Serial.println(digitalRead(T1P));
  Serial.println(digitalRead(T2P));
  Serial.println(digitalRead(CP));
  Serial.println(digitalRead(FP));
  Serial.println(digitalRead(AP));
  Serial.println(AccX);
  Serial.println(AccY);
  Serial.println(AccX);
  Serial.println(lat);
  Serial.println(lon);
  Serial.println();
  Serial.println();
  Serial.println();
}

void getAccData() {
  Wire.beginTransmission(MPU);
  Wire.write(0x3B);  // Start with register 0x3B (ACCEL_XOUT_H)
  Wire.endTransmission(false);
  Wire.requestFrom(MPU, 6, true);  // Read 6 registers total, each axis value is stored in 2 registers
  //For a range of +-2g, we need to divide the raw values by 16384, according to the datasheet
  AccX = (Wire.read() << 8 | Wire.read()) / 16384.0;  // X-axis value
  AccY = (Wire.read() << 8 | Wire.read()) / 16384.0;  // Y-axis value
  AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0;  // Z-axis value
}

void getGPSData() {
  while (Serial1.available() > 0) {
    if (gps.encode(Serial1.read())) {
      // displayInfo1();
      if (gps.location.isValid()) {
        lat = String(gps.location.lat(), 6);
        lon = String(gps.location.lng(), 6);
      }

      if (gps.date.isValid()) {
        dateG = String(gps.date.day()) + "/" + String(gps.date.month()) + "/" + String(gps.date.year());
      }

      if (gps.time.isValid()) {
        timeG = String(gps.time.hour()) + ":" + String(gps.time.minute()) + ":" + String(gps.time.second());
      }
    }
  }
  if (millis() > 5000 && gps.charsProcessed() < 10) {
    Serial.println("No GPS detected");
    while (true)
      ;
  }
}


void displayInfo1() {
  if (gps.location.isValid()) {
    Serial.print("Latitude: ");
    Serial.println(gps.location.lat(), 6);
    Serial.print("Longitude: ");
    Serial.println(gps.location.lng(), 6);
    Serial.print("Altitude: ");
    Serial.println(gps.altitude.meters());
  } else {
    Serial.println("Location: Not Available");
  }

  Serial.print("Date: ");
  if (gps.date.isValid()) {
    Serial.print(gps.date.month());
    Serial.print("/");
    Serial.print(gps.date.day());
    Serial.print("/");
    Serial.println(gps.date.year());
  } else {
    Serial.println("Not Available");
  }

  Serial.print("Time: ");
  if (gps.time.isValid()) {
    if (gps.time.hour() < 10) Serial.print(F("0"));
    Serial.print(gps.time.hour());
    Serial.print(":");
    if (gps.time.minute() < 10) Serial.print(F("0"));
    Serial.print(gps.time.minute());
    Serial.print(":");
    if (gps.time.second() < 10) Serial.print(F("0"));
    Serial.print(gps.time.second());
    Serial.print(".");
    if (gps.time.centisecond() < 10) Serial.print(F("0"));
    Serial.println(gps.time.centisecond());
  } else {
    Serial.println("Not Available");
  }

  Serial.println();
  Serial.println();
  delay(1000);
}

void calculate_IMU_error() {
  // We can call this funtion in the setup section to calculate the accelerometer and gyro data error. From here we will get the error values used in the above equations printed on the Serial Monitor.
  // Note that we should place the IMU flat in order to get the proper values, so that we then can the correct values
  // Read accelerometer values 200 times
  while (c < 200) {
    Wire.beginTransmission(MPU);
    Wire.write(0x3B);
    Wire.endTransmission(false);
    Wire.requestFrom(MPU, 6, true);
    AccX = (Wire.read() << 8 | Wire.read()) / 16384.0;
    AccY = (Wire.read() << 8 | Wire.read()) / 16384.0;
    AccZ = (Wire.read() << 8 | Wire.read()) / 16384.0;
    // Sum all readings
    AccErrorX = AccErrorX + ((atan((AccY) / sqrt(pow((AccX), 2) + pow((AccZ), 2))) * 180 / PI));
    AccErrorY = AccErrorY + ((atan(-1 * (AccX) / sqrt(pow((AccY), 2) + pow((AccZ), 2))) * 180 / PI));
    c++;
  }
  //Divide the sum by 200 to get the error value
  AccErrorX = AccErrorX / 200;
  AccErrorY = AccErrorY / 200;

  Serial.print("AccErrorX: ");
  Serial.println(AccErrorX);
  Serial.print("AccErrorY: ");
  Serial.println(AccErrorY);
}

void saveData() {
  if (SD.exists("data.csv")) {  // check the card is still there
    // now append new data file
    sensorData = SD.open("data.csv", FILE_WRITE);
    if (sensorData) {
      sensorData.println(dataString);
      sensorData.close();  // close the file
    }

    Serial.println("Data Saved: " + dataString);
    dataString = "";
  } else {
    Serial.println("Error writing to file !");
  }
}