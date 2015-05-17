import controlP5.*;

class Grid {
  int rows = 10;
  int cols = 10;
  
  Pixel[] gpixels;
  Sequence sequence;
  boolean isAlternating = true;
  
  void init() {
    gpixels = new Pixel[rows * cols];
    sequence = new Sequence();
    sequence.init();
    
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
  
  float sw;
  float sh;
  
  Button save;
  Button load;
  
  void init() {
    super.init();
    
    sw = w / rows;
    sh = h / cols;
    
    save = c5.addButton("Save")
      .setPosition(5, 605)
      .setColorBackground(color(0))
      .setSize(57, 19);
      
    load = c5.addButton("Load")
      .setPosition(5, 635)
      .setColorBackground(color(0))
      .setSize(57, 19);
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(save)) {
      save();
    } else if (theEvent.isFrom(load)) {
      selectInput("What sequence would you like to load?", "loadCallback", new File(sketchPath+"/data/000.seq"));
    }
  }
  
  void draw() {
    stroke(255);
    int iP = 0;
    for (int iR = 0; iR < rows; iR++) {
      for (int iC = 0; iC < cols; iC++) {
        gpixels[iP].clear();
        
        if (sequence.stepHas(iP)) {
          gpixels[iP].set(color(255, 0, 0));
        }
        
        gpixels[iP++].draw();
        float x1 = sw * iC;
        float y1 = sh * iR;
        
        rect(x1, y1, sw, sh);
      }
    }
    
  }
  
  // calculate the grid # and set the pixel to red, or back to black
  void mouseReleased() {
    int iR = mouseX / int(sw);
    int iC = mouseY / int(sh);
    int iP = (iC * 10) + iR;
    if (iP > gpixels.length - 1) { return; }
    println("Got " + str(iC) + " x " + str(iR) + " - " + str(iP));
    
    if (gpixels[iP].rgb == color(0, 0, 0)) {
      sequence.addPixel(iP);
      println("Set red");
      //gpixels[iP].set(color(255, 0, 0));
      //println(gpixels[iP].rgb);
    } else {
      println("Set black");
      sequence.removePixel(iP);
      //gpixels[iP].clear();
      //println(gpixels[iP].rgb);
    }
  }
  
  void keyPressed() {
    if (key == CODED) {
      if (keyCode == RIGHT) {
        sequence.nextStep();
      } else if (keyCode == LEFT) {
        sequence.prevStep();
      }
    } else if (key == 10) {
      // sequence add step, advance, then clear
      sequence.addStep();
    }
  }
  
  void save() {
    println("Running selectOutput..");
    selectOutput("Where would you like to save your sequence?", "saveCallback", new File(sketchPath+"/data/000.seq"));
  }
  
  void saveCallback(File selection) {
    if (selection == null) { return; }
    String fn = selection.getAbsolutePath();
    println("Saving " + fn);
    
    // Serialize the sequence data
    File file = new File(fn);
    sequence.saveData(file);
  }
  
  void loadCallback(File selected) { 
    if (selected == null) { return; }
    sequence.loadData(selected);
  }
}
