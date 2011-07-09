XMPPMachine talk;


void setupOsc() {
  //  oscP5 = new OscP5(this, 12000);
  //myRemoteLocation = new NetAddress("127.0.0.1", 12000);
  talk = new XMPPMachine("chrliljealpha", "oiuOIU987)(/");
  talk.openconnection();
}

void updateOsc() {
}

void parseChat(String msg) {
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
}



