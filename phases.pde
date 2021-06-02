int statePhase3, statePhase7, statePhase8 = 0;
float faderX = 0;
float speedphase8 = 0.3;

// Phase 0
void pause() {
  pauseMusic();
  int size = 1;
  fill(255);
  ellipse(width / 2, height / 2, size, size);
  for (int i = 0; i < dots.length; i++) {
    dots[i].recenter(); // x und y Pos für nächste Phasen auf 0 setzen
    circles[i].recenter();
  }
}

// Phase 1: 3 dots growing
void phase01(int anzahl, int max) {
  prepDots();

  for (int i = 0; i < anzahl; i++) {
    dots[i].grow(max);
    dots[i].show();
    rotate(radians(360 / anzahl)); // koordinatensystem drehen
  }
}

// Phase 2: 12 dots growing
void phase02(int anzahl) {
  prepDots();

  for (int i = 0; i < anzahl; i++) {
    dots[i].grow();
    dots[i].show();
    rotate(radians(360 / anzahl));
  }
}

boolean uebergangzu03(int pos, int anzahl) {
  if (dots[0].x < pos) {
    for (int i = 0; i < anzahl; i++) {
      dots[i].growtill(pos);
      dots[i].show();
      rotate(radians(360 / anzahl));
    }
  } else if (dots[0].x >= pos) {
    return true;
  }
  return false;
}

// Phase 3: dots turning-right
void phase03(int anzahl, int pos) {
  prepDots();

  switch(statePhase3) {
    case 0:
    slot = 1; // increase
    if (uebergangzu03(pos, anzahl) == true) {
      statePhase3 = 1;
    }
    break;

    case 1:
    slot = 2; // middlepart
    for (int i = 0; i < anzahl; i++) {
      pushMatrix();
      dots[i].turningRight(pos);
      dots[i].show();
      popMatrix();
      rotate(radians(360 / anzahl));
    }
    break;

    case 2:
    slot = 4; // decrease
    for (int i = 0; i < anzahl; i++) {
      dots[i].shrink();
      dots[i].show();
      rotate(radians(360 / anzahl));
    }
    break;
  }
}

// Phase 4: one circle growing
void phase04(int anzahl) {
  prepDots();

  for (int i = 0; i < anzahl; i++) {
    dots[i].doStarMovement();
    dots[i].show();
    rotate(radians(360 / anzahl));
  }
}

// Phase 5: wabbeling circles
void phase05() {
  prepCircles();

  circles[0].grow();
  circles[0].show();
}

// Phase 6
void phase06(int a) {
  prepCircles();

  for (int i = 0; i < a; i++) {
    circles[i].wabbeling();
    circles[i].growPhase6();
    circles[i].show();
  }
}

// Phase 7: flower animation
void phase07(int a) {
  prepCircles();

  switch(statePhase7) {
    case 0:
    if (growing(560)) {
      statePhase7 = 1;
    }
    break;

    case 1:
    for (int i = 0; i < a; i++) {
      circles[i].doPhase07();
      circles[i].show(560);
      rotate(radians(360 / a));
    }
    break;

    case 2:
    shrinking(0);
    break;
  }
}

boolean growing(int radius) {
  slot = 1;
  if (circles[0].r < radius) {
    circles[0].growtill(radius);
    circles[0].show();
  } else if (circles[0].r >= radius) {
    return true;
  }
  return false;
}

boolean shrinking(int endRadius) {
  slot = 4;
  if (circles[0].r > endRadius) {
    circles[0].shrinktill(endRadius);
    circles[0].show();
  } else if (circles[0].r <= endRadius) {
    return true;
  }
  return false;
}

// Phase 8: universe
void phase08() {
  int size = 1;
  switch(statePhase8) {
    case 0:
    prepCircles();
    if (growing(600)) { // 560
      slot = 2;
      statePhase8 = 1;
    }
    break;

    case 1:
    phase08middle(size);
    break;

    case 2:
    prepCircles();
    if (shrinking(0)) {
      slot = 0;
    }
    break;
  }
}

void phase08middle(int size) {
  fill(255);
  stroke(255);
  faderX += speedphase8;

  if (faderX > width) {
    speedphase8 = -speedphase8;
    slot = 3;
  } else if (faderX < 0) {
    slot = 4;
    statePhase8 = 2;
  }
  randomSeed(0); // random ist in jedem Durchgang der for Schleife gleich
  float angle = radians(360 / float(maxAmount));
  for (int i = 0; i < maxAmount; i++) {
    // positions
    float randomX = random(0, width);
    float randomY = random(0, height);

    float circleX = width / 2 + cos(angle * i) * 300;
    float circleY = height / 2 + sin(angle * i) * 300;

    float x = lerp(circleX, randomX, faderX / width);
    float y = lerp(circleY, randomY, faderX / width);

    dotts[i].show(x, y, size);
  }
}

void prepDots() {
  fill(255);
  stroke(255);
  // Ursprung in Mitte verschieben
  translate(width / 2, height / 2);
}

void prepCircles() {
  noFill();
  stroke(255);
  strokeWeight(1.5);
  // Ursprung in Mitte verschieben
  translate(width / 2, height / 2);
}
