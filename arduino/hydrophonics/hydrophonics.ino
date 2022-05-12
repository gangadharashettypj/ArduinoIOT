#define USE_ARDUINO_INTERRUPTS false

#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <EEPROM.h>
#include <Arduino.h>
#include <PulseSensorPlayground.h>



#define addr IPAddress(224,10,10,10)
#define addr1 IPAddress(225,10,10,10)
#define BUFFER_SIZE 512
#define port 4200




char buffer[512];
IPAddress    apIP(10, 10, 10, 1);
WebServer server(80);
String clientServerIP = "10.10.10.2";
String clientServerPort = "2345";



//  BPM
const int OUTPUT_TYPE = SERIAL_PLOTTER;

const int PULSE_INPUT = A0;
const int PULSE_BLINK = LED_BUILTIN;    // Pin 13 is the on-board LED
const int PULSE_FADE = 5;
const int THRESHOLD = 550;   // Adjust this number to avoid noise when idle

byte samplesUntilReport;
const byte SAMPLES_PER_SERIAL_SAMPLE = 10;
// BPM END

//ACC
const int xInput = A6;
const int yInput = A7;
const int zInput = A4;

// initialize minimum and maximum Raw Ranges for each axis
int RawMin = 0;
int RawMax = 1023;

// Take multiple samples to reduce noise
const int sampleSize = 10;
//ACC END

//GSR
const int GSR=A5;

                               
PulseSensorPlayground pulseSensor;  // Creates an instance of the PulseSensorPlayground object called "pulseSensor"

int BPM = 0;

void setIP() {
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void setWaterPump() {
  server.send(200, "text/plain", "success");
}

void setNutritionPump() {
  server.send(200, "text/plain", "success");
}

void setLightState() {
  server.send(200, "text/plain", "success");
}


void getPH(){
//  HTTPClient http;
//  String url = "http://"+clientServerIP+":"+clientServerPort+"/?type=pH&pH="+ pH +"&humidity="+ humidity + "&airTemperature="+ airTemperature + "&waterTemperature="+ waterTemperature;
//  url.replace(" ", "%20");
//  http.begin(url);
//  int httpCode = http.GET();
//  String payload = http.getString();
//  http.end();

}

int getBPM(){
  Serial.print("BPM: ");
  Serial.println(analogRead(PULSE_INPUT));
  return 0;
  if (pulseSensor.sawNewSample()) {
    if (--samplesUntilReport == (byte) 0) {
      samplesUntilReport = SAMPLES_PER_SERIAL_SAMPLE;


      int myBPM = pulseSensor.getBeatsPerMinute();
      Serial.print("BPM: ");
      Serial.println(analogRead(PULSE_INPUT));
      if (pulseSensor.sawStartOfBeat()) {
//        pulseSensor.outputBeat();
        
        return myBPM;
      }
      return 0;
    }
    return 0;
  }
  return 0;
}

void readAcc(){
  //Read raw values
  int xRaw = ReadAxis(xInput);
  int yRaw = ReadAxis(yInput);
  int zRaw = ReadAxis(zInput);

  // Convert raw values to 'milli-Gs"
  long xScaled = map(xRaw, RawMin, RawMax, -1023, 1023);
  long yScaled = map(yRaw, RawMin, RawMax, -1023, 1023);
  long zScaled = map(zRaw, RawMin, RawMax, -1023, 1023);

  Serial.print("X, Y, Z  :: ");
  Serial.print(xRaw);
  Serial.print(", ");
  Serial.print(yRaw);
  Serial.print(", ");
  Serial.println(zRaw);
}

int ReadAxis(int axisPin)
{
  long reading = 0;
  analogRead(axisPin);
  delay(1);
  for (int i = 0; i < sampleSize; i++)
  {
  reading += analogRead(axisPin);
  }
  return reading/sampleSize;
}

float getGSR(){
  float conductivevoltage;
  int sensorValue=analogRead(GSR);
  conductivevoltage = sensorValue*(5.0/1023.0);
  Serial.print("GSR: ");
  Serial.println(sensorValue);
  return sensorValue;
}

int getECG(){
//  if((digitalRead(23) == 1) || (digitalRead(22) == 1)){ //check if leads are removed
//  
//  }
//  else{
    Serial.print("ECG: ");
    Serial.println(analogRead(A3));
    return analogRead(A3);
//  }
}

void setup(void){
  Serial.begin(115200);

  EEPROM.begin(512);
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");

  server.on("/setClientIP", setIP);
  server.on("/waterPump", setWaterPump);
  server.on("/nutritionPump", setNutritionPump);
  server.on("/light", setLightState);

  server.begin();


  //BPM
  pulseSensor.analogInput(PULSE_INPUT);
  pulseSensor.blinkOnPulse(PULSE_BLINK);
  pulseSensor.fadeOnPulse(PULSE_FADE);

  pulseSensor.setSerial(Serial);
  pulseSensor.setOutputType(OUTPUT_TYPE);
  pulseSensor.setThreshold(THRESHOLD);
  
  samplesUntilReport = SAMPLES_PER_SERIAL_SAMPLE;
  //BPM END

  //ecg
  pinMode(23, INPUT); // Setup for leads off detection LO +
  pinMode(22, INPUT); 

}

long int timer = 0;

void loop() {
  server.handleClient();
  getBPM();
  getECG();
  getGSR();
  readAcc();
  Serial.println("");
  Serial.println("");
  Serial.println("");
  delay(1000);
}
