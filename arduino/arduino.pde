#include <SPI.h>
#include <Adb.h>

int left = 0;
int right = 0;
int leftDir = 0;
int rightDir = 0;

void setup()
{
  pinMode(10,OUTPUT);
  pinMode(12,OUTPUT);
  pinMode(11,OUTPUT);
  pinMode(13,OUTPUT);

  comSetup();

  Serial.begin(57600);

}

void comReceive(uint8_t * data){
  left = data[0];
  right = data[1];
//  Serial.println("recv");
  leftDir = data[2];
  rightDir = data[3];
}


void loop()
{
  comUpdate();

  if(leftDir > 0){
    digitalWrite(12,HIGH);
    analogWrite(10,255-left);
  } 
  else {
    digitalWrite(12,LOW);
    analogWrite(10,left);
  }
  
   if(rightDir > 0){
    digitalWrite(13,HIGH);
    analogWrite(11,255-right);
  } 
  else {
    digitalWrite(13,LOW);
    analogWrite(11,right);
  }
  delay(10);
}





