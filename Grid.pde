import controlP5.*;

class GridController extends Controller {
  int rows = 10;
  int cols = 10;
  
  Pixel[] gpixels;
  boolean isAlternating = true;
  
  void setup(PApplet _app) {
    super.setup(_app);
    
    gpixels = new Pixel[rows * cols];
    
    int iP = 0;
    for (int iC = 0; iC < cols; iC++) {
      for (int iR = 0; iR < rows; iR++) {
        gpixels[iP++] = new Pixel();
      }
    }
    println("Initialized " + str(iP) + " pixels");
  }
}

class SimGridController extends GridController {
  float w = 600;
  float h = 600;
  float offsetX = 0;
  float offsetY = 0;
  
  float sw;
  float sh;
    
  void setup(PApplet _app) {
    super.setup(_app);
    
    sw = w / rows;
    sh = h / cols;
  }
  
  
}
