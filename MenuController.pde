class MenuController extends Controller {
  RadioButton mode;
  
  Sequence sequence;

  void setup(PApplet _app) {
    super.setup(_app);
    
    mode = c5.addRadioButton("Mode")
      .setPosition(5, 605)
      .setColorBackground(color(55))
      .setSize(57, 19)
      .addItem("Edit", 1)
      .addItem("Play", 2)
      .setValue(2.0)
      ;
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(mode)) {
      float val = theEvent.getValue(); 
      if (val == 1.0) {
        ctrls[1] = edit;
        edit.show();
      } else if (val == 2.0) {
        ctrls[1] = grid;
        edit.hide();
      }
    }
  }
}
