import oscP5.*;
import netP5.*;

OscP5 osc;
NetAddress proc0;

void setup(){
  osc = new OscP5(this, 12322);
  proc0 = new NetAddress("127.0.0.1", 12321);
  osc.plug(this, "p0", "/p0");
  
}


void draw(){
  
}

public void p0(int data){
  println(data);
}

void mousePressed(){
  osc.send("/getosc", new Object[]{"p0", 1}, proc0);
}