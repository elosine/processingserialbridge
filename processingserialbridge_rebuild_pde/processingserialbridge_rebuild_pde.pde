/////////////////////////////////////////////////////////////////////////////////////////
// IMPORT LIBRARIES /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////
import processing.serial.*;
/////////////////////////////////////////////////////////////////////////////////////////
// GLOBAL VARIABLES /////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////

//// Serial ///////////////////////////////////////////////////////////////////////////////
int[] myserialnums = {32}; // The numbers of serial ports that you wish to use from the Serial.list() print out when you run the app
Serial[] myserials; // Create a list of Serial objects from the Serial class
////// Serial Data
//For each of the serial devices, populate serialheaders with the appropriate strings for each serial device
//The number of arrays in serialheaders needs to be the same as the number of devices in myserialnums
String[][] serialheaders = { {"b0", "b1", "b2", "b2", "p1", "p0"}}; // 2D array to hold the headers you wish to use for each serial device
int[][] serialgates = { {0, 0, 0, 0, 0, 0} }; // A 2D array to store gates for serial events per serial device, per header
String[][] serialdatas = { {"", "", "", "", "", ""} }; // A 2D array to store serial data per serial device, per header
////////////////////////////////////////////////////////////////////////////////////////////
// SETUP /////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////
void setup() {
  //// Canvas  /////////////////////////////////////////////////////////////////////////////////
  size(500, 500);
  //// Serial  /////////////////////////////////////////////////////////////////////////////////
  printArray(Serial.list()); // Print a list of available serial ports
  myserials = new Serial[myserialnums.length]; // Make a blank array with the amount of slots to accomodate the number of devices you listed in myserialnums
  // Get the ports you listed in myserialnums and populate myserials:
  for (int i=0; i<myserialnums.length; i++) {
    String portnametemp = Serial.list()[ myserialnums[i] ]; //get name of port
    myserials[i] = new Serial(this, portnametemp, 9600); //populate myserials and open the ports
  }  // End for myserialnums

} // End Setup
/////////////////////////////////////////////////////////////////////////////////////////////////
// DRAW /////////////////////////////////////////////////////////////////////////////////////////
/////////////////////////////////////////////////////////////////////////////////////////////////
void draw() {
  // Use an if statement on a serialgate in draw to invoke actions
  //// Device-1, Header-"bt2"
 // if (serialgates[0][2] == 1) {
    // Run a function or action here
    // For example: someint = int(serialdatas[0][2]);
    // Or: movesomething();
 //   serialgates[0][2] = 0; // Reset gate to 0 to wait for next message
 // }
} // End draw
////////////////////////////////////////////////////////////////////////////////////////////////////////
// SERIAL EVENT /////////////////////////////////////////////////////////////////////////////////////////
////////////////////////////////////////////////////////////////////////////////////////////////////////
//By invoking the serialEvent, and using a gate system,
//you can store data incomming via the serial ports
//and use it 
void serialEvent(Serial serialport) {
  int portnumtmp = -1; // variable to hold the number of the port:
  // Iterate over the list of ports opened, check if it is one in myserials, and match the one that generated this event:
  for (int i=0; i<myserials.length; i++) {
    if (serialport == myserials[i]) {
      //Incomming port number
      portnumtmp = i; // Capture the number of serial device in myserials that sent this event
            println(portnumtmp);

    } //end if serialport
  } //end for myserials
  // Read the incomming message
  // Split the message at the ':' to get the header and the data
  String serialmsgtmp = myserials[portnumtmp].readString(); // read the incomming string from the serial port
 
  String[] smsgsplittmp = split(serialmsgtmp, ":"); // split the message at the ':'
    printArray(smsgsplittmp);

  /*
  String headertmp = smsgsplittmp[0]; // incomming header
  String serialdatatmp = smsgsplittmp[1]; // incomming data
  // Check if this header exsists for this device in your list serialheaders
  for (int i=0; i<serialheaders[portnumtmp].length; i++) {
    if ( headertmp.equals(serialheaders[portnumtmp][i] ) ) { // Check if this header exsists for this device in your list serialheaders
      serialgates[portnumtmp][i] = 1; // open the gate so draw can see that a valid serial event is waiting
      serialdatas[portnumtmp][i] = serialdatatmp; //store serial data as a string to be parced appropriately by other functions
    }
  }*/
}