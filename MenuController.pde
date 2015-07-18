class MenuController extends Controller {
  RadioButton mode;
  
  Sequence sequence;

  void setup(PApplet _app) {
    super.setup(_app);
    
    mode = c5.addRadioButton("Mode")
      .setPosition(5, 605)
      .setColorBackground(color(55))
      .setSize(57, 19)
      .addItem("Edit", 1.0)
      .addItem("Play", 2.0)
      .setNoneSelectedAllowed(false)
      .setColorActive(#267257)
      ;
  }
  
  void controlEvent(ControlEvent theEvent) {
    if (theEvent.isFrom(mode)) {
      float val = theEvent.getValue(); 
      if (val == 1.0) {
        editMode();
      } else if (val == 2.0) {
        playMode();
      }
    }
  }
  
  void editMode() {
    ctrls[1] = edit;
    edit.show();
    grid.hide();
  }
  
  void playMode() {
    grid.seqList.load();
    ctrls[1] = grid;
    edit.hide();
    grid.show();
  }
}
