class Blob {
  
  float minx;
  float miny;
  float maxx;
  float maxy;
  ArrayList history = new ArrayList();
  
  ArrayList<PVector> points;
  
  
  Blob(float x, float y){
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    
    points = new ArrayList<PVector>();
    points.add(new PVector(x, y));
    
  }
  
  void show() {
    stroke(255);
    noFill();
    strokeWeight(2);
    rectMode(CORNERS);
    println(minx,miny,maxx,maxy);
    rect(minx, miny, maxx, maxy);
    
    pushStyle();
    PVector d = new PVector((minx + maxx) / 2, (miny + maxy) / 2, 0);
    points.add(0, d);
    popStyle();
    
    for (int p=0; p<points.size (); p++) {
        PVector v = (PVector) history.get(p);
        float join = p/history.size() + d.dist(v)/dist;
        if (join < random(1.0)) {
          stroke(0);
          strokeWeight(.1);
          line(d.x, d.y, v.x, v.y);
        }
      }
    
    for (PVector v: points) {
      stroke(0, 0, 255);
      point(v.x, v.y);
 
    }
  }
  
  
  void add(float x, float y){
    points.add(new PVector(x,y));
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);  
  }
  
  float size() {
    return (maxx-minx)*(maxy-miny);
  }
  
  
  boolean isNear(float x, float y) {
    //The rectangle "Clamping" strategy
    //float cx = minx + maxx / 2; 
    //float cy = miny + maxy / 2;
    
    ////changed c from d bbecause d is already referenced in code
    //float n = distSq(cx, cy, x, y); 
    
    //CLosest point in blob strategy
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
  
  //void lines() {
    
    //pushStyle();
    //PVector d = new PVector((minx + maxx) / 2, (miny + maxy) / 2, 0);
    //points.add(0, d);
    //popStyle();
    
    //for (int p=0; p<points.size (); p++) {
    
    //  PVector v = (PVector) points.get(p);
      //float join = p/points.size() + d.dist(v)/dist;
      //if (join < random(1.0)) {
      //  stroke(0);
      //  strokeWeight(.1);
  //      line(d.x, d.y, v.x, v.y);
  //      println(d.x, d.y, v.x, v.y);
  //    }
  //  }
  //}
}
