import org.openkinect.processing.*;


//Kinect Library Object
Kinect2 kinect2;


float minThresh = 480;
float maxThresh = 830;
PImage img;

float dist = 80;

color trackColor;
float threshold = 20;
float distThreshold = 20;


ArrayList < Blob > blobs = new ArrayList < Blob > ();


void setup() {
  size(600, 400);

  //Kinect Setup
  kinect2 = new Kinect2(this);
  kinect2.initDepth();
  kinect2.initDevice();
  img = createImage(kinect2.depthWidth, kinect2.depthHeight, RGB);


  randomSeed(0);
  background(255);
  stroke(255);
  strokeWeight(.1);
  noFill();

  trackColor = color(255, 0, 0);

}
void draw() {
  background(225,225,225);

  img.loadPixels();

  //img.pixels[kinect2.depthWidth * 50 + 50] = color(255,0,0);
  //img.updatePixels();
  //image(img,0,0);
  //if (true) return;

  //clear();

  int[] depth = kinect2.getRawDepth();



  for (int x = 0; x < kinect2.depthWidth; x+=1) {
    for (int y = 0; y < kinect2.depthHeight; y+=1) {
      int offset = x + y * kinect2.depthWidth;
      int d = depth[offset];

      if (d > minThresh && d < maxThresh && x > 100) {
        img.pixels[offset] = color(255, 0, 0);
        
        boolean found = false;
        for (Blob b : blobs) {
          if (b.isNear(x, y)) {
            b.add(x, y);
            found = true;
            break;
          }
        }

        if (!found) {
          Blob b = new Blob(x, y);
          blobs.add(b);
        }

      } else {
        img.pixels[offset] = color(0);
      }
    }
  }

  img.updatePixels();
  image(img, 0, 0);
  
  for (Blob b: blobs) {
    println(b.size());
    if (b.size() > 100) {
      b.show();
      //b.lines();
    }
  }
  
   textAlign(RIGHT);
  fill(0);
  text("blob count: " + blobs.size(), width-10, 25);
  //text("color threshold: " + threshold, width-10, 50);
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
  //if (key == 'x') {
  //  background(255);
  //  lineHistory.clear();
  //}
  //if (key == 's') {
  //  saveFrame( "sense/savedimages/action-######.tiff");
  //}
  if (key == 'a') {
    distThreshold++;
  } else if (key == 'z') {
    distThreshold--;
  }
  println(distThreshold);
}
