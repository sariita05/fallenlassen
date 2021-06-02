int slot = 1; // split animation in 4 parts // 1: increase // 2: middle-part-1 // 3: middle-part-2 // 4: decrease
int note = 36;
int channel = 144;
int pitch = 48; // note
int velocity = 64;
float midiValueMax = 127;
int volumeMin = 70;
float vol = 0.05;

// controller Drehregler
int controllerOne = 1;   // Voices
int controllerTwo = 2;   // Trans Osci 2
int controllerThree = 3; // Tune Osci 2
int controllerFour = 4;  // Filter rechts
int controllerFive = 5;  // Filter unten
int controllerSix = 6;   // Feedback Amount
int controllerSeven = 7; // Volume
int controllerEight = 8; // Shutter softness

// G-Dur Tonleiter
// #31 G / #33 A / #35 H 
// #36 C / #38 D / #40 E / #42 Fis
// #43 G / #45 A / #47 H 
// #48 C / #50 D / #52 E / #54 Fis
int notePh1 = 38; // D
int notePh2 = 38; // D
int notePh3 = 40; // E
int notePh4 = 42; // Fis
int notePh5 = 43; // G
int notePh6 = 45; // A
int notePh7 = 47; // H
int notePh8 = 48; // C

// setup controller 
float valueOsci1 = 60;        // 1
float valueOsci2 = 50;        // 2
float valueFeedback = 65;     // 3
float valueFilterHeight = 10; // 4
float valueFilterWidth = 65;  // 5
float valueSub = 65;          // 6
float valueVolume = 40;       // 7
float valueReverbMix = 65;    // 8

void pauseMusic() {  // between phases
  noteOff(note);     // turn off note
  controllerSetup(); // turn off controller
}

void stopMusic() { // at the end
  noteOff(note);
  myBus.sendControllerChange(channel, controllerSeven, 0); // mute
}

void noteOn(int note) {
  myBus.sendNoteOn(channel, note, velocity); // Send a Midi noteOn
}

void noteOff(int note) {
  myBus.sendNoteOff(channel, note, velocity); // Send a Midi nodeOff
}

void controllerSetup() { // default values
  slot = 1;
  valueOsci1 = 60;        // 1
  valueOsci2 = 50;        // 2
  valueFeedback = 65;     // 3
  valueFilterHeight = 10; // 4
  valueFilterWidth = 65;  // 5
  valueSub = 65;          // 6
  valueVolume = 70;       // 7
  valueReverbMix = 65;    // 8

  myBus.sendControllerChange(channel, controllerOne, int(valueOsci1));
  myBus.sendControllerChange(channel, controllerTwo, int(valueOsci2));
  myBus.sendControllerChange(channel, controllerThree, int(valueFeedback));
  myBus.sendControllerChange(channel, controllerFour, int(valueFilterHeight));
  myBus.sendControllerChange(channel, controllerFive, int(valueFilterWidth));
  myBus.sendControllerChange(channel, controllerSix, int(valueSub));
  myBus.sendControllerChange(channel, controllerSeven, int(valueVolume));
  myBus.sendControllerChange(channel, controllerEight, int(valueReverbMix));
}

void manageVolume() {
  float vol = 0.03;
  myBus.sendControllerChange(channel, controllerSeven, int(valueVolume));
  if (slot == 1 && valueVolume <= 90) {
    valueVolume += vol;
  } else if (slot == 4 && valueVolume >= volumeMin) {
    valueVolume -= vol;
  }
}

void soundPhase12() {
  note = notePh1;
  noteOn(note);
  manageVolume();
  // OSCI 2
  float osc = 0.02;
  myBus.sendControllerChange(channel, controllerTwo, int(valueOsci2));
  if (slot == 1 && valueOsci2 <= 70) {
    valueOsci2 += osc;
  } else if (slot == 4 && valueOsci2 >= 50) {
    valueOsci2 -= osc;
  }
}

void soundPhase3 () {
  note = notePh3;
  noteOn(note);
  manageVolume();
  // OSCI 1
  float osc = 0.003;
  myBus.sendControllerChange(channel, controllerOne, int(valueOsci1));
  if (slot < 3 && valueOsci1 <= midiValueMax) {
    valueOsci1 += osc;
  } else if (slot == 4 && valueOsci1 >= 60) {
    valueOsci1 -= osc;
  }
}

void soundPhase4 () {
  note = notePh4;
  noteOn(note);
  manageVolume();
  // FEEDBACK
  float fee = 0.03;
  myBus.sendControllerChange(channel, controllerThree, int(valueFeedback));
  if (slot == 2  && valueFeedback <= midiValueMax) {
    valueFeedback += fee;
  } else if (slot == 3 && valueFeedback >= 65) {
    valueFeedback -= fee;
  }
}

void soundPhase5 () {
  note = notePh5;
  noteOn(note);
  manageVolume();
}

void soundPhase6 () {
  note = notePh6;
  noteOn(note);
  manageVolume();
  // FilterHeight
  float fiH = 0.04;
  myBus.sendControllerChange(channel, controllerFour, int(valueFilterHeight));
  if (slot == 1  && valueFilterHeight <= midiValueMax) {
    valueFilterHeight += fiH;
  } else if (slot == 4 && valueFilterHeight >= 10) {
    valueFilterHeight -= fiH;
  }
}

void soundPhase7 () {
  note = notePh7;
  noteOn(note);
  // FEEDBACK && OSCI 2 && SUB && OSCI 1
  float osc = 0.005;
  float fee = 0.005;
  float sub = 0.008;
  myBus.sendControllerChange(channel, controllerTwo, int(valueOsci2));
  myBus.sendControllerChange(channel, controllerThree, int(valueFeedback));
  myBus.sendControllerChange(channel, controllerSix, int(valueSub));

  if (slot == 1 && valueOsci2 <= 60) {
    valueOsci2 += osc;
  } else if (slot == 2  && valueFeedback <= midiValueMax) {
    if (valueOsci2 <= 70) {
      valueOsci2 += osc;
    }
    valueFeedback += fee;
    valueSub += sub;
  } else if (slot == 3 && valueFeedback >= 65) {
    if (valueOsci2 >= 50) {
      valueOsci2 -= osc;
    }
    valueFeedback -= fee;
    valueSub -= sub;
  } else if (slot == 4 && valueOsci2 >= 50) {
    valueOsci2 -= osc;
  }
}

void soundPhase8 () {
  note = notePh8;
  noteOn(note);

  // OSCI 2 & REVERB & FEEDBACK
  float osc = 0.005;
  float rev = 0.002;
  float fee = 0.003;
  myBus.sendControllerChange(channel, controllerTwo, int(valueOsci2));
  // myBus.sendControllerChange(channel, controllerEight, int(valueReverbMix));
  myBus.sendControllerChange(channel, controllerThree, int(valueFeedback));
  if (slot == 1 && valueOsci2 <= 60) {
    valueOsci2 -= osc;
  } else if (slot == 2) {
    if (valueReverbMix <= midiValueMax) {
      valueReverbMix += rev;
    }
    if (valueFeedback <= midiValueMax) {
      valueFeedback += fee;
    }
  } else if (slot == 3) {
    if (valueReverbMix >= 65) {
      valueReverbMix -= rev;
    } 
    if (valueFeedback >= 65) {
      valueFeedback -= fee;
    }
  } else if (slot == 4 && valueOsci2 >= 50) {
    valueOsci2 += osc;
  }
}
