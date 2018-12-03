
import org.openkinect.processing.*;

Kinect2 kinect2;

class Blob {
  
  float minx;
  float miny;
  float maxx;
  float maxy;
    
  PShape square;
  
  spectrum rainbow;
  
  
  
  ArrayList history = new ArrayList();
  float dist = 100;
  
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
  
    
  void show(PGraphics prism, PGraphics pyramid) { //int[] depth, int depthWidth
   
    prismLines(prism);
    drawShape(pyramid);//depth, depthWidth
    
   
    //textAlign(CENTER);
    //textSize(64);
    //fill(0);
    //text(id, minx + (maxx-minx)*0.5, maxy - 10);
    //textSize(32);
    //text(history.size(), minx + (maxx-minx)*0.5, miny - 10);
  }   
  
void drawShape(PGraphics pyramid){ //int[] depth, int depthWidth


  pyramid.stroke(240, 70);
  pyramid.noFill();

   for (int i=0; i<num; i++) {
  
    float sz = i*35;
    float sw = map(sin(theta+TWO_PI/num*i), -1, 1, 1, 16);
    pyramid.strokeWeight(sw);
    pyramid.ellipse((minx+maxx) / 2, (miny + maxy) / 2, sz, sz);
  }
  theta += TWO_PI/frames;
  
}
 
  //pyramid.ellipse((minx+maxx) / 2, (miny + maxy) / 2, 50, 50);
        //corners(pyramid, minx, miny);
        //corners(pyramid, maxx, miny);
        //corners(pyramid, minx, maxy);
        //corners(pyramid, maxx, maxy);
 
  
  
  void prismLines(PGraphics prism) {
    
    PVector d = new PVector((maxx - minx)* 0.5 + minx, (maxy - miny)* 0.5 + miny);
    history.add(0, d);    
    rainbow = new spectrum(0.05);
    
    
    for (int p=0; p<history.size (); p++) {
      
        PVector v = (PVector) history.get(p);
        float join = p/history.size() + d.dist(v)/dist;
      if (join < random(2.5)) {
        prism.stroke(rainbow.step());
        prism.strokeWeight(2);
        
        
        prism.line(d.x, d.y, v.x, v.y);
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
  
          
  void corners(PGraphics prism, float x, float y){
    float diam = 10;    
    prism.ellipse(x, y, diam, diam);
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
