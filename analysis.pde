void analyseData() {
  if (lastActivePhase <= 3 && round >= 3) {
    println("Person GOT STUCK in the beginning!!");
    onePhaseUp();
  } else {
    readData(); // scanData
    fillNewPulseArray();
    if (isRelaxedEnough() == false) {
      println("Person is NOT RELAXED enough!!");
      onePhaseDown();
    } else {
      if (lastActivePhase < maxPhases) {
        onePhaseUp();
        println("yipiiiiiieh  -----   Person IS RELAXED enough!!");
      } else {
        // end phase
        println(" ");
        println("DONE!! phase forward to: " + 9);
        resetArrays();
        state = 9;
      }
    }
  }
}

void onePhaseUp() {
  println(" ");
  println("phase forward to: " + (lastActivePhase + 1));
  phase = true;
  resetArrays();
  state = lastActivePhase + 1; // eine phase weiter springen
}

void onePhaseDown() {
  println(" ");
  println("phase backwards to: " + (lastActivePhase -1));
  phase = true;
  resetArrays();
  state = lastActivePhase - 1;
}

boolean isRelaxedEnough() {
  float pulse = calculatePulse();
  float move = calculateMovement();

  if ((pulse < -0.2) || (pulse < -0.1 && move < 30)) { // puls ist gesunken sofort nächste phase
    return true;                                       // oder puls steigt flach an und es liegt wenig bewegung vor
  } else {
    return false;
  }
}

float calculatePulse() {
  if (data.length > 1) {
    return linearRegression();
  } else {
    return 0;
  }
}

float calculateMovement() {
  int soundAmount = 0;
  int vibAmount = 0;
  int moveAmount = 0;
  float movementIndex = 0;

  for (int i = 0; i < datenmenge; i++) {
    TableRow row = table.getRow(i);
    int s0 = row.getInt("sound"); // daten aus file
    println("s0: " + s0);
    int v0 = row.getInt("vibration");
    int m0 = row.getInt("camera");
    if (thereIsSound(s0)) {
      soundAmount++;
    }
    if (thereIsVibration(v0)) {
      vibAmount++;
    }
    if (thereIsMovement(m0)) {
      moveAmount++;
    }
  }
  println("soundAmount: " + soundAmount);
  println("vibAmount: " + vibAmount);
  println("camera movement: " + moveAmount);

  float s1 = soundAmount*100/datenmenge;
  float v1 = vibAmount*100/datenmenge;
  float m1 = moveAmount*100/datenmenge;
  movementIndex = (s1+v1+m1)/3;
  println("movementIndex: " + movementIndex);
  return movementIndex;
}

boolean thereIsMovement(int m) {
  // Größenänderung berechnen
  int max = 500;
  int normalMax = 125;
  if (m > normalMax && m < max) {
    return true;
  } else {
    return false;
  }
}

boolean thereIsVibration(int v) {
  int min = 20;
  int max = 500;
  int normalMin = 175;
  int normalMax = 176;
  if ((v > min && v < normalMin) || (v > normalMax && v < max)) {
    return true;
  } else {
    return false;
  }
}

boolean thereIsSound(int s) {
  int min = 20;
  int max = 500;
  int normalMin = 252;
  int normalMax = 253;
  if ((s > min && s < normalMin) || (s > normalMax && s < max)) {
    return true;
  } else {
    return false;
  }
}

void fillNewPulseArray() {
  data = new Data[datenmenge];
  float pulsMin = 20;
  float pulsMax = 180;

  // array mit werten befuellen
  for (int i = 0; i < datenmenge; i++) {
    TableRow row = table.getRow(i);
    int t = row.getInt("time"); // daten aus file
    int p = row.getInt("puls");

    float x = map(t, 0, datenmenge, 0, 1);
    float y = map(p, pulsMin, pulsMax, 1, 0); // Ursprung links unten statt links oben
    data[i] = new Data(x, y);
  }
}

float linearRegression() {
  float xsum = 0;
  float ysum = 0;
  // summe berechnen
  for (int i = 0; i < datenmenge; i++) {
    xsum += data[i].time;
    ysum += data[i].puls;
  }
  float dx = xsum / datenmenge; // Durchschnitt X
  float dy = ysum / datenmenge; // Durchschnitt Y

  float zae = 0;
  float nen = 0;
  for (int i = 0; i < datenmenge; i++) {
    float x = data[i].time;
    float y = data[i].puls;
    zae += (x - dx) * (y - dy); // Zähler aufsummieren
    nen += (x - dx) * (x - dx); // Nenner aufsummieren
  }

  // b = dy - m * dx; // Y-Achsenabschnitt
  m = zae / nen; // Steigung
  println("m: " + m);
  return m;
}

void readData() {
  String filename = "measurements" + round + ".csv"; // bsp: "measurements1.csv"
  println("read file :" + filename);
  table = loadTable(filename, "header");
}
