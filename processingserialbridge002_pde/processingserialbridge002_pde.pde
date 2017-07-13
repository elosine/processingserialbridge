/**
 * Simple Read
 * 
 * Read data from the serial port and change the color of a rectangle
 * when a switch connected to a Wiring or Arduino board is pressed and released.
 * This example works with the Wiring / Arduino program that follows below.
 */


import processing.serial.*;

Serial ino;  // Create object from Serial class
int val;      // Data received from the serial port

void setup() 
{
  size(200, 200);
  // I know that the first port in the serial list on my mac
  // is always my  FTDI adaptor, so I open Serial.list()[0].
  // On Windows machines, this generally opens COM1.
  // Open whatever port is the one you're using.
  String portName = Serial.list()[32];
  ino = new Serial(this, portName, 9600);
}

void draw() {

  if ( ino.available() > 0) {  // If data is available,
    String msg = ino.readString().trim();
    String[] m1 = split(msg, '\r');
    for (int i=0; i<m1.length; i++) {
      String[] m2 = split(m1[i], ':');
      if (m2[0].equals("p0")) {
        println(int(m2[1]));
      }
    }
  }
}
/*
void serialEvent(Serial ino) {
 
 
 String smsg = ino.readString().trim();
 if (smsg.equals ('\r')) { 
 // ino.clear(); 
 }
 // String[] mt1 = split(smsg, '\r');
 //  for (int i=0; i<mt1.length; i++) {
 //    String[] mt2 = split(mt1[i], ':');
 println(smsg);
 // }
 }
 */