import android.util.Log;

boolean leftRev = false;
boolean rightRev = true;

void setup()
{	
  orientation(PORTRAIT);	
  frameRate(30);

  setupArduino();
}

void draw() 
{
  updateArduino();

  background(200);

  if (mousePressed)
  {
    fill(0, 255, 0);
    ellipse(mouseX, height/2, 100, 100);
  }
  else
  {
    fill(255, 0, 0);
    //  ellipse(width/2, height/2, sensorValue, sensorValue);
  }
}

