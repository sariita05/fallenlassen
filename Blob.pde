class Blob {
  float minx;
  float miny;
  float maxx;
  float maxy;
  float minx_old, miny_old, maxx_old, maxy_old;
  ArrayList<PVector> points;

  Blob(float x, float y) {
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    minx_old = x;
    miny_old = y;
    maxx_old = x;
    miny_old = y;
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
  }

  void show() {
    stroke(255);
    noFill();
    strokeWeight(2);
    rectMode(CORNERS);
    rect(minx, miny, maxx, maxy);
  }


  void add(float x, float y) {
    points.add(new PVector(x, y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);
  }

  float size() {
    return (maxx-minx)*(maxy-miny);
  }

  void saveOldPosition() {
    minx_old = minx;
    miny_old = miny;
    maxx_old = maxx;
    maxy_old = maxy;
  }

  boolean isMoving() {
    if ((minx_old-minx)>sizeThreshold || (miny_old-miny)>sizeThreshold || (maxx_old-maxx)>sizeThreshold || (maxy_old-maxy)>sizeThreshold) {
      return true;
    } else {
      return false;
    }
  }

  boolean isNear(float x, float y) {
    // Closest point in blob strategy
    float d = 10000000;
    for (PVector v : points) {
      float tempD = distSq(x, y, v.x, v.y);
      if (tempD < d) {
        d = tempD;
      }
    }

    if (d < distThreshold*distThreshold) {
      return true;
    } else {
      return false;
    }
  }
}
