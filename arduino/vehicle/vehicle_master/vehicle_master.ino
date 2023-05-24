#include <ESP8266WiFi.h>
#include <WiFiUdp.h>
#include <LiquidCrystal_I2C.h>

#define ssid "vehicle"
#define pass ""

WiFiUDP UDP;
IPAddress local_ip(192, 168, 4, 1);
IPAddress gateway(192, 168, 4, 1);
IPAddress subnet(255, 255, 255, 0);
#define UDP_PORT 4210

char packetBuffer[UDP_TX_PACKET_MAX_SIZE];

LiquidCrystal_I2C lcd(0x27, 16, 2);

void setup() {
  Serial.begin(115200);
  Serial.println();

  Serial.println("UDP server\nStarting access point...");

  WiFi.mode(WIFI_AP_STA);
  WiFi.softAPConfig(local_ip, gateway, subnet);
  WiFi.softAP(ssid, pass);

  IPAddress myIP = WiFi.softAPIP();

  UDP.begin(UDP_PORT);

  lcd.begin();
  lcd.clear();
  lcd.backlight();
  lcd.setCursor(3, 0);
  lcd.print("WELCOME TO");
  lcd.setCursor(2, 1);
  lcd.print("SMART HELMET");

  pinMode(D5, OUTPUT);
  pinMode(D7, OUTPUT);
  pinMode(D6, OUTPUT);
  pinMode(D8, OUTPUT);
  delay(1000);
}

String getValue(String data, char separator, int index) {
  int found = 0;
  int strIndex[] = { 0, -1 };
  int maxIndex = data.length() - 1;

  for (int i = 0; i <= maxIndex && found <= index; i++) {
    if (data.charAt(i) == separator || i == maxIndex) {
      found++;
      strIndex[0] = strIndex[1] + 1;
      strIndex[1] = (i == maxIndex) ? i + 1 : i;
    }
  }

  return found > index ? data.substring(strIndex[0], strIndex[1]) : "";
}

void loop() {
  if (UDP.parsePacket()) {
    UDP.read(packetBuffer, UDP_TX_PACKET_MAX_SIZE);
    String str = String(packetBuffer);
    Serial.println(getValue(str, ',', 1));
    int length = str.length();
    if (str[length - 3] == '1') {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("WEAR YOUR HELMET");
      digitalWrite(D7, HIGH);
      digitalWrite(D5, LOW);
      digitalWrite(D6, LOW);
      digitalWrite(D8, LOW);
      lcd.setCursor(0, 1);
      String lat = getValue(str, ',', 0);
      String lon = getValue(str, ',', 1);
      lcd.print(String(lat.substring(0, lat.length() - 3) + "," + lon.substring(0, lon.length() - 3)));
    } else if (str[length - 1] == '0') {
      lcd.clear();
      lcd.setCursor(0, 0);
      lcd.print("ENGINE STOPPED");
      digitalWrite(D5, HIGH);
      digitalWrite(D6, LOW);
      digitalWrite(D7, LOW);
      digitalWrite(D8, LOW);
      lcd.setCursor(0, 1);
      String lat = getValue(str, ',', 0);
      String lon = getValue(str, ',', 1);
      lcd.print(String(lat.substring(0, lat.length() - 3) + "," + lon.substring(0, lon.length() - 3)));
    } else {
      lcd.clear();
      lcd.setCursor(0, 0);
      digitalWrite(D6, HIGH);
      digitalWrite(D5, LOW);
      digitalWrite(D7, LOW);
      digitalWrite(D8, HIGH);
      lcd.print("Engine Started");
    }
  }
}
