/*
This code runs on the DAQ ESP32 and has a couple of main functions.
1. Read sensor data
2. Send sensor data to COM ESP32
3. Recieve servo commands from COM ESP32
4. Send PWM signals to servos
*/

#include <esp_now.h>
#include <WiFi.h>
#include <ESP32Servo.h>
#include <Wire.h>
#include <Arduino.h>
#include "HX711.h"


//define pins to use for the various sensors and connections. define takes up less space on the chip
#define ONBOARD_LED  13
#define PTDOUT1 32
#define CLKPT1 5
#define PTDOUT2 15
#define CLKPT2 2
#define PTDOUT3 22
#define CLKPT3 23
#define PTDOUT4 19
#define CLKPT4 21
#define PTDOUT5 35
#define CLKPT5 25
#define PTDOUT6 34
#define CLKPT6 26
#define PTDOUT7 39
#define CLKPT7 33





float pt1=-1;
float pt2=-1;
float pt3=-1;
float pt4=-1;
float pt5=-1;
float pt6=-1;
float pt7=-1;
// String serialMessage = "";
String serialMessage = "";

//define servo min and max values
#define SERVO_MIN_USEC (900)
#define SERVO_MAX_USEC (2100)

//Initialize the PT and LC sensor objects which use the HX711 breakout board
HX711 scale1;
HX711 scale2;
HX711 scale3;
HX711 scale4;
HX711 scale5;
HX711 scale6;
HX711 scale7;


//Initialize the servo objects
Servo servo1;
Servo servo2;

//define servo necessary values
int ADC_Max = 4096;


void setup() {

//set gains for pt pins
  scale1.begin(PTDOUT1, CLKPT1);
  scale1.set_gain(64);
     //Sets the pin as an input

//set gains for pt pins
  scale2.begin(PTDOUT2, CLKPT2);
  scale2.set_gain(64);

  //set gains for pt pins
  scale3.begin(PTDOUT3, CLKPT3);
  scale3.set_gain(64);

  //set gains for pt pins
  scale4.begin(PTDOUT4, CLKPT4);
  scale4.set_gain(64);

  //set gains for pt pins
  scale5.begin(PTDOUT5, CLKPT5);
  scale5.set_gain(64);

  //set gains for pt pins
  scale6.begin(PTDOUT6, CLKPT6);
  scale6.set_gain(64);

//set gains for pt pins
  scale7.begin(PTDOUT7, CLKPT7);
  scale7.set_gain(64);


  Serial.begin(115200);

}

void loop() {

  getReadings();

  delay(5);

}

void getReadings(){


 pt1 = scale1.read();
       // Serial.print("pt1: ");

  pt2 = scale2.read();
       // Serial.print(" p2: ");


  pt3 = scale3.read();
       // Serial.print(" pt3: ");


  pt4 = scale4.read();
       // Serial.print(" pt4: ");

  pt5 = scale5.read()*-3.0272e-04-0.1535;
       // Serial.print(" pt5: ");

  pt6 = scale6.read()*-3.4136e-04+0.8333;
       // Serial.print(" pt6: ");

  pt7 = scale7.read()*-2.4978e-04+1.6369;
       // Serial.print(" pt7: ");

  serialMessage = "";
  //
  serialMessage.concat(pt1);
  serialMessage.concat(" ");
  serialMessage.concat(pt2);
  serialMessage.concat(" ");
  serialMessage.concat(pt3);
  serialMessage.concat(" ");
  serialMessage.concat(pt4);
  serialMessage.concat(" ");
  serialMessage.concat(pt5);
  serialMessage.concat(" ");
  serialMessage.concat(pt6);
  serialMessage.concat(" ");
  serialMessage.concat(pt7);
  // serialMessage = (pt1+" "+pt2+" "+pt3+" "+pt4+" "+pt5+" "+pt6+" "+pt7);
  // Serial.print(pt1);
  // Serial.print(" ");
  // Serial.print(pt2);
  // Serial.print(" ");
  // Serial.print(pt3);
  // Serial.print(" ");
  // Serial.print(pt4);
  // Serial.print(" ");
  // Serial.print(pt1);
  // Serial.print(" ");
  // Serial.print(pt1);
  // Serial.print(" ");
  // Serial.println(pt1);
  // Serial.println(" ");
  Serial.println(serialMessage);



}