import controlP5.*;

class GridController extends Controller {
  int rows = 10;
  int cols = 10;
  int clockDelay = INITIAL_DELAY; 
  
  Pixel[] gpixels;
  boolean isAlternating = true;
  ArrayList<Sequence> sequences = new ArrayList<Sequence>();
  String seq_id = "000.seq";
  
  void setup(PApplet _app) {
    super.setup(_app);
    println("Setting up Grid");
    
    gpixels = new Pixel[rows * cols];
    
    int iP = 0;
    for (int iC = 0; iC < cols; iC++) {
      for (int iR = 0; iR < rows; iR++) {
        gpixels[iP++] = new Pixel();
      }
    }
    println("Initialized " + str(iP) + " pixels");
   
  }
  
  void controlEvent(ControlEvent theEvent) {
    //println("Got control event: " + theEvent.name());
    
  }
  
  /*
  seq_id - filename - 001.seq
  color c - sequence color - color type
  position - start position - PVector type
  flipX - reflect along X axis - boolean
  flipY - feflect along Y axis - boolean
  */
  void addSeq(color c, PVector position, boolean flipX, boolean flipY) {
    Sequence s = new Sequence();
    s.loadData(new File(config.get("dataPath")+"sequences\\" + this.seq_id));
    s.c = c;
    s.flipX = flipX;
    s.flipY = flipY;
    
    // need to figure out the offset
    // compare start position (PVector) against sequence.initial_pixel (0-99)
    //int pstart = position.X * 10 + position.Y;
    s.offsetRows = int(position.y) - this.calcRow(s.initial_pixel);
    s.offsetCols = int(position.x) - this.calcCol(s.initial_pixel);
    s.offset = s.offsetCols + (this.rows * s.offsetRows);
    
    //println("initial Y:" + this.calcRow(s.initial_pixel) + " initX: " + this.calcCol(s.initial_pixel));
    //println("posY: " + str(int(position.y)) + " posX: " + position.x);
    println("offset: " + str(s.offset) + " co: " + str(s.offsetCols) + " ro: " + str(s.offsetRows) + " flipX: " + flipX + " flipY: " + flipY);
    
    // s.offset...
    sequences.add(s);
  }
  
  int calcCol(int value) {
    return value % this.rows;
  }
  
  int calcRow(int value) {
    return floor(value / this.cols);
  }
}

class SimGridController extends GridController {
  float w = 600;
  float h = 600;
  float offsetX = 0;
  float offsetY = 0;
  boolean velocity_colors;
  
  float sw; // square width
  float sh; // square height .. *heh*
  boolean colortest = true;
  Palette p;
  int startSecond = 0;
  int startMinute = 0;
   
  void setup(PApplet _app) {
    println("SimGrid super");
    super.setup(_app);
        
    println("Setting up simgrid");
    sw = w / rows;
    sh = h / cols;
    p = new Palette();
    p.load("NES.tsv");
    startSecond = second();
    startMinute = minute();
    println("Done simgrid");
  }
  
  void draw() {
    if (colortest) {
      drawColorTest();
    } else {
      drawPixelPad();
    }
  }
  
  void drawColorTest() {
    int seconds = second() - this.startSecond;
    int minutes = minute() - this.startMinute;
    seconds = seconds + 60 * minutes;
    println("Seconds: " + seconds + " startSec: " + this.startSecond);
    if (seconds >= 2) {
      colortest = false;
    } else {
      int iX = 0;
      for (int iC = 0; iC < cols; iC++) {
        for (int iR = 0; iR < rows; iR++) {
          color c = getColor(int(random(127)));
          gpixels[iX].clear();
          gpixels[iX].set(c);
          this.drawPixel(iX, this.calcRow(iX), this.calcCol(iX));
          iX++;
        }
      }
    }
  }
  
  void drawPixel(int pixelId, int row, int col) {
    gpixels[pixelId].draw();

    float x1 = sw * col;
    float y1 = sh * row;
        
    rect(x1, y1, sw, sh);
  }
  
  void drawPixelPad() {
    stroke(255);
    int iP = 0;
    for (int iR = 0; iR < rows; iR++) {
      for (int iC = 0; iC < cols; iC++) {
        gpixels[iP].clear();
        
        for (int iX = 0; iX < sequences.size(); iX++) {
          if (sequences.get(iX).stepHas(iP)) {
            println("Setting pixel " + str(iP));
           // + " R: " + str(red(sequences.get(iX).c)));
            gpixels[iP].set(sequences.get(iX).c);
          }
        }
        this.drawPixel(iP++, iR, iC);
      }
    }
    

    for (int iX = 0; iX < sequences.size(); iX++) {
      int last = sequences.get(iX).step;
      sequences.get(iX).nextStep();
      if (sequences.get(iX).step == last) { sequences.remove(iX); }
    }
    delay(this.clockDelay);
  }

  // input is 0-127
  
  // Picks a color from the current palette
  color getColor(int input) {
    if (this.velocity_colors == false) { input = int(random(128)); }
    return p.pick(input);
  }
}

class PlayGridController extends SimGridController {
  SequenceLoadList seqList;
  PaletteLoadList paletteList;
  MyCheckbox cbOptions;
  
  
  void setup(PApplet _app) {
    super.setup(_app);
    
    seqList = new SequenceLoadList(c5, "Sequence", new PVector(100, 630), new PVector(80, 100));
    paletteList = new PaletteLoadList(c5, "Palette", new PVector(200, 630), new PVector(160, 100));
    cbOptions = new MyCheckbox(c5, "Options", new PVector(380, 605), new PVector(30, 20));
    cbOptions.cb.addItem("Show Grid", 0);
    cbOptions.cb.toggle(0);
    cbOptions.cb.addItem("Velocity Colors", 1);
    cbOptions.cb.toggle(1);
  }
  
  void hide() {
    seqList.list.setVisible(false);
    paletteList.list.setVisible(false);
    cbOptions.cb.setVisible(false);
  }
  
  void show() {
    seqList.list.setVisible(true);
    paletteList.list.setVisible(true);
    cbOptions.cb.setVisible(true);
  }
  
  void controlEvent(ControlEvent theEvent) {
    super.controlEvent(theEvent);
    
    if (theEvent.name().equals(seqList.name())) {
      int pick = (int)theEvent.group().value();
      println("Picked " + pick);
      println("File " + seqList.list.getItem(pick).getText());
      
      //seqList.list.getItem(pick).setColorBackground(color(0, 255, 255));
      seqList.selected(pick);
    } else if (theEvent.name().equals(paletteList.name())) {
      int pick = (int)theEvent.group().value();
      println("Picked " + pick);
      paletteList.selected(pick);
    } else if (theEvent.name().equals(cbOptions.cb.name())) {
      println(cbOptions.cb.getArrayValue());
      float[] optVals = theEvent.getArrayValue();
      DRAW_GRID = optVals[0] == 1.0;
      this.velocity_colors = optVals[1] == 1.0;
    }
  }
}
