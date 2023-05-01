#define TL 12
#define EL 11
#define TR 3
#define ER 2
#define TC 4
#define EC 5

#define M1 A4
#define M2 A5
#define M3 A3
#define M4 A2
#include <SoftwareSerial.h>

const byte numChars = 200;
char receivedChars[numChars];
char tempChars[numChars];

boolean newData = false;

SoftwareSerial MySerial(9, 8);

bool autoMode = true;

long microsecondsToCentimeters(long microseconds) {
  return microseconds / 29 / 2;
}


void recvWithStartEndMarkers() {
  static boolean recvInProgress = false;
  static byte ndx = 0;
  char startMarker = '<';
  char endMarker = '>';
  char rc;

  while (MySerial.available() > 0 && newData == false) {

    rc = MySerial.read();

    if (recvInProgress == true) {
      if (rc != endMarker) {
        receivedChars[ndx] = rc;
        ndx++;
        if (ndx >= numChars) {
          ndx = numChars - 1;
        }
      } else {
        receivedChars[ndx] = '\0';  // terminate the string
        recvInProgress = false;
        ndx = 0;
        newData = true;
      }
    }

    else if (rc == startMarker) {
      recvInProgress = true;
    }
  }
}


long getDistance(int pingPin, int echoPin) {
  long duration, cm;
  pinMode(pingPin, OUTPUT);
  digitalWrite(pingPin, LOW);
  delayMicroseconds(2);
  digitalWrite(pingPin, HIGH);
  delayMicroseconds(10);
  digitalWrite(pingPin, LOW);
  pinMode(echoPin, INPUT);
  duration = pulseIn(echoPin, HIGH);
  return microsecondsToCentimeters(duration);
}

void moveBackward() {
  digitalWrite(M1, LOW);
  delay(2);
  digitalWrite(M2, HIGH);
  delay(2);
  digitalWrite(M3, LOW);
  delay(2);
  digitalWrite(M4, HIGH);
  delay(2);
}

void moveForward() {
  digitalWrite(M1, HIGH);
  delay(2);
  digitalWrite(M2, LOW);
  delay(2);
  digitalWrite(M3, HIGH);
  delay(2);
  digitalWrite(M4, LOW);
  delay(2);
}
void moveLeft() {
  digitalWrite(M1, LOW);
  delay(2);
  digitalWrite(M2, HIGH);
  delay(2);
  digitalWrite(M3, HIGH);
  delay(2);
  digitalWrite(M4, LOW);
  delay(2);
}
void moveRight() {
  digitalWrite(M1, HIGH);
  delay(2);
  digitalWrite(M2, LOW);
  delay(2);
  digitalWrite(M3, LOW);
  delay(2);
  digitalWrite(M4, HIGH);
  delay(2);
}
void stop() {
  digitalWrite(M1, LOW);
  delay(2);
  digitalWrite(M2, LOW);
  delay(2);
  digitalWrite(M3, LOW);
  delay(2);
  digitalWrite(M4, LOW);
  delay(2);
}

void setup() {
  Serial.begin(115200);
  MySerial.begin(19200);
  pinMode(M1, OUTPUT);
  pinMode(M2, OUTPUT);
  pinMode(M3, OUTPUT);
  pinMode(M4, OUTPUT);
}

void loop() {
  long dc = getDistance(TC, EC);
  long dl = getDistance(TL, EL);
  long dr = getDistance(TR, ER);

  // Serial.print(dl);
  // Serial.print(" : ");
  // Serial.print(dc);
  // Serial.print(" : ");
  // Serial.println(dr);

  // delay(1000);
  // moveRight();
  // return;

  recvWithStartEndMarkers();
  if (newData) {
    String str = String(receivedChars);
    Serial.println(str);
    if (str == "AUTO") {
      autoMode = true;
      stop();
    }
    if (str == "MANUAL") {
      autoMode = false;
      stop();
    }
    if (str == "FRONT") {
      moveForward();
    }
    if (str == "BACK") {
      moveBackward();
    }
    if (str == "LEFT") {
      moveLeft();
    }
    if (str == "RIGHT") {
      moveRight();
    }
    if (str == "STOP") {
      stop();
    }
    newData = false;
  }

  if (autoMode) {
    if (dl < 40) {
      if (dr > 40) {
        moveRight();
        delay(300);
        stop();
      } else {
        stop();
      }
    } else if (dr < 40) {
      if (dl > 40) {
        moveLeft();
        delay(300);
        stop();
      } else {
        stop();
      }
    } else if (dc < 60) {
      if (dl > 40) {
        moveLeft();
      } else if (dr > 40) {
        moveRight();
      } else {
        stop();
      }
    } else {
      moveForward();
    }
  } else {
  }
}
