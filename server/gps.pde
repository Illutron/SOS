// Imports
import android.content.Context;
import android.location.Location;
import android.location.LocationManager;
import android.location.LocationListener;
import android.location.GpsStatus.Listener;
import android.location.GpsStatus.NmeaListener; // not needed yet, but going for nmea data next!
import android.os.Bundle;

LocationManager locationManager;
MyLocationListener locationListener;

// Variables to hold the current GPS data
float currentLatitude  = 0;
float currentLongitude = 0;
float currentAccuracy  = 0;
String currentProvider = "";
Location curLocation;

//-----------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------



//-----------------------------------------------------------------------------------------

// Define a listener that responds to location updates
class MyLocationListener implements LocationListener {
  void onLocationChanged(Location location) {
    // Called when a new location is found by the network location provider.
    currentLatitude  = (float)location.getLatitude();
    currentLongitude = (float)location.getLongitude();
    currentAccuracy  = (float)location.getAccuracy();
    currentProvider  = location.getProvider();
    curLocation = new Location(location);

    Set<String> extras = location.getExtras().keySet();
    for (int i=0;i<extras.size();i++) {
      println((extras.toArray()[i])+"  "+i);
    }
  }
  void onProviderDisabled (String provider) { 
    currentProvider = "";
  }

  void onProviderEnabled (String provider) { 
    currentProvider = provider;
  }

  void onStatusChanged (String provider, int status, Bundle extras) {
    // Nothing yet...
  }
}

