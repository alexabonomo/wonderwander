import org.openkinect.processing.*;
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;


float scale;
int blobCounter = 0;

float minThresh = 0;
float maxThresh = 1500;
PImage img;
PGraphics prism;
PGraphics pyramid;

float dist = 200;
int maxLife = 50;

float threshold = 40;
float distThreshold = 50;
int frame = 0;


ArrayList <Blob> blobs = new ArrayList <Blob> ();



void setup() {
  fullScreen();
  smooth();


  //Kinect Setup
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  scale = width/20;
  
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  
  
  prism = createGraphics(width, height);
 

  randomSeed(0);
  frameRate(15);
  colorMode(RGB);
  strokeWeight(1);
  noFill();
}
void draw() {
  frame ++;

  img.loadPixels();

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

  int[] depth = kinect2.getRawDepth();
  int move = 100;
  //float xxx = map(100, move, kinect2.depthWidth - move, 0, width);
  //float yyy =map(100, 0, kinect2.depthHeight, 0, height);
  //println(xxx,yyy);
  
  
  int boxHeight = ((kinect2.depthWidth - move) * height) / width;
  
  for (int x = move; x < kinect2.depthWidth; x+=1) {
    for (int y = 0; y < boxHeight; y+=1) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      boolean drawDot = x % 3 < 2 && y % 3 < 2;
     
      img.pixels[offset] = color(200);
      if (d > minThresh && d < maxThresh && x > 100) {
        if (drawDot) img.pixels[offset] = color(190);
        
        float newx = map(x-move, 0, kinect2.depthWidth - move, 0, width);
        float newy =map(y, 0, boxHeight, 0, height);

        
        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(newx, newy)) {
            b.add(newx, newy);
            found = true;
            depth[offset] = b.id;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(newx, newy);
          currentBlobs.add(b);
          depth[offset] = b.id;
        }
      } else {
        depth[offset] = -1;
      }
    }
  }
  
  

  img.updatePixels();

  //img.filter(BLUR, 3);
  //image(img.get(move,0, kinect2.depthWidth - move, boxHeight), 0, 0, width, height);
  
   
 
  for (int i = currentBlobs.size()-1; i >= 0; i--) {
    if (currentBlobs.get(i).size() < 500) {
      currentBlobs.remove(i);
    }
  }

  // There are no blobs!
  if (blobs.isEmpty() && currentBlobs.size() > 0) {
    println("Adding blobs!");
    for (Blob b : currentBlobs) {
      b.id = blobCounter;
      blobs.add(b);
      blobCounter++;
    }
  } else if (blobs.size() <= currentBlobs.size()) {
    // Match whatever blobs you can match
    for (Blob b : blobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob cb : currentBlobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !cb.taken) {
          recordD = d; 
          matched = cb;
        }
      }
      
      if (matched != null){
        matched.taken = true;
        b.become(matched);
      }
    }

    // Whatever is leftover make new blobs
    for (Blob b : currentBlobs) {
      if (!b.taken) {
        b.id = blobCounter;
        blobs.add(b);
        blobCounter++;
      }
    }
  } else if (blobs.size() > currentBlobs.size()) {
    for (Blob b : blobs) {
      b.taken = false;
    }


    // Match whatever blobs you can match
    for (Blob cb : currentBlobs) {
      float recordD = 1000;
      Blob matched = null;
      for (Blob b : blobs) {
        PVector centerB = b.getCenter();
        PVector centerCB = cb.getCenter();         
        float d = PVector.dist(centerB, centerCB);
        if (d < recordD && !b.taken) {
          recordD = d; 
          matched = b;
        }
      }
      if (matched != null) {
        matched.taken = true;
        matched.lifespan = maxLife;
        matched.become(cb);
      }
    }

    for (int i = blobs.size() - 1; i >= 0; i--) {
      Blob b = blobs.get(i);
      if (!b.taken) {
        if (b.checkLife()) {
          blobs.remove(i);
        }
      }
    }
  }

  prism.beginDraw();
  for (Blob b : blobs) {
    b.show(prism); 
    
  }
  if (frame % 2 == 0) {
    prism.loadPixels();
    for (int i=0; i < prism.pixels.length; i++) {
      float r = red(prism.pixels[i]);
      float g = green(prism.pixels[i]);
      float b = blue(prism.pixels[i]);
      float a = alpha(prism.pixels[i]);
      a = constrain(a-10,0,255);
      prism.pixels[i] = color(r,g,b,a);
      
    }
   
   for (int i = 0; i < scale; i++) {
    background(millis()%((i+1) * 100));
   }
    prism.updatePixels();
  }
  prism.endDraw();  

    image(img.get(move,0, kinect2.depthWidth - move, boxHeight), 0, 0, width, height);
    image(prism, 0, 0);
    //translate(384,0)
    
    

    
 
  
  

 
    
  //textAlign(RIGHT);
  //fill(0);
  //text(currentBlobs.size(), width-10, 40);
  //text(blobs.size(), width-10, 80);
  //textSize(24);
  //text("color threshold: " + threshold, width-10, 50);  
  //text("distance threshold: " + distThreshold, width-10, 25);
}

float distSq(float x1, float y1, float x2, float y2) {
  float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1);
  return d;
}

float distSq(float x1, float y1, float z1, float x2, float y2, float z2) {
  float d = (x2 - x1) * (x2 - x1) + (y2 - y1) * (y2 - y1) + (z2 - z1) * (z2 - z1);
  return d;
}


void keyPressed() {
  if (key == 'x') {
    background(230);
  }
  if (key == 's') {
    saveFrame( "sense/savedimages/action-######.tiff");
  }
  if (key == 'a') {
    distThreshold++;
  } else if (key == 'z') {
    distThreshold--;
  }
  //println(distThreshold);
}
