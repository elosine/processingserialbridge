/* A Processing bridge from Arduino to Open Sound Control with graphic feedback */

import processing.serial.*; //import serial library

Serial ino;  // Create object from Serial class

String[] hdrs = {"b0", "b1", "p0", "p1"}; //these are the headers you are tracking from arduino
int[] data = {0, 0, 0, 0}; //each of these data correspond to the headers in 'hdrs'
int[][] mappings = { {0, 1}, {0, 1}, {100, 1020}, {100, 1020} };
float[] datanorm = {0.0, 0.0, 0.0, 0.0};

void setup() {

  size(500, 500);

  printArray(Serial.list()); // Print a list of available serial ports

  String portName = Serial.list()[32]; //the # here is the port # you wish to use from the serial list above
  ino = new Serial(this, portName, 9600); //make sure the baud rate is synced with the baud rate your arduino is running at

  //
} //end setup

void draw() {
  background(0);

  float meter = map(datanorm[2], 0.0, 1.0, 0, 150);

  stroke(153, 255, 0);
  noFill();
  strokeWeight(4);
  rect(48, 48, 52, 152, 7);
  noStroke();
  fill(153, 255, 0);
  rect(50, 50+(150-meter), 50, meter);



  //
} //end draw


void serialEvent(Serial ino) { 
  // read the serial buffer:
  String msg = ino.readStringUntil( '\r' );

  // if we get any bytes other than the linefeed:
  if (msg != null) {
    // remove the linefeed
    msg = trim(msg);
    //  println(msg);
    String[] m2 = split(msg, ':'); //split msg at the colon into header and data
    //you have populated the hdrs array with the headers you wish to use
    for (int j=0; j<hdrs.length; j++) { 
      //this matches the incomming headers with the array
      if (m2[0].equals(hdrs[j])) {
        data[j] = int(m2[1]); //this populates the data array with each index corresponding with the headrs in hdr
        //Normalize Values
        datanorm[j] = norm(data[j], mappings[j][0], mappings[j][1]);

        //thus data[0] is the data from whichever controler is in hdr[0]
      } //end if
    } //end for (int i=0; i<hdrs.length; i++) {
    
      printArray(data);
      
  }// end if(msg !=null)
} //end serialEvent



/*
NOTES
 comment
 Make Class from this 
 Make classes of graphic objects
 
 
 
 */