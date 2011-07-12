float offset=268435456.0;
float radius=offset/PI;

int LToX(float x) {
  return round(offset+radius*x*PI/180.0);
}

int LToY(float y)
{
  return round(offset-radius*log((1+sin(y*PI/180.0))/(1-sin(y*PI/180.0)))/2.0);
}

float XToL(int x)
{
  return ((round(x)-offset)/radius)*180/PI;
}

float YToL(int y)
{
  return (PI/2-2*atan(exp((round(y)-offset)/radius)))*180/PI;
}


float[] Adjust(float X, float Y, float x, float y, int z, boolean w) {
  float[] ret;
  ret = new float[2];
  if (w) {
    ret[0] = (LToX(X)-LToX(x))>>(21-z); 
    ret[1] = (LToY(Y)-LToY(y))>>(21-z);
  }

  else
  {
    ret[0] =  XToL(LToX(x)+(((int)X)<<(21-z)));
    ret[1] =  YToL(LToY(y)+(((int)Y)<<(21-z)));
  }

  return ret;
}



float[] XYToLL(int X, int Y, float x, float y, int z) {
  return Adjust(X, Y, x, y, z, false);
}

//	X = X pixel offset of new map center from old map center
//	Y = Y pixel offset of new map center from old map center
//	x = Longitude of map center
//	y = Latitude  of map center
//	z = Zoom level

//	result.x = Longitude of adjusted map center
//	result.y = Latitude  of adjusted map center

float[] LLToXY(float X, float Y, float x, float y, int z) {
  return Adjust(X, Y, x, y, z, true);
}

//	X = Longitude of marker center
//	Y = Latitude  of marker center
//	x = Longitude of map center
//	y = Latitude  of map center
//	z = Zoom level

//	result.x = X pixel offset of marker center from map center
//	result.y = Y pixel offset of marker center from map center

