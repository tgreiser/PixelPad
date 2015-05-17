import themidibus.*; //Import the library

MidiBus myBus; // The MidiBus
SimGrid grid;
ControlP5 c5;

void setup() {
  size(600, 700);
  background(0);
  
  c5 = new ControlP5(this);

  MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.

  myBus = new MidiBus(this, "padKONTROL 1 PORT A", "padKONTROL 1 CTRL"); // Create a new MidiBus
  grid = new SimGrid();
  grid.init();  
}

void draw() {
  grid.draw();
  
  /*
  int channel = 0;
  int pitch = 64;
  int velocity = 127;

  myBus.sendNoteOn(channel, pitch, velocity); // Send a Midi noteOn
  delay(200);
  myBus.sendNoteOff(channel, pitch, velocity); // Send a Midi nodeOff

  int number = 0;
  int value = 90;

  myBus.sendControllerChange(channel, number, value); // Send a controllerChange
  delay(2000);
  */
}

void mouseReleased() {
  grid.mouseReleased();
}

void keyPressed() {
  grid.keyPressed();
}

void controlEvent(ControlEvent theEvent) {
  if (grid != null) grid.controlEvent(theEvent);
}

void saveCallback(File selected) {
  grid.saveCallback(selected);
}

void loadCallback(File selected) {
  grid.loadCallback(selected);
}

void noteOn(int channel, int pitch, int velocity) {
  // Receive a noteOn
  println();
  println("Note On:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void noteOff(int channel, int pitch, int velocity) {
  // Receive a noteOff
  println();
  println("Note Off:");
  println("--------");
  println("Channel:"+channel);
  println("Pitch:"+pitch);
  println("Velocity:"+velocity);
}

void controllerChange(int channel, int number, int value) {
  // Receive a controllerChange
  println();
  println("Controller Change:");
  println("--------");
  println("Channel:"+channel);
  println("Number:"+number);
  println("Value:"+value);
}

void delay(int time) {
  int current = millis();
  while (millis () < current+time) Thread.yield();
}
