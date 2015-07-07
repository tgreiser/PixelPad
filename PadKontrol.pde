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
    
    grid.addSeq(c, new PVector(bc * 3, br * 3), false, false);
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
    
    grid.clockDelay = int(map(value, 0, 127, 50, 500));
  }
}
