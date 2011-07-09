import oscP5.*;
//import netP5.*;

OscP5 oscP5;
NetAddress myRemoteLocation;

void setupOsc() {
  oscP5 = new OscP5(this, 12000);
  //Connect server
  myRemoteLocation = new NetAddress("172.20.10.4", 12000);
}


void updateOsc() {
  OscMessage myMessage = new OscMessage("/ufo/motorSet");  
  myMessage.add(100);
  myMessage.add(120);
  myMessage.add(1);
  myMessage.add(0);
  oscP5.send(myMessage, myRemoteLocation);
}

void oscEvent(OscMessage theOscMessage) {
}

