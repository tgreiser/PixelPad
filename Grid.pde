class Grid {
  int rows = 10;
  int cols = 10;
  
  Pixel[] gpixels;
  boolean isAlternating = true;
  
  void init() {
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

class SimGrid extends Grid {
  float w = 600;
  float h = 600;
  float offsetX = 0;
  float offsetY = 0;
  float spacing = 4;
  
  void init() {
    super.init();
  }
  
  void draw() {
    float sw = w / rows;
    float sh = h / cols;
    
    stroke(255);
    int iP = 0;
    for (int iC = 0; iC < cols; iC++) {
      for (int iR = 0; iR < rows; iR++) {
        gpixels[iP].draw();
        float x1 = sw * iC;
        float x2 = x1 + sw;
        float y1 = sh * iR;
        float y2 = y1 + sh;
        
        rect(x1, y1, x2, y2);
      }
    } 
  }
}
