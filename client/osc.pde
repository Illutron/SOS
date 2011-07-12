XMPPMachine talk;
import android.media.ToneGenerator;
import android.media.AudioManager;

int leftSend = -1;
int rightSend = -1;
boolean leftRevSend = false;
boolean rightRevSend = false;
int lastMsg = 0;

void setupOsc() {
  talk = new XMPPMachine("chrliljebeta", "oiuOIU987)(/");
  talk.openconnection();
}


void updateOsc() {
  /* if (millis() > lastMsg + 5000) {
   
   lastMsg = millis();
   String strSend = "diffSet:";
   //    strSend += latDiff*10000+";"; 
   //    strSend += lonDiff*10000;
   strSend += "0"+";"; 
   strSend += "0";
   strSend = strSend.replace(".", "*");
   talk.SendToAllFriends(strSend);
   }  */
  if (leftSend != left || rightSend != right || leftRevSend != leftRev || rightRevSend != rightRev) {
    //    SendToAllFriends
    String strSend = "motorSet:";
    strSend += left+","; 
    strSend += right+",";
    strSend += (leftRev?10:"0")+",";
    strSend += rightRev?10:"0";
    talk.SendToAllFriends(strSend);
    leftSend = left;
    rightSend = right;
    leftRevSend = leftRev;
    rightRevSend = rightRev;
  }
}



void parseChat(String msg) {
  msg = msg.replace("*", ".");

  println(msg);



  if (msg.startsWith("gpsInfo:")) {
    String arr1[] = msg.split("#");

    for (int i=0;i<5;i++) {
    }

    String pin = arr1[0].replaceAll("gpsInfo:", ""); // get 'pin)'
    String arr[] = pin.split(";");

    serverLat = Float.parseFloat(arr[0]);
    serverLon = Float.parseFloat(arr[1]);

    pin = arr1[1].replaceAll("goalInfo:", ""); // get 'pin)'
    arr = pin.split(";");
    serverGoalDistance = Float.parseFloat(arr[2]);

    pin = arr1[2].replaceAll("modeInfo:", ""); // get 'pin)'
    mode = Integer.parseInt(pin);

    pin = arr1[3].replaceAll("compasInfo:", ""); // get 'pin)'
    arr = pin.split(";");

    serverCompas = Float.parseFloat(arr[0]);
    serverBearing = Float.parseFloat(arr[1]);

    if (mode == 1) {
      pin = arr1[4].replaceAll("motorInfo:", ""); // get 'pin)'
      arr = pin.split(";");

      left = Integer.parseInt(arr[0]);
      right = Integer.parseInt(arr[1]);
      leftRev = (Integer.parseInt(arr[2])>0)?true:false;
      rightRev = (Integer.parseInt(arr[3])>0)?true:false;
    }

    pin = arr1[5].replaceAll("waypointInfo:", ""); // get 'pin)'
    arr = pin.split(";");

    waypoints.clear();
    for (int i=0;i<arr.length;i+=2) {
      float[] arr2 = new float[2];
      arr2[0] = Float.parseFloat(arr[i]);
      arr2[1] = Float.parseFloat(arr[i+1]);
      waypoints.add(arr2);
    }

    pin = arr1[6].replaceAll("waypointSelInfo:", ""); // get 'pin)'
    if (serverSelectedWaypoint != Integer.parseInt(pin)) {
      ToneGenerator tone = new ToneGenerator(AudioManager.STREAM_MUSIC, 100);
      tone.startTone(ToneGenerator.TONE_CDMA_EMERGENCY_RINGBACK, 2000);

      serverSelectedWaypoint = Integer.parseInt(pin);
    }
  }
}

