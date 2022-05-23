boolean countStatus;
int beat, bpm;
unsigned long millisBefore;
 
// the setup routine runs once when you press reset:
void setup()
{
  Serial.begin(9600);
}
 
// the loop routine runs over and over again forever:
void loop()
{
  // read the input on analog pin 0:
  int sensorValue = analogRead(A0);
  // print out the value you read:
//  Serial.println(sensorValue);
  if (countStatus == 0)
  {
    if (sensorValue > 600)
    {
      countStatus = 1;
      beat++;
      Serial.println("Beat Detected!");
      Serial.print("Beat : ");
      Serial.println(beat);
    }
  }
  else
  {
    if (sensorValue < 500)
    {
      countStatus = 0;
    }
  }
  if (millis() - millisBefore > 15000)
  {
    bpm = beat * 4;
    beat = 0;
    Serial.print("BPM : ");
    Serial.println(bpm);
    millisBefore = millis();
  }
  delay(1);        // delay in between reads for stability
}
