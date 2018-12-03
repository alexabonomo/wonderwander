import org.openkinect.processing.*;
import org.openkinect.freenect.*;
import org.openkinect.freenect2.*;

int blobCounter = 0;

float minThresh = 800;
float maxThresh = 1300;
PImage img;
PGraphics prism;
PGraphics pyramid;

float dist = 80;
int maxLife = 50;

float threshold = 40;
float distThreshold = 50;
int frame = 0;


ArrayList <Blob> blobs = new ArrayList <Blob> ();

int num = 30, frames = 90;
float theta;



void setup() {
  size(1920, 1080, P2D);
  smooth();

  //Kinect Setup
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();

  
  
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  
  
  prism = createGraphics(1920, 1080);
  pyramid = createGraphics(1920, 1080);

  randomSeed(0);
  background(230);
  frameRate(15);
  colorMode(RGB);
  strokeWeight(1);
  noFill();
}
void draw() {
  frame ++;
  background(225,225,225);

  img.loadPixels();

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

  int[] depth = kinect2.getRawDepth();
  
  
  

  for (int x = 0; x < kinect2.depthWidth; x+=1) {
    for (int y = 0; y < kinect2.depthHeight; y+=1) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      

      if (d > minThresh && d < maxThresh && x > 100) {
        img.pixels[offset] = color(100);
        
        float newx = map(x, 0, 512, -100, 1920);
        float newy =map(y, 0, 424, -100, 1080);

        
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
          //depth[offset] = b.id;
        }
      } else {
        img.pixels[offset] = color(255);
        depth[offset] = -1;
      }
    }
  }
  
  

  img.updatePixels();
  //image(img, -100, -100, 1920, 1080);
   
 
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
      matched.taken = true;
      b.become(matched);
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
  pyramid.beginDraw();
  pyramid.clear();
  for (Blob b : blobs) {
    b.show(prism, pyramid); //, depth, kinect2.depthWidth
    
  }
  if (frame % 5 == 0) {
    prism.fill(230, 50);
    prism.rect(0,0,1920,1080);
    prism.loadPixels();
    for (int i=0; i < prism.pixels.length; i++) {
      float r = red(prism.pixels[i]);
      float g = green(prism.pixels[i]);
      float b = blue(prism.pixels[i]);
      float a = alpha(prism.pixels[i]);
      a = constrain(a-1,0,255);
      prism.pixels[i] = color(r,g,b,a);      
    }
    prism.updatePixels();
  }
  prism.endDraw();  
  pyramid.endDraw();
  
 
  //image(pyramid, 0,0);

  image(prism, 0, 0);
  image(pyramid, 0,0);
  

 
    
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
