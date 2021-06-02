void saveIncomingCameraValues() {
  video.loadPixels();
  // image(video, 0, 0); // show camera in view
  blobs.clear();
  scanPixels();
  for (Blob b : blobs) {
    if (b.size() > 500) {
      // b.show(); // show blobs
      b.isMoving();

      if (b.isMoving()) {
        println("there was movement");
        move.add(1);
      } else { 
        println("no movement");
        move.add(0);
      }
    }
  }
}

void scanPixels() {
  // Begin loop to walk through every pixel
  for (int x = 0; x < video.width; x++ ) {
    for (int y = 0; y < video.height; y++ ) {
      int loc = x + y * video.width;
      // What is current color
      color currentColor = video.pixels[loc];
      float r1 = red(currentColor);
      float g1 = green(currentColor);
      float b1 = blue(currentColor);
      float r2 = red(trackColor);
      float g2 = green(trackColor);
      float b2 = blue(trackColor);

      float d = distSq(r1, g1, b1, r2, g2, b2); // colordistance

      if (d < colorThreshold*colorThreshold) { // falls farbunterschiede gering genug sind

        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.saveOldPosition();
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }
      }
    }
  }
}


// Custom distance functions w/ no square root for optimization
float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2-x1)*(x2-x1) + (y2-y1)*(y2-y1) +(z2-z1)*(z2-z1);
  return d;
}

// void mousePressed() {
//   // Save color where the mouse is clicked in trackColor variable
//   int loc = mouseX + mouseY*video.width;
//   trackColor = video.pixels[loc];
// }
