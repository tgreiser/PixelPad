class EditorController extends SimGridController {
  Button save;
  Button load;
  Button newseq;
  
  Sequence sequence;

  void setup(PApplet _app) {
    super.setup(_app);
    
    save = c5.addButton("Save")
      .setPosition(550, 605)
      .setColorBackground(color(0))
      .setSize(57, 19);
      
    load = c5.addButton("Load")
      .setPosition(550, 635)
      .setColorBackground(color(0))
      .setSize(57, 19);
      
    newseq = c5.addButton("New")
      .setPosition(550, 665)
      .setColorBackground(color(0))
      .setSize(57, 19);
      
    sequence = new Sequence();
    sequence.init();
  }
  
  void hide() {
    save.setVisible(false);
    load.setVisible(false);
    newseq.setVisible(false);
  }
  
  void show() {
    save.setVisible(true);
    load.setVisible(true);
    newseq.setVisible(true);
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
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(save)) {
      save();
    } else if (theEvent.isFrom(load)) {
      selectInput("What sequence would you like to load?", "loadCallback", new File(sketchPath+"/data/000.seq"));
    } else if (theEvent.isFrom(newseq)) {
      sequence = new Sequence();
      sequence.init();
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
