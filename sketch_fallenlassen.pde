import processing.video.*;
import processing.serial.*;
import themidibus.*;
import javax.sound.midi.*;
import java.io.*;

// arduino measurements
static final int PORT_INDEX = 3, BAUDS = 9600;
int[] vals = {}; // values from sensors
ArrayList<Integer> puls = new ArrayList<Integer>();
ArrayList<Integer> sounds = new ArrayList<Integer>();
ArrayList<Integer> vibs = new ArrayList<Integer>();
Table measurements;
int round = 1;

// data analysis
Data[] data;
Table table;
float m = 1; // Steigung
int datenmenge = 0;

// camera
Capture video;
color trackColor = color(83, 91, 114); // default is black
float colorThreshold = 15; // wie hoch duerfen Farbunterschiede sein
float distThreshold = 75; // wie hoch duerfen Abstaende sein
float sizeThreshold = 7; // ab welchem Groessenunterschied ist es eine Bewegung
ArrayList<Blob> blobs = new ArrayList<Blob>();
ArrayList<Integer> move = new ArrayList<Integer>();

// midi
Sequencer playMidi;
File selection;
MidiBus myBus;
int midiDevice  = 0; // keyboard or LPD8
int myOutput = 2; // "Processing to DAW" -- GarageBand

// visuals
int transparency = 20;
int amount = 12; // maximum 12 dots and circles
int maxAmount = 1000; // maximum 1000 dots for phase08
Dot[] dots = new Dot[amount];
Dot[] dotts = new Dot[maxAmount];
Circle[] circles = new Circle[amount];

// phases
int maxPhases = 8;
int state = 9;                       // default 9 !!!!!!
int lastActivePhase = 8;             // begin with a black fullScreen and start with "ENTER"
boolean phase = true;


void setup() {
  noLoop();

  // arduino
  String[] ports = Serial.list();
  printArray(ports);
  new Serial(this, ports[PORT_INDEX], BAUDS).bufferUntil(ENTER);

  // midi
  MidiBus.list();
  myBus = new MidiBus(this, midiDevice, myOutput);

  // camera
  String[] camera = Capture.list();
  printArray(camera);
  video = new Capture(this, 720, 480, camera[1]); // [1] = "USB-Kamera"
  video.start();

  // size(1200, 800);
  fullScreen();
  background(10);
  fill(255);
  stroke(255);
  strokeWeight(2.5);
  smooth();

  for (int i = 0; i < amount; i++) {
    dots[i] = new Dot();
    circles[i] = new Circle();
  } 

  for (int i = 0; i < maxAmount; i++) {
    dotts[i] = new Dot();
  }

  delay(2000);
  println("setup done");
}

void draw() {
  endInstallationIfNecessary(); // after 15 minutes installation ends automatically 
  drawTransparentRect(transparency); // farbverlauf bei animation

  switch(state) {
    // phase 0: between every phase
    case 0:
      pause(); // sets parameter to default
      if (lastActivePhase == 1) { // from phase 1 always directly to phase 2
        phase = true;
        println("phase forward to: " + 2);
        state = 2;
      } else if (saveData()) { // from every other phase save the sensor data
        analyseData();         // and analyse it
      }
      break;
  
    case 1:
      lastActivePhase = state;
      phase01(3, 300);
      soundPhase12();
      whereToGo();
      break;
  
    case 2:
      lastActivePhase = state;
      phase02(12);
      soundPhase12();
      whereToGo();
      break;
  
    case 3:
      lastActivePhase = state;
      phase03(12, height / 4);
      soundPhase3();
      whereToGo();
      break;
  
    case 4:
      lastActivePhase = state;
      phase04(12);
      soundPhase4();
      whereToGo();
      break;
  
    case 5:
      lastActivePhase = state;
      phase05();
      soundPhase5();
      whereToGo();
      break;
  
    case 6:
      lastActivePhase = state;
      phase06(5); // 5 Kreise
      soundPhase6();
      whereToGo();
      break;
  
    case 7:
      lastActivePhase = state;
      phase07(12); // 12 Kreise
      soundPhase7();
      whereToGo();
      break;
  
    case 8: // maxPhases
      lastActivePhase = state;
      phase08();
      soundPhase8();
      whereToGo();
      break;
  
    case 9:
      background(10);
      stopMusic();
      break;
  }
}

void captureEvent(Capture video) {
  // read camera input all the time
  video.read();
  if (phase) {
    saveIncomingCameraValues();
  }
}

void serialEvent(final Serial s) {
  // read arduino input all the time
  vals = int(splitTokens(s.readString()));
  redraw = true;
  if (phase) {
    reorderIncomingValues();
  }
}

void drawTransparentRect(int t) {
  noStroke();
  fill(0, t);
  rect(0, 0, width, height);
}

void whereToGo() {
  if (!phase) {
    state = 0;
  }
}

void nextState() {
  phase = !phase; // immer wechseln zwischen aktiver Phase und Ruhephase (eine Ellipse)
  println("switched manually");
}

void startShow() {
  println("start");
  phase = true;
  round = 1; // filename
  lastActivePhase = 1;
  state = lastActivePhase;
}

void endInstallationIfNecessary() {
  int maxTime = 1000*60*14; // 1000*60 = 1min
  if (millis() >= maxTime && state == 0) {
    // end phase
    println(" ");
    println("DONE!! phase forward to: " + 9);
    resetArrays();
    state = 9;
  }
}

void keyPressed() {
  if (key == ' ') { // falls man Phase manuell überspringen will
    nextState();
  }
  if (key == ENTER) {
    startShow();
  }
  if (key == ESC) {
    stopMusic();
  }
}
