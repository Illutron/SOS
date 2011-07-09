CompassManager compass;
float direction;

void setupCom() {
  compass = new CompassManager(this);
}


void directionEvent(float newDirection) {
  direction = newDirection;
}
