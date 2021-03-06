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


//moving lines
float l1x = 0;
float l2x;

//balls
int b0x;
int b0dir = 1;
int b0v = 15;



void setup() {
  size(500, 500);

  l2x = width;

  b0x = int(width/2);



  //serial///////////////////////////////////////////////////////////////////
  printArray(Serial.list()); // Print a list of available serial ports
  String portName = Serial.list()[32]; //the # here is the port # you wish to use from the serial list above
  ino = new Serial(this, portName, 9600); //make sure the baud rate is synced with the baud rate your arduino is running at
  //////////////////////////////////////////////////////////////////////////




  //
} //end setup

void draw() {
  background(0);


  //map pot to lines movement
  l1x = map(datanorm[2], 0.0, 1.0, 0, width/2);
  l2x = map(datanorm[2], 0.0, 1.0, width, width/2);


  //balls
  if ( (b0x+8) >= l2x ){
    b0dir = -1;
    //b0v = round(random(5, 15));
  }
  if ( (b0x-8) <= l1x ) {
    b0dir = 1;
   // b0v = round(random(2, 11));

  }

  b0x = b0x + (b0v*b0dir);
  noStroke();
  fill(255);
  ellipseMode(CENTER);
  ellipse(b0x, 180, 17, 17);


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
        data[j] = int(m2[1]); //this populates the data array with each index corresponding with the headrs in hdr
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