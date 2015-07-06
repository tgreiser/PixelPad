class Keyboard {
  Keyboard(PApplet _app) {
  }
  
  void keyPressed() {
    if (key == CODED) {
      println("Key code " + keyCode);
    } else if (key == 'z') {
      //grid.addSeq(
    } else {
      println("Key " + key);
    }
  }
  
  void addSeq(char kb) {
  }
}
