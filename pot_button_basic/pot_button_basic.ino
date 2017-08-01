//Pots
int p0 = A0;
int pv0;


void setup() {
  Serial.begin(9600);
} //end setup

void loop() {
  pv0 = analogRead(p0);
  Serial.print( "p0:" );
  Serial.println( pv0 );
  delay(5);
} //end loop
