#include <SimpleMessageSystem.h>



#define NP 2
#define NB 2
#define NFSR 0
#define NLED 0

//pot
//int np = 8; //number of pots
int p[NP] = { A0, A1}; //analog input pins
int pv[NP];//pot value
int ppv[NP] = {0,0}; //previous pot value

//buttons
//int nb = 6;
int b[] = { 2, 3 }; //digital input pins
boolean bg[] = {true, true};//momentary button gates
////button toggle
int btv[] = { 0, 0}; //toggle button current value
int btamt[] = {2,2}; //number of toggles
boolean btg[] = {true, true};//toggle button gates

//fsrs
//int numsens = 0;
int fsr[] = {A5};
int val[1];
int thresh[] = {100};
boolean peakgate[] = {true};
int pval[] = {0};

//LEDs
int lstate;
int leds[NLED] = {};
int lednum, ledstate;

void setup() {
  Serial.begin(9600);
  //sets the digital pins for the buttons to input and pulls resistor high
  for (int i = 0; i < NB; i++) {
    pinMode(b[i], INPUT_PULLUP);
  } //end for (int i = 0; i < NB; i++) loop thru all buttons
  
  for (int i = 0; i<NLED; i++) { 
    pinMode(leds[i],OUTPUT);
  }
  
} //end setup


void loop() {
  
    //sms code from supercollider (nummsgs, lednum, ledstate)
  if (messageBuild() > 0) { // Checks to see if the message is complete and erases any previous messages
    lstate = messageGetInt();
    
    if (lstate == 1) {
      lednum = messageGetInt();
      ledstate = messageGetInt();
      if(ledstate == 1){
      digitalWrite(leds[lednum],HIGH);
    }
    else {
      digitalWrite(leds[lednum],LOW);
    }
    
  }
  }
  
   //FSRs
  for (int i = 0; i < NFSR; i++) {
    val[i] = analogRead(fsr[i]);
    //Peak Detection
    if (val[i] > thresh[i]) {
      Serial.print("fsr");
      Serial.print(i);
      Serial.print(":");
      Serial.println(val[i]);
      if (val[i] > pval[i]) { //is it going up?
        pval[i] = val[i];
      }
      else { //its going down i.e., val<pval
        if (peakgate[i]) { //if gate is open
          Serial.print("fsp");
          Serial.print(i);
          Serial.print(":");
          Serial.println(pval[i]); //this is our peak
          peakgate[i] = false; //close gate
        }
      }
    }
    else { //is below thresh
      peakgate[i] = true;
      pval[i] = 0;
    }
  }

  //POTS
  for (int i = 0; i < NP; i++) { //loop thru all pots
    pv[i] = analogRead(p[i]); //read analog pin
    //Send out values only when pot changes
    if ( pv[i] < (ppv[i] - 1) || pv[i] > (ppv[i] + 1) ) {
      //Action
      Serial.print( "p" + String(i) + ":");
      Serial.println(pv[i]); //send value to serial bus
      //Serial.print("z");
    }
    //Update previous value
    ppv[i] = pv[i];


  }//end loop thru all pots


  //BUTTONS

  for (int i = 0; i < NB; i++) { //loop thru all buttons

    //if button is pressed (reads LOW)
    if ( digitalRead(b[i]) == LOW ) { //button on

      ////Momentary
      if (bg[i]) {
        bg[i] = false;
        Serial.print( "b" + String(i) + ":");
        Serial.println(1);
       // Serial.print("z");
      }

      ////Toggles
      if (btg[i]) {
        btg[i] = false; //CLOSE GATE
        btv[i] = btv[i] + 1; //INC VALUE
        btv[i] = btv[i] % btamt[i]; //MOD VALUE
       // Serial.print( "bt" + String(i) + ":"); //PRINT HEADER
       // Serial.println(btv[i]); //PRINT VAL
      }

    } //end if button pressed

    //if button is released (reads HIGH)
    if ( digitalRead(b[i]) == HIGH ) { //button off

      ////Momentary
      if (!bg[i]) {
        bg[i] = true;
        Serial.print( "b" + String(i) + ":");
        Serial.println(0);
        //Serial.print("z");
      }

      ////Toggles
      if (!btg[i]) {
        btg[i] = true;
      }

    } //end if button released


  } //end loop all buttons
  delay(5);

} //end void loop


