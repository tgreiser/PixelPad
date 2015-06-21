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
  int max_seq = 64;
  Sequence[] sequences;
    
  void setup(PApplet _app) {
    super.setup(_app);
    
    sequences = new Sequence[max_seq];
    for (int iX = 0; iX < max_seq; iX++) {
      sequences[iX] = new Sequence();
    }
    
    sw = w / rows;
    sh = h / cols;
  }
  
  void draw() {
    stroke(255);
    int iP = 0;
    for (int iR = 0; iR < rows; iR++) {
      for (int iC = 0; iC < cols; iC++) {
        //gpixels[iP].clear();
        
        //if (sequence.stepHas(iP)) {
        //  gpixels[iP].set(color(255, 0, 0));
        //}
        
        //gpixels[iP++].draw();
        fill(0);
        float x1 = sw * iC;
        float y1 = sh * iR;
        
        rect(x1, y1, sw, sh);
      }
    } 
  }
}
