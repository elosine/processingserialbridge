/* A Processing bridge from Arduino */
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////
import processing.serial.*; //import serial library

Serial ino;  // Create object from Serial class

//Serial Bridge Variables
String[] hdrs = {"b0", "b1", "p0", "p1"}; //these are the headers you are tracking from arduino
int[] data = {0, 0, 0, 0}; //each of these data correspond to the headers in 'hdrs'
int[][] mappings = { {0, 1}, {0, 1}, {0, 1023}, {0, 1023} };
float[] datanorm = {0.0, 0.0, 0.0, 0.0};
//////////////////////////////////////////////////////////
//////////////////////////////////////////////////////////

//osc
import oscP5.*;
import netP5.*;
OscP5 osc;
NetAddress sc;

//moving lines
float l1x = 0;
float l2x;

//declare Balls
Balls bl;

void setup() {
  size(500, 500);

  //serial///////////////////////////////////////////////////////////////////
  printArray(Serial.list()); // Print a list of available serial ports
  String portName = Serial.list()[32]; //the # here is the port # you wish to use from the serial list above
  ino = new Serial(this, portName, 9600); //make sure the baud rate is synced with the baud rate your arduino is running at
  //////////////////////////////////////////////////////////////////////////

  //osc
  osc = new OscP5(this, 12321);
  sc = new NetAddress("127.0.0.1", 57120);

  //lines
  l2x = width;
  
  //initialize balls
  bl = new Balls(5);
  //
} //end setup

void draw() {
  background(0);

  //send osc data to sc
  for (int i=0; i<hdrs.length; i++) {
    osc.send("/"+hdrs[i], new Object[]{datanorm[i]}, sc);
  }

  //map pot to lines movement
  l1x = map(datanorm[2], 0.0, 1.0, 0, width/2);
  l2x = map(datanorm[2], 0.0, 1.0, width, width/2);
  
  //draw balls
  bl.drw();

  //lines
  stroke(153, 255, 0);
  strokeWeight(3);
  line(l1x, 0, l1x, height);
  line(l2x, 0, l2x, height);

  //
} //end draw







/////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////
void serialEvent(Serial ino) { 
  // read the serial buffer:
  String msg = ino.readStringUntil( '\r' );

  // if we get any bytes other than the linefeed:
  if (msg != null) {
    // remove the linefeed
    msg = trim(msg);
    String[] m2 = split(msg, ':'); //split msg at the colon into header and data
    //you have populated the hdrs array with the headers you wish to use
    for (int j=0; j<hdrs.length; j++) { 
      //this matches the incomming headers with the array
      if (m2[0].equals(hdrs[j])) {

        int newval = int(m2[1]);

        data[j] = newval; //this populates the data array with each index corresponding with the headrs in hdr
        //thus data[0] is the data from whichever controler is in hdr[0]
        //Normalize Values
        datanorm[j] = norm(data[j], mappings[j][0], mappings[j][1]);
      } //end if
    } //end for (int i=0; i<hdrs.length; i++) {

    // printArray(data);
  }// end if(msg !=null)
} //end serialEvent
////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////