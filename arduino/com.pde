
// Adb connection.
Connection * connection;

// Elapsed time for ADC sampling
long lastTime;
boolean r = true;
// Event handler for the shell connection. 
void adbEventHandler(Connection * connection, adb_eventType event, uint16_t length, uint8_t * data)
{
  int i;

  // Data packets contain two bytes, one for each servo, in the range of [0..180]
  if (event == ADB_CONNECTION_RECEIVE)
  {
    r = !r;
  //  analogWrite(3,data[0]);
//    Serial.println("sd");
    comReceive(data);
  }
}

void comSetup(){
  ADB::init(); 
  connection = ADB::addConnection("tcp:4567", true, adbEventHandler);  
}

void comUpdate(){
    ADB::poll();
}

