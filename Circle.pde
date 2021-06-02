class Circle {
  float x, y, r, a, xmax, ymax, xmin, ymin, randomSpeedx, randomSpeedy, xspeed, yspeed, rspeed, rspeedIncrease;
  int counterX, counterY;
  boolean decrease;

  Circle() {
    x = 0;
    y = 0;
    r = 0;
    a = 15;
    randomSpeedx = random(0.01, 0.15);
    randomSpeedy = random(0.01, 0.15);
    xspeed = 0.1; 
    yspeed = 0.1; 
    rspeed = 0.2;
    rspeedIncrease = 0.0002;
    counterX = 0;
    counterY = 0;
    decrease = false;
  }

  void recenter() { 
    x = 0;
    y = 0;
    r = 0;
    a = 15;
    randomSpeedx = random(0.01, 0.15);
    randomSpeedy = random(0.01, 0.15);
    xspeed = 0.1; // default 0.1
    yspeed = 0.1; // default 0.1
    rspeed = 0.2; 
    rspeedIncrease = 0.0002;
    counterX = 0;
    counterY = 0;
    decrease = false;
  }

  void show() {                   // Phase 5, 6, 7, 8
    ellipse(x, y, r, r);
  }

  void show(int rad) {            // Phase 7
    ellipse(x, y, rad, rad);
  }

  void grow() {                   //Phase 5
    if (r > height/2) {
      slot = 4; // decrease
      decrease = true;
    } else if (r < 0) {
      phase = false;
    }
    if (decrease == false) {
      r = r + rspeed;
      rspeed += rspeedIncrease;
    } else if (decrease) {
      r = r - rspeed;
      rspeed -= rspeedIncrease;
    }
  }
  
  void growPhase6() {              // Phase 6
    if (r > height/2) {
      decrease = true;
      slot = 4;
    } else if (r < 0) {
      phase = false;
    }
    if (decrease == false) {
      r = r + rspeed;
      rspeed += rspeedIncrease;
    } else if (decrease) {
      r = r - rspeed;
      rspeed -= rspeedIncrease;
    }
  }

  void growtill(int radius) {      //Phase 7, 8
    r = r + rspeed;
    rspeed += rspeedIncrease;
    if (r > radius) {
      rspeed = 0;
    }
  }

  void shrinktill(int radius) {     //Phase 7, 8
    r = r - rspeed;
    rspeed = 0.3 - r*rspeedIncrease*0.1;
    if (r < radius) {
      rspeed = 0;
      phase = false;
    }
  }

  void wabbeling() {              // Phase 6  
    float max = r/20;
    float min = -r/20;
    x = x + randomSpeedx;
    y = y + randomSpeedy;
    if (x > max || x < min) {
      randomSpeedx = -randomSpeedx;
    }
    if (y > max || y < min) {
      randomSpeedy = -randomSpeedy;
    }
    if (decrease) { // sodass es wieder im Ursprung zusammenläuft
      x = x - (x/r); 
      y = y - (y/r);
    }
  }

  void doPhase07() {              // Phase 7
    if (counterX < 2 && counterY < 2) {
      if (counterX < 1) {
        slot = 2;
      } else if (counterX == 1) {
        slot = 3;
      }

      x = x + xspeed;
      y = y + yspeed;
      if (x > width/4 || x < 0) {
        xspeed = -xspeed;
        counterX++;
      }
      if (y > height/2-70 || y < 0) {
        yspeed = -yspeed;
        counterY++;
      }
    } else {
      slot = 3;
      y = y + yspeed;
      if (y <= 0) {
        statePhase7 = 2;
      }
    }
  }
}
