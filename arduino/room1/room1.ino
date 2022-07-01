#include <Adafruit_Sensor.h>
#include <DHT.h>
#include <DHT_U.h>
#include <Wire.h>
#include <ACROBOTIC_SSD1306.h>


#define DHTPIN 4
#define DHTTYPE DHT11


DHT_Unified dht(DHTPIN, DHTTYPE);


int currentPeople = 0;
int sensor1[] = {14,12};
int sensor2[] = {26,27};
int sensor1Initial = 50;
int sensor2Initial = 50;

String sequence = "";

int timeoutCounter = 0;

bool swutch = false;
int tem = -1;
int humi = -1;



#if defined(ESP32)
#include <WiFi.h>
#elif defined(ESP8266)
#include <ESP8266WiFi.h>
#endif

#include <Firebase_ESP_Client.h>

// Provide the token generation process info.
#include <addons/TokenHelper.h>

// Provide the RTDB payload printing info and other helper functions.
#include <addons/RTDBHelper.h>

/* 1. Define the WiFi credentials */
#define WIFI_SSID "DreamTech"
#define WIFI_PASSWORD ""

/* 2. Define the API Key */
#define API_KEY "AIzaSyCSqQIQVyKkpRGt5zzPFRJNkaUq8VvFX_E"

/* 3. Define the RTDB URL */
#define DATABASE_URL "student-projects-8a312-default-rtdb.firebaseio.com" //<databaseName>.firebaseio.com or <databaseName>.<region>.firebasedatabase.app

/* 4. Define the user Email and password that alreadey registerd or added in your project */
#define USER_EMAIL "test@gmail.com"
#define USER_PASSWORD "12345678"

// Define Firebase Data object
FirebaseData fbdo;
FirebaseData fbdo1;

FirebaseAuth auth;
FirebaseConfig config;

unsigned long sendDataPrevMillis = 0;

int count = 0;

uint32_t idleTimeForStream = 15000;

uint32_t delayMS;

int measureDistance(int a[]) {
  pinMode(a[1], OUTPUT);
  digitalWrite(a[1], LOW);
  delayMicroseconds(2);
  digitalWrite(a[1], HIGH);
  delayMicroseconds(10);
  digitalWrite(a[1], LOW);
  pinMode(a[0], INPUT);
  long duration = pulseIn(a[0], HIGH, 100000);
  return duration / 29 / 2;
}


TaskHandle_t Task1;
TaskHandle_t Task2;
long long int last = 0, lastT = 0;;

void setup(void){
  Serial.begin(115200);
  Serial.println("");

  // sensor1Initial = measureDistance(sensor1);
  // sensor2Initial = measureDistance(sensor2);

  pinMode(2, OUTPUT);
  pinMode(15, OUTPUT);
  pinMode(8, OUTPUT);

  dht.begin();


  sensor_t sensor;
  dht.temperature().getSensor(&sensor);
  Serial.println(F("------------------------------------"));
  Serial.println(F("Temperature Sensor"));
  Serial.print  (F("Sensor Type: ")); Serial.println(sensor.name);
  Serial.print  (F("Driver Ver:  ")); Serial.println(sensor.version);
  Serial.print  (F("Unique ID:   ")); Serial.println(sensor.sensor_id);
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("°C"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("°C"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("°C"));
  Serial.println(F("------------------------------------"));
  // Print humidity sensor details.
  dht.humidity().getSensor(&sensor);
  Serial.println(F("Humidity Sensor"));
  Serial.print  (F("Sensor Type: ")); Serial.println(sensor.name);
  Serial.print  (F("Driver Ver:  ")); Serial.println(sensor.version);
  Serial.print  (F("Unique ID:   ")); Serial.println(sensor.sensor_id);
  Serial.print  (F("Max Value:   ")); Serial.print(sensor.max_value); Serial.println(F("%"));
  Serial.print  (F("Min Value:   ")); Serial.print(sensor.min_value); Serial.println(F("%"));
  Serial.print  (F("Resolution:  ")); Serial.print(sensor.resolution); Serial.println(F("%"));
  Serial.println(F("------------------------------------"));
  // Set delay between sensor readings based on sensor details.
  delayMS = sensor.min_delay / 1000;




  Wire.begin();
  oled.init();
  oled.clearDisplay();
  oled.setTextXY(1, 0);
  oled.putString("Connecting...");

  WiFi.begin(WIFI_SSID, WIFI_PASSWORD);
  Serial.print("Connecting to Wi-Fi");
  while (WiFi.status() != WL_CONNECTED)
  {
    Serial.print(".");
    delay(300);
  }
  Serial.println();
  Serial.print("Connected with IP: ");
  Serial.println(WiFi.localIP());
  Serial.println();

  Serial.printf("Firebase Client v%s\n\n", FIREBASE_CLIENT_VERSION);

  // For the following credentials, see examples/Authentications/SignInAsUser/EmailPassword/EmailPassword.ino

  /* Assign the api key (required) */
  config.api_key = API_KEY;

  /* Assign the user sign in credentials */
  auth.user.email = USER_EMAIL;
  auth.user.password = USER_PASSWORD;

  /* Assign the RTDB URL (required) */
  config.database_url = DATABASE_URL;

  /* Assign the callback function for the long running token generation task */
  config.token_status_callback = tokenStatusCallback; // see addons/TokenHelper.h

  // Or use legacy authenticate method
  // config.database_url = DATABASE_URL;
  // config.signer.tokens.legacy_token = "<database secret>";

  // To connect without auth in Test Mode, see Authentications/TestMode/TestMode.ino

  Firebase.begin(&config, &auth);

  Firebase.reconnectWiFi(true);

  // The data under the node being stream (parent path) should keep small
  // Large stream payload leads to the parsing error due to memory allocation.
  if (!Firebase.RTDB.beginStream(&fbdo, "/test/stream/data1"))
    Serial.printf("sream begin error, %s\n\n", fbdo.errorReason().c_str());
  if (!Firebase.RTDB.beginStream(&fbdo1, "/test/stream/data2"))
    Serial.printf("sream begin error, %s\n\n", fbdo1.errorReason().c_str());

  pinMode(16, OUTPUT);
  pinMode(17, OUTPUT);


   xTaskCreatePinnedToCore(
      Task2code,   /* Task function. */
      "Task2",     /* name of task. */
      10000,       /* Stack size of task */
      NULL,        /* parameter of the task */
      1,           /* priority of the task */
      &Task2,      /* Task handle to keep track of created task */
      1);          /* pin task to core 1 */
    delay(500);
}

void Task2code( void * parameter) {
 for(;;){
    ultraLogic();
    if (Firebase.ready())
    {
      ultraLogic();
      if (!Firebase.RTDB.readStream(&fbdo))
        Serial.printf("sream read error, %s\n\n", fbdo.errorReason().c_str());
ultraLogic();
      if (fbdo.streamTimeout())
      {
        Serial.println("stream timed out, resuming...\n");

        if (!fbdo.httpConnected())
          Serial.printf("error code: %d, reason: %s\n\n", fbdo.httpCode(), fbdo.errorReason().c_str());
      }

      if (fbdo.streamAvailable())
      {
        bool dat = fbdo.boolData();
        digitalWrite(16, dat);
         Serial.printf("sream path, %s\nevent path, %s\ndata type, %s\nevent type, %s\nvalue, %s\n\n",
                      fbdo.streamPath().c_str(),
                      fbdo.dataPath().c_str(),
                      fbdo.dataType().c_str(),
                      fbdo.eventType().c_str(),
                      String(dat).c_str());
      }


      if (!Firebase.RTDB.readStream(&fbdo1))
        Serial.printf("sream read error, %s\n\n", fbdo1.errorReason().c_str());

      if (fbdo1.streamTimeout())
      {
        Serial.println("stream timed out, resuming...\n");

        if (!fbdo1.httpConnected())
          Serial.printf("error code: %d, reason: %s\n\n", fbdo1.httpCode(), fbdo1.errorReason().c_str());
      }

      if (fbdo1.streamAvailable())
      {
        bool dat = fbdo1.boolData();
        digitalWrite(17, dat);
         Serial.printf("sream path, %s\nevent path, %s\ndata type, %s\nevent type, %s\nvalue, %s\n\n",
                      fbdo1.streamPath().c_str(),
                      fbdo1.dataPath().c_str(),
                      fbdo1.dataType().c_str(),
                      fbdo1.eventType().c_str(),
                      String(dat).c_str());
      }
    }
    ultraLogic();
    if(millis() - lastT > delayMS){
      lastT = millis();
       sensors_event_t event;
      dht.temperature().getEvent(&event);
      if (isnan(event.temperature)) {
        Serial.println(F("Error reading temperature!"));
      }
      else {
        Serial.print(F("Temperature: "));
        Serial.print(event.temperature);
        Serial.println(F("°C"));
        tem = event.temperature;
      }
      // Get humidity event and print its value.
      dht.humidity().getEvent(&event);
      if (isnan(event.relative_humidity)) {
        Serial.println(F("Error reading humidity!"));
      }
      else {
        Serial.print(F("Humidity: "));
        Serial.print(event.relative_humidity);
        Serial.println(F("%"));
        humi = event.relative_humidity;
      }
    }
    ultraLogic();
 }

}


void ultraLogic(){
  int sensor1Val = measureDistance(sensor1);
  int sensor2Val = measureDistance(sensor2);

  //Process the data
  if(sensor1Val < sensor1Initial - 10 && sequence.charAt(0) != '1'){
    sequence += "1";
  }else if(sensor2Val < sensor2Initial - 10 && sequence.charAt(0) != '2'){
    sequence += "2";
  }

  if(sequence.equals("12")){
    currentPeople++;
    sequence="";
    delay(550);
  }else if(sequence.equals("21") && currentPeople > 0){
    currentPeople--;
    sequence="";
    delay(550);
  }

  //Resets the sequence if it is invalid or timeouts
  if(sequence.length() > 2 || sequence.equals("11") || sequence.equals("22") || timeoutCounter > 200){
    sequence="";
  }

  if(sequence.length() == 1){ //
    timeoutCounter++;
  }else{
    timeoutCounter=0;
  }

  //Print values to serial
//  Serial.print("Seq: ");
//  Serial.print(sequence);
//  Serial.print(" S1: ");
//  Serial.print(sensor1Val);
//  Serial.print(" S2: ");
//  Serial.println(sensor2Val);

//
//  Serial.print(" TOTAL: ");
//  Serial.println(currentPeople);

  if(currentPeople > 0){
    digitalWrite(2, LOW);
    digitalWrite(15, LOW);
  }else{
    digitalWrite(2, HIGH);
    digitalWrite(15, HIGH);
  }

  digitalWrite(8, swutch);


//  float h = dht.readHumidity();
//  float t = dht.readTemperature();
//  if(h<100) humi = h;
//  if(t<100) tem = t;

//  Serial.print(tem);
//  Serial.print(" , ");
//  Serial.println(humi);

}

void loop(void){
  delay(delayMS);
//Read ultrasonic sensors
  ultraLogic();


//  if(millis() - last > 2000){

    last = millis();
    oled.clearDisplay();
    oled.setTextXY(1, 0);
    oled.putString("COUNT: ");
    oled.setTextXY(1, 8);
    oled.putString(String(currentPeople).c_str());

    oled.setTextXY(2, 0);
    oled.putString("TEMP: ");
    oled.setTextXY(2, 8);
    oled.putString(String(tem).c_str());
    oled.setTextXY(3, 0);
    oled.putString("HUMI: ");
    oled.setTextXY(3, 8);
    oled.putString(String(humi).c_str());
//   }

}
