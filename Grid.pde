import controlP5.*;

class GridController extends Controller {
  int rows = 10;
  int cols = 10;
  
  Pixel[] gpixels;
  boolean isAlternating = true;
  ArrayList<Sequence> sequences = new ArrayList<Sequence>();
  
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
  
  /*
  seq_id - filename - 001.seq
  color c - sequence color - color type
  position - start position - PVector type
  flipX - reflect along X axis - boolean
  flipY - feflect along Y axis - boolean
  */
  void addSeq(String seq_id, color c, PVector position, boolean flipX, boolean flipY) {
    Sequence s = new Sequence();
    s.loadData(new File(sketchPath+"/data/"+seq_id));
    s.c = c;
    s.flipX = flipX;
    s.flipY = flipY;
    
    // need to figure out the offset
    // compare start position (PVector) against sequence.initial_pixel (0-99)
    //int pstart = position.X * 10 + position.Y;
    s.offsetRows = int(position.x) - this.calcRow(s.initial_pixel);
    s.offsetCols = int(position.y) - this.calcCol(s.initial_pixel);
    s.offset = s.offsetRows + (this.cols * s.offsetCols);
    
    //println("initial Y:" + str(floor(s.initial_pixel / 10)));
    //println("posY: " + str(int(position.y)));
    //println("offset: " + str(s.offset) + " co: " + str(s.offsetCols) + " ro: " + str(s.offsetRows));
    
    // s.offset...
    sequences.add(s);
  }
  
  int calcRow(int value) {
    return value % this.rows;
  }
  
  int calcCol(int value) {
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
    
  void setup(PApplet _app) {
    super.setup(_app);
        
    sw = w / rows;
    sh = h / cols;
  }
  
  void draw() {
    stroke(255);
    int iP = 0;
    for (int iR = 0; iR < rows; iR++) {
      for (int iC = 0; iC < cols; iC++) {
        gpixels[iP].clear();
        
        for (int iX = 0; iX < sequences.size(); iX++) {
          if (sequences.get(iX).stepHas(iP)) {
            //println("Setting pixel " + str(iP) + " R: " + str(red(sequences.get(iX).c)));
            gpixels[iP].set(sequences.get(iX).c);
          }
        }
        
        gpixels[iP++].draw();

        float x1 = sw * iC;
        float y1 = sh * iR;
        
        rect(x1, y1, sw, sh);
      }
    }
    
    delay(100);
    for (int iX = 0; iX < sequences.size(); iX++) {
      int last = sequences.get(iX).step;
      sequences.get(iX).nextStep();
      if (sequences.get(iX).step == last) { sequences.remove(iX); }
    }
  }

}
