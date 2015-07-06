ControlP5 c5;

SimGridController grid;
EditorController edit;
MenuController menu;
Keyboard kb;
Controller[] ctrls;

PadKontrol midi;

void setup() {
  size(600, 700);
  background(0);
  
  midi = new PadKontrol(this);
  kb = new Keyboard(this);
  
  ctrls = new Controller[2];
  grid = new SimGridController();
  edit = new EditorController();
  menu = new MenuController();
  
  // have to setup grid because it isn't loaded in ctrls
  grid.setup(this);
  
  ctrls[0] = menu;
  ctrls[1] = edit;
  
  c5 = new ControlP5(this);
  
  for (Controller c : ctrls) {
    c.setup(this);
  }
  
  menu.mode.activate("Play");
}

void draw() {
  background(0);
  
  for (Controller c : ctrls) {
    c.draw();
  }
}

void mouseReleased() {
  for (Controller c : ctrls) {
    c.mouseReleased();
  }
}

void mouseDragged() {
  for (Controller c : ctrls) {
    c.mouseDragged();
  }
}

void keyPressed() {
  for (Controller c : ctrls) {
    c.keyPressed();
  }
  kb.keyPressed();
}

void controlEvent(ControlEvent theEvent) {
  for (Controller c : ctrls) {
    if (c != null) c.controlEvent(theEvent);
  }
}

void saveCallback(File selected) {
  edit.saveCallback(selected);
}

void loadCallback(File selected) {
  edit.loadCallback(selected);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
