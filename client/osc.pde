XMPPMachine talk;


int leftSend = -1;
int rightSend = -1;
boolean leftRevSend = false;
boolean rightRevSend = false;


void setupOsc() {
    talk = new XMPPMachine("chrliljebeta", "oiuOIU987)(/");
  talk.openconnection();

}


void updateOsc() {
  if (leftSend != left || rightSend != right || leftRevSend != leftRev || rightRevSend != rightRev) {
//    SendToAllFriends
String strSend = "motorSet:";
strSend += left+","; 
strSend += right+",";
strSend += leftRev?10:0+",";
strSend += rightRev?10:0;
  
    leftSend = left;
    rightSend = right;
    leftRevSend = leftRev;
    rightRevSend = rightRev;
  }
}

void oscEvent(OscMessage theOscMessage) {
  
}

