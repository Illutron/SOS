import oscP5.*;
//import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOsc() {
  oscP5 = new OscP5(this, 12000);
  myRemoteLocation = new NetAddress("127.0.0.1", 12000);
}

void updateOsc() {
 
}

void oscEvent(OscMessage theOscMessage) {
  left = 100;
  if (theOscMessage.checkAddrPattern("/ufo/motorSet")) {
    left = theOscMessage.get(0).intValue();
    right = theOscMessage.get(1).intValue();
    leftRev = (theOscMessage.get(2).intValue() > 0)?true:false;
    rightRev = (theOscMessage.get(3).intValue() > 0)?true:false;
  }
}

