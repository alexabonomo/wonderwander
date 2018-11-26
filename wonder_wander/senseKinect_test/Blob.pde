class Blob {
  
  float minx;
  float miny;
  float maxx;
  float maxy;
  spectrum rainbow;
  
  ArrayList history = new ArrayList();
  float dist = 80;
  
  int id = 0;
  
  int lifespan = maxLife;
  
  boolean taken = false;
  //ArrayList <Lines> newlines = new ArrayList <Lines> ();
  
  
  
  Blob(float x, float y){
    minx = x;
    miny = y;
    maxx = x;
    maxy = y;   
  }
  
  boolean checkLife() {
    lifespan--; 
    if (lifespan < 0) {
      return true;
    } else {
      return false;
    }
  }
    
  void show() {
    stroke(255);
    noFill();
    strokeWeight(2);
    rectMode(CORNERS);
    println(minx,miny,maxx,maxy);
    fill(0);
    
   
   addLines();
    
   
    //textAlign(CENTER);
    //textSize(64);
    //fill(0);
    //text(id, minx + (maxx-minx)*0.5, maxy - 10);
    //textSize(32);
    //text(history.size(), minx + (maxx-minx)*0.5, miny - 10);
  }
  
  void addLines() {

    pushStyle();
    PVector d = new PVector((maxx - minx)* 0.5 + minx, (maxy - miny)* 0.5 + miny);
    history.add(0, d);
    popStyle();
    
    rainbow = new spectrum(0.05);
    
    
    for (int p=0; p<history.size (); p++) {
      
        PVector v = (PVector) history.get(p);
        float join = p/history.size() + d.dist(v)/dist;
      if (join < random(1.0)) {
        stroke(rainbow.step());
        strokeWeight(.1);
        float newdx = map(d.x, 0, 512, -512, 1920);
        float newvx = map(v.x, 0, 512, -512, 1920);
        float newdy =map(d.y, 0, 424, -424, 1080);
        float newvy =map(v.y, 0, 424, -424, 1080);
        
        
        line(newdx, newdy, newvx, newvy);
      
        println(d.x, d.y, v.x, v.y);
        
      }
    }
    
  }
 
  
  class spectrum{
    int colorOn;
    float frequency;
    boolean colorDecreasing = false;
    color current;
    spectrum(float freq){
    frequency = freq;
    colorOn = (230);
    current = color(255);
  }
    color step(){
      if(colorOn >= (9.6/frequency) && !colorDecreasing){
        colorDecreasing = true;
      }
      if(colorOn <= 0  && colorDecreasing){
        colorDecreasing = false;
      }
      if(colorDecreasing){
        colorOn -=.5;
      }
      else{
        colorOn +=.1;
      }
      int r = int(sin(frequency*colorOn)*127 + random(90, 128));
      int g = int(sin(frequency*colorOn+2)*127 + random(90, 128));
      int b = int(sin(frequency*colorOn+4)*127 + random(90, 128));
      int a = 10;
      current = color(r,g,b,a);
      return(current);
    }
    
    void resetColor(){
      colorOn = 230;
      colorDecreasing = false;
      }
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
    lifespan = maxLife;
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
}
