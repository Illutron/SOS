XMPPMachine talk;

int lastMsg = 0;

void setupOsc() {
  //  oscP5 = new OscP5(this, 12000);
  //myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  talk = new XMPPMachine("chrliljegamma", "oiuOIU987)(/");
  talk.openconnection();
}

void updateOsc() {
  if (millis() > lastMsg + 1000) {

    lastMsg = millis();

    //Send status
    String strSend = "gpsInfo:";
    strSend += currentLatitude+";"; 
    strSend += currentLongitude;

    strSend += "#goalInfo:";
    strSend += latGoal+";"; 
    strSend += lonGoal+";";
    strSend += distanceToGoal();

    strSend += "#modeInfo:";
    strSend += mode; 

    strSend += "#compasInfo:";
    strSend += 360*direction/TWO_PI+";"; 
    strSend += rotationToGoal(); 

    strSend += "#motorInfo:";
    strSend += left+";"; 
    strSend += right+";"; 
    strSend += (leftRev?1:0)+";"; 
    strSend += (rightRev?1:0); 

    strSend += "#waypointInfo:";
    for (int i=0;i<waypoints.size();i++) {
      strSend += waypoints.get(i)[0]+";"+waypoints.get(i)[1]+";";
    }


    strSend += "#waypointSelInfo:";
    strSend += currentWaypoint; 

    strSend = strSend.replace(".", "*");
    println("Send"+strSend);
    talk.SendToAllFriends(strSend);
  }
}

void parseChat(String msg) {
  msg = msg.replace("*", ".");

  println(msg);

  if (msg.startsWith("motorSet:")) {
    println("Set motor:");

    String pin = msg.replaceAll("motorSet:", ""); // get 'pin)'
    // pin = pin.substring(0, pin.indexOf(")"));  // strip the last )
    String arr[] = pin.split(",");

    left = Integer.parseInt(arr[0]);
    right = Integer.parseInt(arr[1]);
    leftRev = (Integer.parseInt(arr[2])>0)?true:false;
    rightRev = (Integer.parseInt(arr[3])>0)?true:false;
  }


  if (msg.startsWith("goalClear:")) {
    waypoints.clear();
  }
  if (msg.startsWith("goalRestart:")) {
    currentWaypoint = 0;
  }

  if (msg.startsWith("goalAdd:")) {
    String pin = msg.replaceAll("goalAdd:", ""); // get 'pin)'
    // pin = pin.substring(0, pin.indexOf(")"));  // strip the last )
    String arr[] = pin.split(";");

    for (int i=0;i<arr.length;i+=2) {
      float[] arr2 = new float[2];
      arr2[0] =(float) Double.parseDouble(arr[i]);
      arr2[1] =(float) Double.parseDouble(arr[i+1]);

      waypoints.add(arr2);
    }

    println("Set lat: "+latGoal+" long:" + lonGoal);
  }
  if (msg.startsWith("goalSet:")) {

    String pin = msg.replaceAll("goalSet:", ""); // get 'pin)'
    // pin = pin.substring(0, pin.indexOf(")"));  // strip the last )
    String arr[] = pin.split(";");

    latGoal =(float) Double.parseDouble(arr[0]);
    lonGoal =(float) Double.parseDouble(arr[1]);

    println("Set lat: "+latGoal+" long:" + lonGoal);
  }

  if (msg.startsWith("modeSet:")) {
    String pin = msg.replaceAll("modeSet:", ""); // get 'pin)'
    mode = Integer.parseInt(pin);
  }

  if (msg.startsWith("diffSet:")) {

    String pin = msg.replaceAll("diffSet:", ""); // get 'pin)'
    // pin = pin.substring(0, pin.indexOf(")"));  // strip the last )
    String arr[] = pin.split(";");

    latDiff = Float.parseFloat(arr[0])/10000.0;
    lonDiff = Float.parseFloat(arr[1])/10000.0;
  }
}

