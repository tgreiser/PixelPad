import controlP5.*;

class GridController extends Controller {
  int rows = 10;
  int cols = 10;
  int clockDelay = INITIAL_DELAY; 
  
  Pixel[] gpixels;
  boolean isAlternating = true;
  ArrayList<Sequence> sequences = new ArrayList<Sequence>();
  String seq_id = "000.seq";
  
  ListBox seqList;
  
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
    
    seqList = c5.addListBox("SequenceList")
      .setPosition(100, 620)
      .setSize(90, 75)
      .setItemHeight(15)
      .setBarHeight(15)
      .setColorBackground(color(255, 128))
      .setColorActive(color(0))
      .setColorForeground(color(255, 100,0))
      ;

    seqList.captionLabel().toUpperCase(true);
    seqList.captionLabel().set("Sequence");
    seqList.captionLabel().setColor(0xffff0000);
    seqList.captionLabel().style().marginTop = 3;
    seqList.valueLabel().style().marginTop = 3;
    
    File file = new File(config.get("dataPath") + "\\sequences\\");
    File[] files = file.listFiles();
    for (int i = 0; i < files.length; i++) {
      ListBoxItem lbi = seqList.addItem(files[i].getName(), i);
      lbi.setColorBackground(color(55));
    }
  }
  
  void controlEvent(ControlEvent theEvent) {
    println("Got control event: " + theEvent.name());
    if (theEvent.name().equals(seqList.name())) {
      int pick = (int)theEvent.group().value();
      println("Picked " + pick);
      println("File " + seqList.getItem(pick).getText());
      
      seqList.getItem(pick).setColorBackground(color(0, 255, 0));
      this.seq_id = seqList.getItem(pick).getText();
    }
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
    
    return p.pick(input);
  }
}
