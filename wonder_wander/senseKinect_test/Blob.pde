class Blob {
  
  float minx;
  float miny;
  float maxx;
  float maxy;
  ArrayList history = new ArrayList();
  
  int id = 0;
  
  boolean taken = false;
  
  
  Blob(float x, float y){
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;
    
    
    
  }
  
  void show() {
    stroke(255);
    noFill();
    strokeWeight(2);
    rectMode(CORNERS);
    println(minx,miny,maxx,maxy);
    rect(minx, miny, maxx, maxy);
    
    //pushStyle();
    //PVector d = new PVector((minx + maxx) / 2, (miny + maxy) / 2, 0);
    //points.add(0, d);
    //popStyle();
    
    //for (int p=0; p<points.size (); p++) {
    //    PVector v = (PVector) history.get(p);
    //    float join = p/history.size() + d.dist(v)/dist;
    //    if (join < random(1.0)) {
    //      stroke(0);
    //      strokeWeight(.1);
    //      line(d.x, d.y, v.x, v.y);
    //    }
    //  }
    
  
  }
  
  
  void add(float x, float y){
    minx = min(minx, x);
    miny = min(miny, y);
    maxx = max(maxx, x);
    maxy = max(maxy, y);  
  }
  
  void become(Blob other) {
    minx = other.minx;
    maxx = other.maxx;
    miny = other.miny;
    maxy = other.maxy;
  }
  
  float size() {
    return (maxx-minx)*(maxy-miny);
  }
  
  PVector getCenter() {
    float x = (maxx - minx)* 0.5 + minx;
    float y = (maxy - miny)* 0.5 + miny;    
    return new PVector(x,y); 
  }
  
  
  boolean isNear(float x, float y) {
    
    float cx = max(min(x, maxx), minx);
    float cy = max(min(y, maxy), miny);
    float d = distSq(cx, cy, x, y);
    
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
