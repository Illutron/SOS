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

    strSend = strSend.replace(".", "*");
    println("Send"+strSend);
    talk.SendToAllFriends(strSend);
  }
}

void parseChat(String msg) {
   msg = msg.replace("*",".");
      
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

  if (msg.startsWith("goalSet:")) {

    String pin = msg.replaceAll("goalSet:", ""); // get 'pin)'
    // pin = pin.substring(0, pin.indexOf(")"));  // strip the last )
    String arr[] = pin.split(";");

    latGoal = Float.parseFloat(arr[0]);
    lonGoal = Float.parseFloat(arr[1]);
  }

  if (msg.startsWith("modeSet:")) {
    String pin = msg.replaceAll("modeSet:", ""); // get 'pin)'
    mode = Integer.parseInt(pin);
  }
}

