import themidibus.*; //Import the library

class MidiController {
  MidiBus myBus; // The MidiBus
  
}

class PadKontrol extends MidiController implements SimpleMidiListener {
  PadKontrol(PApplet _app) {
    MidiBus.list(); // List all available Midi devices on STDOUT. This will show each device's index and name.
    ArrayList<java.lang.String> ins = new ArrayList<java.lang.String>();
    ins.addAll(java.util.Arrays.asList(MidiBus.availableInputs()));
    
    if (ins.contains("padKONTROL 1 PORT A")) {
      myBus = new MidiBus(_app, "padKONTROL 1 PORT A", "padKONTROL 1 CTRL"); // Create a new MidiBus (PApplet, in_device_name, out_device_name)
      myBus.addMidiListener(this);
      println("Listen for:  padKONTROL 1 PORT A");
    } else if (ins.contains("MIDIIN2 (padKONTROL)")) {
      myBus = new MidiBus(_app, "MIDIIN2 (padKONTROL)", "MIDIOUT2 (padKONTROL)"); // Create a new MidiBus (PApplet, in_device_name, out_device_name)
      myBus.addMidiListener(this);
     println("Listen for:  padKONTROL");
    } else {
      println("Skipping padKONTROL, not detected...");
    }
  }
  
  void noteOn(int channel, int pitch, int velocity) {
    // Receive a noteOn
    println();
    println("Note On:");
    println("--------");
    println("Channel:"+channel);
    println("Pitch:"+pitch);
    println("Velocity:"+velocity);
    
    int br = 0;
    int bc = 0;
    if (pitch >= 48) {
      bc = pitch % 48;
    } else if (pitch >= 44) {
      br = 1;
      bc = pitch % 44;
    } else if (pitch >= 40) {
      br = 2;
      bc = pitch % 40;
    } else {
      br = 3;
      bc = pitch % 36;
    }
    //println("BC: " + bc + " BR:" + br);
    
    color c = grid.getColor(velocity);
    boolean flipX = false;
    boolean flipY = false;
    if (bc > 1) { flipY = true; }
    if (br <= 1) { flipX = true; }
    
    println("bc: " + bc + " br: " + br +" fX: " + flipX + " fY: " + flipY);
    
    grid.addSeq(c, new PVector(bc * 3, br * 3), flipX, flipY);
  }
  
  void noteOff(int channel, int pitch, int velocity) {}
  
  void controllerChange(int channel, int number, int value) {
    // Receive a controllerChange
    println();
    println("Controller Change:");
    println("--------");
    println("Channel:"+channel);
    println("Number:"+number);
    println("Value:"+value);
    
    if (number == 20) {
      // pick a sequence
      grid.seqList.selected(int(map(value, 0, 127, 0, grid.seqList.length()-1)));
    } else if (number == 21) {
      grid.clockDelay = int(map(value, 0, 127, 1, 200));
    }
  }
}
