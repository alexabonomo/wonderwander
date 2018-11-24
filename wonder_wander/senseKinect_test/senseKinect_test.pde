import org.openkinect.processing.*;


//Kinect Library Object
Kinect2 kinect2;

int blobCounter = 0;

int canvasWidth;
int canvasHeight;
float minThresh = 480;
float maxThresh = 830;
PImage img;

float dist = 80;
int maxLife = 50;

color trackColor;
float threshold = 40;
float distThreshold = 50;


ArrayList <Blob> blobs = new ArrayList <Blob> ();


void setup() {
  size(1920, 1080);

  //Kinect Setup
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  
  
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);
  

  randomSeed(0);
  colorMode(HSB);
  strokeWeight(.1);
  noFill();


}
void draw() {
  //background(225,225,225);

  img.loadPixels();

  ArrayList<Blob> currentBlobs = new ArrayList<Blob>();

  int[] depth = kinect2.getRawDepth();
  

  for (int x = 0; x < kinect2.depthWidth; x+=1) {
    for (int y = 0; y < kinect2.depthHeight; y+=1) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];
      

      if (d > minThresh && d < maxThresh && x > 100) {
        img.pixels[offset] = color(100);
        
        boolean found = false;
        for (Blob b : currentBlobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          currentBlobs.add(b);
        }

      } else {
        img.pixels[offset] = color(255);
      }
    }
  }
  
  

  img.updatePixels();
  //image(img, 0, 0);
  //println(kinect2.depthWidth, kinect2.depthHeight);
  
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

  for (Blob b : blobs) {
    b.show();
   
  } 
    
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
    background(255);
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
