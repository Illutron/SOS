String[] fontList;
PFont androidFont;

int left=0;
int right=0;
boolean leftRev=false;
boolean rightRev=false;

boolean fwdbkwOn = false;

void setup() {
  frameRate(20);

  
  size(screenWidth, screenHeight);
  background(0);
  fontList = PFont.list();
  androidFont = createFont(fontList[5], 35, true);
  textFont(androidFont);

  setupOsc();
}

boolean onKeyDown(int keyCode, KeyEvent event) {
  if (keyCode == 23) {//X
    left = 255;
    right = 255;
    leftRev = false;
    rightRev = false;
    fwdbkwOn = true;
  }
  if (keyCode == 99) {//square
    left = 255;
    right = 255;
    leftRev = true;
    rightRev = true;
    fwdbkwOn = true;
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_LEFT) {
    left = 0;
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT) {
    right = 0;
  }
  if (keyCode == 102) { //LEFT
    if (!fwdbkwOn) {
      leftRev = true;
      rightRev = false;
      left = 255;
      right = 255;
    }
  }
  if (keyCode == 103) { //RIGHT
    if (!fwdbkwOn) {
      leftRev =false;
      rightRev = true;
      left = 255;
      right = 255;
    }
  }

  return true;
}

boolean onKeyUp(int keyCode, KeyEvent event) {
  if (keyCode == 23) {//X
    left = 0;
    right = 0;
    fwdbkwOn = false;
  }
  if (keyCode == 99) {//square
    left = 0;
    right = 0;
    leftRev = false;
    rightRev = false;
    fwdbkwOn = false;
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_LEFT) {
    if (fwdbkwOn) {
      left = 255;
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT) {
    if (fwdbkwOn) {
      right = 255;
    }
  }
  if (keyCode == 102) {
    left = 0;
    right = 0;
  }
  if (keyCode == 103) {
    left = 0;
    right = 0;
  }
  return true;
}

void draw() {

  updateOsc();

  background(0);
  fill(255);
  // Display current GPS data
  text("Latitude: "+currentLatitude, 20, 40);
  text("Longitude: "+currentLongitude, 20, 75);
  text("Accuracy: "+currentAccuracy, 20, 110);
  text("Provider: "+currentProvider, 20, 145);

  fill(70, 100, 100);
  stroke(255, 255, 255);
  rect(screenWidth/2.0-100, screenHeight/2.0-100, 200, 200); 

  fill(80, 255, 80);
  if (leftRev)
    fill(255, 0, 0);

  arc(screenWidth/2.0-70, screenHeight/2.0+100, 50, 50, 0-HALF_PI, TWO_PI*left/255.0-HALF_PI);


  fill(80, 255, 80);
  if (rightRev)
    fill(255, 0, 0);  
  arc(screenWidth/2.0+70, screenHeight/2.0+100, 50, 50, 0-HALF_PI, TWO_PI*right/255.0-HALF_PI);
}



