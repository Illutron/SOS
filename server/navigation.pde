float[] getCurrentWaypoint() {

  if (waypoints.size() > currentWaypoint) {
    return waypoints.get(currentWaypoint);
  } 
  else {
    return null;
  }
}


float distanceToGoal() {
  if (curLocation != null && getCurrentWaypoint() != null) {
    Location goal = new Location(curLocation);
   
    goal.setLatitude(getCurrentWaypoint()[0]);
    goal.setLongitude(getCurrentWaypoint()[1]);

    float d = curLocation.distanceTo(goal);

    return d;
  }
  return 0;
}

float rotationToGoal() {
  if (curLocation != null && getCurrentWaypoint() != null) {

    Location goal = new Location(curLocation);
    goal.setLatitude(getCurrentWaypoint()[0]);
    goal.setLongitude(getCurrentWaypoint()[1]);

    float bearing = curLocation.bearingTo(goal);

    float curDir = direction/TWO_PI*360;
    float ret =  curDir+bearing;
    while (ret > 180)
      ret -= 360;
    while (ret < -180)
      ret += 360;
    return ret;
  }
  return 0;
}

void autopilot() {
  left = 0;
  right = 0;


  if (distanceToGoal() > 2) {
    float dir = -rotationToGoal();


    if (abs(dir) < 20) {
      leftRev = false;
      rightRev = false;

      float d = 1-abs(dir)/20.0;
      if (dir < 0) {
        left = 255;
        right = (int)(255*d);
      } 
      else {
        right = 255;
        left = (int)(255*d);
      }
    } 
    else if (abs(dir) < 30) {
      leftRev = false;
      rightRev = false;


      if (dir < 0) {
        left = 255;
        right = 0;
      } 
      else {
        right = 255;
        left = 0;
      }
    }
    else {
      left = 255;
      right = 255;
      if (dir < 0) {
        leftRev = false;
        rightRev = true;
      } 
      else {
        leftRev = true;
        rightRev = false;
      }
    }
  }
}

