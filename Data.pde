class Data {
  float time;
  float puls;

  Data(float t, float p) {
    time = t;
    puls = p;
  }
}

void reorderIncomingValues() {
  puls.add(vals[0]);
  sounds.add(vals[1]);
  vibs.add(vals[2]);
}

void resetArrays() {
  println("reset Arrays");
  round++;
  puls.clear();
  sounds.clear();
  vibs.clear();
  move.clear();
}

boolean saveData() {
  int minimum = min(puls.size(), sounds.size(), vibs.size());
  int arrSize = min(minimum, move.size());
  println("PULS SIZE:   " + arrSize);
  datenmenge = arrSize;
  measurements = new Table();
  // Spalten
  measurements.addColumn("time");
  measurements.addColumn("puls");
  measurements.addColumn("sound");
  measurements.addColumn("vibration");
  measurements.addColumn("camera");

  for (int i = 0; i < arrSize; i++) {
    TableRow newRow = measurements.addRow();
    newRow.setInt("time", measurements.getRowCount()-1);
    newRow.setInt("puls", puls.get(i));
    newRow.setInt("sound", sounds.get(i));
    newRow.setInt("vibration", vibs.get(i));
    newRow.setInt("camera", move.get(i));
  }
  String filename = "measurements" + round + ".csv";
  println("saveData in filename: " + filename);
  saveTable(measurements, "data/" + filename);
  return true;
}
