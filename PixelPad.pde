import java.net.*;
import java.util.Arrays;

ControlP5 c5;

OPC opc;
SimGridController grid;
EditorController edit;
MenuController menu;
Keyboard kb;
Controller[] ctrls;
StringDict config;
String server = "192.168.0.12";
boolean ENABLE_LED = false;
boolean DRAW_GRID = true;

PadKontrol midi;

void setup() {
  size(600, 700);
  background(0);
  c5 = new ControlP5(this);
  if (ENABLE_LED) { opc = new OPC(this, server, 7890); }
  
  config = new StringDict();
  config.set("dataPath", dataPath("") + "\\");
  
  midi = new PadKontrol(this);
  kb = new Keyboard(this);
  
  ctrls = new Controller[2];
  grid = new SimGridController();
  edit = new EditorController();
  menu = new MenuController();
  
  // have to setup grid because it isn't loaded in ctrls
  println("Initial grid setup from PApplet"); //<>//
  grid.setup(this);
  
  ctrls[0] = menu;
  ctrls[1] = edit;
  
  for (Controller c : ctrls) {
    c.setup(this);
  }
  if (ENABLE_LED) { section1(opc); }
  
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
