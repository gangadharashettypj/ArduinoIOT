#include <WiFi.h>
#include <WiFiClient.h>
#include <WebServer.h>
#include <HTTPClient.h>
#include <EEPROM.h>
#include <Arduino.h>

#include <Wire.h>
#include <ACROBOTIC_SSD1306.h>

#include <OneWire.h>
#include <DallasTemperature.h>


#define addr IPAddress(224, 10, 10, 10)
#define addr1 IPAddress(225, 10, 10, 10)
#define BUFFER_SIZE 512
#define port 4200

const int SENSOR_PIN = 12;

char buffer[512];
IPAddress apIP(10, 10, 10, 1);
WebServer server(80);
String clientServerIP = "10.10.10.2";
String clientServerPort = "2345";

float R1 = 30000.0;
float R2 = 7500.0;


String v1;
String c1;

String v2;
String c2;


String temp;

OneWire oneWire(SENSOR_PIN);         // setup a oneWire instance 
DallasTemperature sensors(&oneWire);

void setIP() {
  Serial.println("Setting IP");
  Serial.println(server.client().remoteIP().toString());
  Serial.println(server.arg("port"));
  clientServerIP = server.client().remoteIP().toString();
  clientServerPort = server.arg("port");
  server.send(200, "text/plain", "success");
}

void getData() {
  HTTPClient http;
  http.setTimeout(3);
  String url = "http://" + clientServerIP + ":" + clientServerPort + "/?type=getData&v1=" + v1 + "&v2=" + v2 + "&c1=" + c1 + "&c2=" + c2 + "&temp=" + temp ;
  url.replace(" ", "%20");
  http.begin(url);
  int httpCode = http.GET();
  String payload = http.getString();
}

void calculateVoltage(int pin){
  int value = analogRead(pin);
  float vOUT = (value * 5.0) / 1024.0;
  float vIN = vOUT / (R2/(R1+R2));
  Serial.println("VOLTAGE: " + String(pin) + " " + String(vIN));
  if(pin == 33){
    v1 = String(vIN);
    v1 = v1.substring(0, v1.length() - 1);
  }
  if(pin == 25){
    v2 = String(vIN);
    v2 = v2.substring(0, v2.length() - 1);
  }
}

void calculateCurrent(int pin){
  unsigned int x=0;
  float AcsValue=0.0,Samples=0.0,AvgAcs=0.0,AcsValueF=0.0;

    for (int x = 0; x < 150; x++){ //Get 150 samples
    AcsValue = analogRead(pin);     //Read current sensor values   
    Samples = Samples + AcsValue;  //Add samples together
    delay (3); // let ADC settle before next sample 3ms
  }
  AvgAcs=Samples/150.0;//Taking Average of Samples

  //((AvgAcs * (5.0 / 1024.0)) is converitng the read voltage in 0-5 volts
  //2.5 is offset(I assumed that arduino is working on 5v so the viout at no current comes
  //out to be 2.5 which is out offset. If your arduino is working on different voltage than 
  //you must change the offset according to the input voltage)
  //0.100v(100mV) is rise in output voltage when 1A current flows at input
  AcsValueF = (2.5 - (AvgAcs * (5.0 / 1024.0)) )/0.100;
  Serial.println("CURRENT: " + String(pin) + " " + String(AcsValueF));
  if(pin == 34){
    c1 = String(AcsValueF);
    c1 = c1.substring(0, c1.length() - 1);
  }
  if(pin == 35){
    c2 = String(AcsValueF);
    c2 = c2.substring(0, c2.length() - 1);
  }
}

void setup(void) {
  Serial.begin(115200);

  EEPROM.begin(512);
  WiFi.mode(WIFI_AP);
  WiFi.softAPConfig(apIP, apIP, IPAddress(255, 255, 255, 0));
  WiFi.softAP("DreamTech", "");

  server.on("/setClientIP", setIP);
  
  server.begin();
  Serial.println("Server Started");


  pinMode(34, INPUT);
  pinMode(35, INPUT);
  pinMode(33, INPUT);
  pinMode(25, INPUT);

  sensors.begin();    // initialize the sensor


   Wire.begin();	
  oled.init();                      // Initialze SSD1306 OLED display
  oled.clearDisplay(); 
}

unsigned long int timer = 0;

void loop() {
  server.handleClient();

  sensors.requestTemperatures();


  temp = String(sensors.getTempCByIndex(0));
  Serial.println("TEMP: " + String(temp));

  calculateCurrent(34);
  calculateCurrent(35);

  calculateVoltage(33);
  calculateVoltage(25);

  if(millis() - timer > 2000){
    oled.clearDisplay();              // Clear screen
    oled.setTextXY(0,1);              // Set cursor position, start of line 0
    String s1 = "1:V:" + v1 + ",C:" + c1;
    char charBuf[s1.length() + 1];
    s1.toCharArray(charBuf, s1.length() + 1);
    oled.putString(charBuf);
    oled.setTextXY(2,1);              // Set cursor position, start of line 1
    String s2 = "2:V:" + v2 + ",C:" + c2;
    char charBuf2[s2.length() + 1];
    s2.toCharArray(charBuf2, s2.length() + 1);
    oled.putString(charBuf2);
    oled.setTextXY(3,1);              // Set cursor position, start of line 2
    
    String s4 = "T:" + temp;
    char charBuf4[s4.length() + 1];
    s4.toCharArray(charBuf4, s4.length() + 1);
    oled.putString(charBuf4);
    getData();
    timer = millis();
    
  }
  
}
