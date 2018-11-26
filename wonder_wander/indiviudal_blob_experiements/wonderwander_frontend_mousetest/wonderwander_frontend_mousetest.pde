spectrum rainbow;
  
  ArrayList history = new ArrayList();
  float dist = 80;

void setup(){
  size(960, 540);
  randomSeed(0);
  background(230);
  frameRate(30);
  colorMode(RGB);
  strokeWeight(.1);
  noFill();
}

void draw(){
  pushStyle();
    PVector d = new PVector(mouseX, mouseY);
    history.add(0, d);
    popStyle();
    
    rainbow = new spectrum(0.05);
    
    
    for (int p=0; p<history.size (); p++) {
      
        PVector v = (PVector) history.get(p);
        float join = p/history.size() + d.dist(v)/dist;
      if (join < random(1.0)) {
        stroke(rainbow.step());
        strokeWeight(.3);
        //float newdx = map(d.x, 0, 512, -512, 1920);
        //float newvx = map(v.x, 0, 512, -512, 1920);
        //float newdy = map(d.y, 0, 424, -424, 1080);
        //float newvy = map(v.y, 0, 424, -424, 1080);
        
        
        line(d.x, d.y, v.x, v.y);
      
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
