import java.io.IOException;

private Server server;

void setupArduino(){
   server = null;
  try
  {
    server = new Server(4567);
    server.start();
  } 
  catch (IOException e)
  {
    println(e.toString());
  } 



 /*
  this.server.addListener(new AbstractServerListener() {

    @Override
      public void onReceive(Client client, byte[] data)
    {

      if (data.length<2) return;

      sensorValue = (data[0] & 0xff) | ((data[1] & 0xff) << 8);
    };
  }
  );*/
}

void updateArduino(){
  try
    {
      server.send(new byte[] {
       (byte) ((((float)mouseX)/((float)width))*255.0f)
       ,(byte) ((((float)mouseY)/((float)height))*255.0f)
       ,(byte) (leftRev?100:0)
       ,(byte) (rightRev?100:0)
      }
      ); 
    } 
    catch (IOException e)
    {
      println("microbridgeproblem sending TCP message");
    }
}
