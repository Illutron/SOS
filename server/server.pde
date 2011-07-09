import android.util.Log;

boolean leftRev = false;
boolean rightRev = false;
int left=0;
int right=0;

int mouseGuiElement = -1;
boolean mouseDown = false;

String[] fontList;
PFont androidFont;

void setup()
{	

  setupCom();

  orientation(PORTRAIT);	
  frameRate(30);

  setupArduino();

  fontList = PFont.list();
  androidFont = createFont(fontList[5], 35, true);
  textFont(androidFont);
}

void onResume() {
  super.onResume();
  // Compass
  if (compass != null) compass.resume();
}

void onPause() {
  if (compass != null) compass.pause();
  super.onPause();
}

void draw() 
{
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
}

