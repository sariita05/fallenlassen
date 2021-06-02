class Dot {
  float x, y, size, r, speed, speedIncrease, max, xspeed, yspeed;
  int counter;
  boolean increase;

  Dot() {
    x = 0;
    y = 0;
    size = 1;
    r = 1; 
    speed = 0.2;
    speedIncrease = 0.0002;
    max = height/3;
    xspeed = 0.3;
    yspeed = 0.1;
    counter = 0;
    increase = true;
  }

  void recenter() {
    x = 0;
    y = 0;
    size = 1;
    r = 1;
    speed = 0.2;     //default 0.3
    speedIncrease = 0.0002;
    max = height/3;
    xspeed = 0.3;    //default 0.3
    yspeed = 0.1;    //default 0.1
    counter = 0;
    increase = true;
  }

  void show() {
    ellipse(x, y, size, size);
  }

  void show(float dx, float dy, int ra) {
    ellipse(dx, dy, ra, ra);
  }

  void grow(int m) {
    if (counter < 1) {       // Phase 1: one time growing
      if (increase) {
        x = x + speed;
        speed += speedIncrease;
      } else if (increase == false) {
        x = x - speed;
        speed -= speedIncrease;
      }
      if (x > m) {
        increase = false;
        slot = 4; //decrease
      } else if (x < 0) {
        increase = true;
        slot = 1; //increase
        counter++;
      }
    } else {
      phase = false;
      speed = 0;
      slot = 0;
    }
  }

  void grow() {              //Phase 2: one time growing
    if (counter < 1) {
      if (increase) {
        x = x + speed;
        speed += speedIncrease;
      } else if (increase == false) {
        x = x - speed;
        speed -= speedIncrease;
      }
      if (x > max) {
        increase = false;
        slot = 4; // decrease
      } else if (x < 0) {
        increase = true;
        slot = 1; // increase
        counter++;
      }
    } else {
      phase = false;
      speed = 0;
      slot = 0;
    }
  }


  void growtill(int m) {     //Phase 3
    x = x + speed;
    speed += speedIncrease;
    if (x > m) {
      speed = 0;
    }
  }

  void shrink() {              //Phase 3
    if (x > 0) {    
      x = x - speed;
      speed = 0.3 - x*speedIncrease;
      
    } else if (x <= 0) {
      phase = false;
      slot = 0;
      speed = 0;
    }
  }

  void turningRight(int p) {    //Phase 3
    x = p;
    rotate(radians(r));
    r+= 0.1;                  //schnelligkeit
    if (r >= 150) {           //30 60 90 120 150 180 210 240 270 300
      statePhase3 = 2;
    }
  }

  void doStarMovement() {       //Phase 4
    if (counter < 6) {
      if(counter == 0) {
        slot = 1;
      } else if (counter <= 3) {
        slot = 2;
      } else {
        slot = 3;
      }
      x = x + xspeed;
      y = y + yspeed;
      if (x > height/6 || x < 0) {
        xspeed = -xspeed;
        counter++;
      }
    } else {
      slot = 4;
      xspeed = 0.3 - y*speedIncrease;
      y = y - xspeed;
      if (y <= 0) {
        phase = false;
        xspeed = 0;
        yspeed = 0;
      }
    }
  }
}
