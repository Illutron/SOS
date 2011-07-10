import android.util.Log;
import android.location.Location;

boolean leftRev = false;
boolean rightRev = false;
int left=0;
int right=0;

float latGoal = -1;
float lonGoal = -1;

int mode = 0; //0 motor mode ; 1 goal mode

int mouseGuiElement = -1;
boolean mouseDown = false;

String[] fontList;
PFont androidFont;

float latDiff = 0;
float lonDiff = 0;

void setup()
{	


  orientation(PORTRAIT);	
  frameRate(30);

  setupArduino();
  setupOsc();
  setupCom();

  fontList = PFont.list();
  androidFont = createFont(fontList[5], 35, true);
  textFont(androidFont);
}

void onResume() {
  // Compass
  if (compass != null) compass.resume();
  // Build Listener
  locationListener = new MyLocationListener();
  // Acquire a reference to the system Location Manager
  locationManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
  // Register the listener with the Location Manager to receive location updates
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);

  super.onResume();
}

void onPause() {
  if (compass != null) compass.pause();
  super.onPause();
}

void draw() 
{
  
  
  updateOsc();
  if (mousePressed) {
    if (!mouseDown) {
      mouseGuiElement = -1;
      mouseDown = true;

      if (mouseY < 80) {
        mouseGuiElement = 1;
      } 
      else if (mouseY < 165) {
        mouseGuiElement = 2;
      } 
      else if (mouseY < 270) {
        if (mouseX < screenWidth/2)
          leftRev = !leftRev;
        else 
          rightRev = !rightRev;
      }
    } 
    else if (mouseGuiElement != -1) {
      if (mouseGuiElement == 1) {
        left = (int)((((float)mouseX)/((float)width))*255);
      } 
      else if (mouseGuiElement == 2) {
        right = (int)((((float)mouseX)/((float)width))*255);
      }
    }
  } 
  else {
    mouseDown = false;
  }


  if (mode == 1) {
    autopilot();
  }

  updateArduino();

  background(0);

  //Left motor gui
  if (leftRev) 
    fill(100, 0, 0);
  else
    fill(0, 100, 0);

  float w = screenWidth-10;
  rect(5, 5, w*left/255.0, 80);

  fill(255, 255, 255);
  text("Left motor: "+left+(leftRev?" Rev":""), 10, 65);

  //Right motor gui
  if (rightRev)
    fill(100, 0, 0);
  else 
    fill(0, 100, 0);

  rect(5, 85, w*right/255.0, 80);
  fill(255, 255, 255);
  text("Right motor: "+right+(rightRev?" Rev":""), 10, 65+80);


  //Reverse gui
  translate(0, 80+80+10);
  fill(0, 0, 120);
  rect(5, 0, (screenWidth-10)/2.0, 100);
  rect((screenWidth-10)/2.0, 0, (screenWidth-10)/2.0, 100);


  fill(255);
  text("Latitude: "+currentLatitude, 20, 40+300);
  text("Longitude: "+currentLongitude, 20, 75+300);
  text("Accuracy: "+currentAccuracy, 20, 110+300);
  text("G Latitude: "+latGoal, 20, 145+300);
  text("G Longitude: "+lonGoal, 20, 180+300);


  if (curLocation != null) {
    Location goal = new Location(curLocation);
    goal.setLatitude(latGoal+latDiff);
    goal.setLongitude(lonGoal+lonDiff);

    float distance = goal.distanceTo(curLocation);
    float bearing = curLocation.bearingTo(goal);

    text("G Distance: "+distance, 20, 205+300);
    text("G Bearing: "+rotationToGoal(), 20, 240+300);
  }
  text("Bearing: "+direction/TWO_PI*360, 20, 275+300);
  text("Mode: "+mode, 20, 310+300);

  pushMatrix();
  translate(width/2, 230);
  scale(1);
  rotate(direction);
  beginShape();
  vertex(0, -50);
  vertex(-20, 60);
  vertex(0, 50);
  vertex(20, 60);
  endShape(CLOSE);
  popMatrix();

  if (rotationToGoal() != 0){
    fill(255, 0, 0);
  pushMatrix();
  translate(width/2, 230);
  scale(1);
  rotate(rotationToGoal()/360.0*TWO_PI);
  beginShape();
  vertex(0, -50);
  vertex(-20, 60);
  vertex(0, 50);
  vertex(20, 60);
  endShape(CLOSE);
  popMatrix();
  }
}

