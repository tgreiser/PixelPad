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
  
  float sw;
  float sh;
  
  void init() {
    super.init();
    
    sw = w / rows;
    sh = h / cols;
  }
  
  void draw() {
    stroke(255);
    int iP = 0;
    for (int iR = 0; iR < rows; iR++) {
      for (int iC = 0; iC < cols; iC++) {
      
        gpixels[iP++].draw();
        float x1 = sw * iC;
        float x2 = x1 + sw;
        float y1 = sh * iR;
        float y2 = y1 + sh;
        
        rect(x1, y1, x2, y2);
      }
    }
  }
  
  // calculate the grid # and set the pixel to red, or back to black
  void mouseReleased() {
    int iR = mouseX / int(sw);
    int iC = mouseY / int(sh);
    int iP = (iC * 10) + iR;
    println("Got " + str(iC) + " x " + str(iR) + " - " + str(iP));
    
    if (gpixels[iP].rgb == color(0, 0, 0)) {
      println("Set red");
      gpixels[iP].set(color(255, 0, 0));
      println(gpixels[iP].rgb);
    } else {
      println("Set black");
      gpixels[iP].clear();
      println(gpixels[iP].rgb);
    }
  }
}
