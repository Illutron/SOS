String[] fontList;
PFont androidFont;

void setup() {
  size(screenWidth, screenHeight);
  background(0);
  fontList = PFont.list();
  androidFont = createFont(fontList[5], 35, true);
  textFont(androidFont);
}

void draw() {
  background(0);
  // Display current GPS data
  text("Latitude: "+currentLatitude, 20, 40);
  text("Longitude: "+currentLongitude, 20, 75);
  text("Accuracy: "+currentAccuracy, 20, 110);
  text("Provider: "+currentProvider, 20, 145);  
}

//-----------------------------------------------------------------------------------------

void onResume() {
  super.onResume();
  // Build Listener
  locationListener = new MyLocationListener();
  // Acquire a reference to the system Location Manager
  locationManager = (LocationManager)getSystemService(Context.LOCATION_SERVICE);
  // Register the listener with the Location Manager to receive location updates
  locationManager.requestLocationUpdates(LocationManager.GPS_PROVIDER, 0, 0, locationListener);
}

void onPause() {
  super.onPause();
}
