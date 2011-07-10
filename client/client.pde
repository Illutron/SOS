String[] fontList;
PFont androidFont;

int left=0;
int right=0;
boolean leftRev=false;
boolean rightRev=false;

boolean fwdbkwOn = false;
int mode = 0;

float serverLat;
float serverLon;
float serverGoalLat;
float serverGoalLon;
float serverCompas;
float serverBearing;
float serverGoalDistance;

boolean settingGoal = false;

float latSaved = -1;
float lonSaved = -1;
float latDiff = -1;
float lonDiff = -1;

float mapCenterLat;
float mapCenterLon;
int mapZoom = 16;

PImage mapImg;

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
    if (mode == 0) {
      left = 0;
    } 
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(serverGoalLat, serverGoalLon, mapCenterLat, mapCenterLon, mapZoom);
        goalP[0] += 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLat, mapCenterLon, mapZoom);

        serverGoalLat = goalP2[0]; 
        serverGoalLon = goalP2[1];
      }
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT) {
    if (mode == 0) {
      right = 0;
    }  
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(serverGoalLat, serverGoalLon, mapCenterLat, mapCenterLon, mapZoom);
        goalP[0] -= 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLat, mapCenterLon, mapZoom);

        serverGoalLat = goalP2[0]; 
        serverGoalLon = goalP2[1];
      }
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_UP) {
    if (mode == 0) {
    }  
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(serverGoalLat, serverGoalLon, mapCenterLat, mapCenterLon, mapZoom);
        goalP[1] += 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLat, mapCenterLon, mapZoom);

        serverGoalLat = goalP2[0]; 
        serverGoalLon = goalP2[1];
      }
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_DOWN) {
    if (mode == 0) {
    }  
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(serverGoalLat, serverGoalLon, mapCenterLat, mapCenterLon, mapZoom);
        goalP[1] -= 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLat, mapCenterLon, mapZoom);

        serverGoalLat = goalP2[0]; 
        serverGoalLon = goalP2[1];
      }
    }
  }
  if (keyCode == 102) { //LEFT
    if (mode == 0) {
      if (!fwdbkwOn) {
        leftRev = true;
        rightRev = false;
        left = 255;
        right = 255;
      }
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

  if (keyCode == 108) {
    String strSend = "goalSet:";
    strSend += currentLatitude+";"; 
    strSend += currentLongitude;
    strSend = strSend.replace(".", "*");
    talk.SendToAllFriends(strSend);
    /* latSaved = currentLatitude;
     lonSaved = currentLongitude; */
  }
  /* if (keyCode == 82) {
   String strSend = "goalSet:";
   strSend += serverLat+";"; 
   strSend += serverLon;
   strSend = strSend.replace(".", "*");
   talk.SendToAllFriends(strSend);
   }*/
  if (keyCode == 82) {
    mapImg =  loadImage("http://maps.google.com/maps/api/staticmap?center="+serverLat+","+serverLon+"&zoom=+"+mapZoom+"&size=350x480&sensor=false", "jpg");
    mapCenterLat = serverLat;
    mapCenterLon = serverLon;
  }

  if (keyCode == 109) {
    if (mode == 0)
      mode = 1;
    else 
      mode = 0;

    String strSend = "modeSet:";
    strSend += mode; 
    talk.SendToAllFriends(strSend);
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
    if (mode == 0) {
      if (fwdbkwOn) {
        left = 255;
      }
    } 
    else {
            settingGoal = false;
      String strSend = "goalSet:";
      strSend += serverGoalLat+";"; 
      strSend += serverGoalLon;
      strSend = strSend.replace(".", "*");
      talk.SendToAllFriends(strSend);
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_RIGHT) {
    if (mode == 0) {
      if (fwdbkwOn) {
        right = 255;
      }
    } 
    else {
      settingGoal = false;
      String strSend = "goalSet:";
      strSend += serverGoalLat+";"; 
      strSend += serverGoalLon;
      strSend = strSend.replace(".", "*");
      talk.SendToAllFriends(strSend);
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_UP || keyCode == KeyEvent.KEYCODE_DPAD_DOWN) {
    if (mode == 0) {
    } 
    else {
            settingGoal = false;
      String strSend = "goalSet:";
      strSend += serverGoalLat+";"; 
      strSend += serverGoalLon;
      strSend = strSend.replace(".", "*");
      talk.SendToAllFriends(strSend);
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
  if (latSaved != -1) {
    latDiff = latSaved - currentLatitude;
    lonDiff  = lonSaved - currentLongitude;
  }


  updateOsc();

  background(0);
  fill(255);
  if (mapImg != null) {
    pushMatrix();
    translate(screenWidth-350, 0);
    image(mapImg, 0, 0, 350, 480);
    float[] centP = LLToXY(serverLat, serverLon, mapCenterLat, mapCenterLon, mapZoom);
    float[] weP = LLToXY(currentLatitude, currentLongitude, mapCenterLat, mapCenterLon, mapZoom);
    float[] goalP = LLToXY(serverGoalLat, serverGoalLon, mapCenterLat, mapCenterLon, mapZoom);
    fill(255, 0, 0);
    translate(0.5*350, 0.5*480);

    //ellipse(centP[0], centP[1], 30, 30);
    fill(0, 255, 0);
    ellipse(-weP[0], -weP[1], 30, 30);
    fill(0, 0, 255);
    ellipse(-goalP[0], -goalP[1], 30, 30);

    fill(255, 0, 0);
    pushMatrix();
    translate(-centP[0], -centP[1]);
    scale(0.3);
    rotate(-serverCompas/360.0*TWO_PI);
    beginShape();
    vertex(0, -50);
    vertex(-20, 60);
    vertex(0, 50);
    vertex(20, 60);
    endShape(CLOSE);
    popMatrix();

    popMatrix();
  }
  // Display current GPS data
  fill(255);
  text("Latitude: "+currentLatitude + " ("+latDiff+")", 20, 40);
  text("Longitude: "+currentLongitude+ " ("+lonDiff+")", 20, 75);
  text("Accuracy: "+currentAccuracy, 20, 110);
  text("Mode: "+mode, 20, 145);
  text("Distance: "+serverGoalDistance, 20, 180);
  fill(70, 100, 100);

  pushMatrix();
  translate(-200, 100);
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

  fill(255);
  pushMatrix();
  translate(width/2, height/2);
  scale(1);
  rotate(serverCompas/360.0*TWO_PI);
  beginShape();
  vertex(0, -50);
  vertex(-20, 60);
  vertex(0, 50);
  vertex(20, 60);
  endShape(CLOSE);
  popMatrix();

  if (serverBearing != 0) {
    fill(255, 0, 0);
    pushMatrix();
    translate(width/2, height/2);
    scale(1);
    rotate(serverBearing/360.0*TWO_PI);
    beginShape();
    vertex(0, -50);
    vertex(-20, 60);
    vertex(0, 50);
    vertex(20, 60);
    endShape(CLOSE);
    popMatrix();
  }

  popMatrix();
}

