String[] fontList;
PFont androidFont;

int left=0;
int right=0;
boolean leftRev=false;
boolean rightRev=false;

boolean fwdbkwOn = false;
int mode = 0;

String sendThis = null;


float serverLat;
float serverLon;
float goalLat;
float goalLon;
float serverCompas;
float serverBearing;
float serverGoalDistance;
int serverSelectedWaypoint = 0;

boolean settingGoal = false;

float latSaved = -1;
float lonSaved = -1;
float latDiff = -1;
float lonDiff = -1;

float mapCenterLat;
float mapCenterLon;
int mapZoom = 16;

PImage mapImg;

ArrayList<float[]> waypoints;

void setup() {

  ToneGenerator tone = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
  tone.startTone(ToneGenerator.TONE_CDMA_EMERGENCY_RINGBACK, 2000);


  frameRate(20);

  waypoints = new ArrayList<float[]>();
  size(screenWidth, screenHeight);
  background(0);
  fontList = PFont.list();
  androidFont = createFont(fontList[5], 35, true);
  textFont(androidFont);

  setupOsc();
}

boolean onKeyDown(int keyCode, KeyEvent event) {
  if (keyCode == 23) {//X
    if (mode == 0) {
      left = 255;
      right = 255;
      leftRev = false;
      rightRev = false;
      fwdbkwOn = true;
    }  
    else {

      String strSend = "goalAdd:";
      strSend += goalLat+";"; 
      strSend += goalLon;
      strSend = strSend.replace(".", "*");
      sendThis = strSend;
      println("Add waypoint "+strSend);
    }
  }
  if (keyCode == 99) {//square
    if (mode == 0) {
      left = 255;
      right = 255;
      leftRev = true;
      rightRev = true;
      fwdbkwOn = true;
    } 
    else {
      String strSend = "goalRestart:";
      sendThis = strSend;
      // talk.SendToAllFriends(strSend);
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_LEFT) {
    if (mode == 0) {
      left = 0;
    } 
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(goalLon, goalLat, mapCenterLon, mapCenterLat, mapZoom);
        goalP[0] -= 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLon, mapCenterLat, mapZoom);

        goalLat = goalP2[1]; 
        goalLon = goalP2[0];
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
        float[] goalP = LLToXY(goalLon, goalLat, mapCenterLon, mapCenterLat, mapZoom);
        goalP[0] += 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLon, mapCenterLat, mapZoom);

        goalLat = goalP2[1]; 
        goalLon = goalP2[0];
      }
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_UP) {
    if (mode == 0) {
    }  
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(goalLon, goalLat, mapCenterLon, mapCenterLat, mapZoom);
        goalP[1] -= 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLon, mapCenterLat, mapZoom);

        goalLat = goalP2[1]; 
        goalLon = goalP2[0];
      }
    }
  }
  if (keyCode == KeyEvent.KEYCODE_DPAD_DOWN) {
    if (mode == 0) {
    }  
    else {
      settingGoal = true;
      if (mapImg != null) {
        float[] goalP = LLToXY(goalLon, goalLat, mapCenterLon, mapCenterLat, mapZoom);
        goalP[1] += 5;
        float[] goalP2 = XYToLL((int)goalP[0], (int)goalP[1], mapCenterLon, mapCenterLat, mapZoom);

        goalLat = goalP2[1]; 
        goalLon = goalP2[0];
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

  if (keyCode == 100) {//triange
    if (mode == 1) {
      String strSend = "goalClear:";
      sendThis= strSend;
      //      talk.SendToAllFriends(strSend);
    }
  }
  if (keyCode == 108) { //Start
  /*
    String strSend = "goalSet:";
    strSend += currentLatitude+";"; 
    strSend += currentLongitude;
    strSend = strSend.replace(".", "*");
    talk.SendToAllFriends(strSend);*/
    goalLat = 55.647434;
    goalLon = 12.555727;
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
    mapImg =  loadImage("http://maps.google.com/maps/api/staticmap?center="+serverLat+","+serverLon+"&zoom=+"+mapZoom+"&size=350x480&sensor=false&maptype=satellite", "jpg");
    mapCenterLat = serverLat;
    mapCenterLon = serverLon;
    goalLat = serverLat;
    goalLon = serverLon;
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
      strSend += goalLat+";"; 
      strSend += goalLon;
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
      strSend += goalLat+";"; 
      strSend += goalLon;
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
      strSend += goalLat+";"; 
      strSend += goalLon;
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
  if (sendThis != null) {
    talk.SendToAllFriends(sendThis);
    sendThis = null;
  }

  if (latSaved != -1) {
    latDiff = latSaved - currentLatitude;
    lonDiff  = lonSaved - currentLongitude;
  }


  updateOsc();

  background(0);
  fill(255);
  if (mapImg != null) {
    ellipseMode(CENTER);

    pushMatrix();
    translate(screenWidth-350, 0);
    image(mapImg, 0, 0, 350, 480);
    float[] centP = LLToXY(serverLon, serverLat, mapCenterLon, mapCenterLat, mapZoom);
    float[] weP = LLToXY(currentLongitude, currentLatitude, mapCenterLon, mapCenterLat, mapZoom);
    float[] goalP = LLToXY(goalLon, goalLat, mapCenterLon, mapCenterLat, mapZoom);
    fill(255, 0, 0);
    translate(0.5*350, 0.5*480);

    //ellipse(centP[0], centP[1], 30, 30);
    fill(0, 255, 0);
    ellipse(weP[0], weP[1], 30, 30);

    fill(100, 100, 255);
    for (int i=0;i<waypoints.size();i++) {
      float[] p = LLToXY(waypoints.get(i)[1], waypoints.get(i)[0], mapCenterLon, mapCenterLat, mapZoom);
      ellipse(p[0], p[1], 30, 30);
    }

    fill(0, 0, 255);
    ellipse(goalP[0], goalP[1], 30, 30);

    fill(255, 0, 0);
    pushMatrix();
    translate(centP[0], centP[1]);
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
  rotate(-serverCompas/360.0*TWO_PI);
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

