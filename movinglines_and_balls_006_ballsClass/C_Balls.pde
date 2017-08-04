class Balls {
  //constructor variables
  int hs;
  //class variables
  int x = int(width/2);
  int y = 180;
  int hdir = 1;
  int vdir = 1;
  int vs = 2;
  //constructor
  Balls(int ahs) {
    hs = ahs;
  }

  //draw method
  void drw() {

    //balls
    float ynorm = norm(y, 0.0, height);


    //horiz boundries
    //when hitting right boundary
    if ( (x+8) >= l2x ) {
      hdir = -1; //reverse direction
      osc.send("/hit", new Object[]{ynorm}, sc); //send sc when hitting boundary
      vs = round(random(1, 7)); //change vert speed when hitting right boundary
      //change direction when hitting right boundry
      int dch = round(random(1)); 
      if (dch == 0) vdir = -1;
      else vdir = 1;
    } //end right boundary

    //left boundary
    if ( (x-8) <= l1x ) {
      hdir = 1;
      // b0v = round(random(2, 11));
      osc.send("/hit", new Object[]{ynorm}, sc);
      vs = round(random(1, 7));
    }

    //vert boundries
    if ( (y-8) <= 0 ) {
      vdir = 1;
      osc.send("/samp1", new Object[]{}, sc); //send to sc
    }
    if ( (y+8) >= height ) vdir = -1;

    //animation
    x = x + (hs*hdir); //x speed & dir
    y = y + (vs*vdir); //y speed & dir

    //drawing
    noStroke();
    fill(255);
    ellipseMode(CENTER);
    ellipse(x, y, 17, 17);
  }//end drw
}