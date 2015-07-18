class MyCheckbox {
  color colorActive = #133453;
  color colorBG = #2A4D6E;
  color colorSelected = #267257;

  CheckBox cb;
  boolean value = false;
  
  MyCheckbox(ControlP5 c5, String title, PVector pos, PVector size) {
    this.cb = c5.addCheckBox(title)
      .setPosition(pos.x, pos.y)
      .setSize(int(size.x), int(size.y))
      .setItemsPerRow(1)
      .setSpacingColumn(30)
      .setSpacingRow(5)
      .setColorBackground(this.colorBG)
      .setColorActive(this.colorSelected);
  }
}

class LoadList {
  color colorActive = #133453;
  color colorBG = #2A4D6E;
  color colorSelected = #267257;
  
  ListBox list;
  int selectedIndex = -1;
  int count = 0;
  
  LoadList(ControlP5 c5, String title, PVector pos, PVector size) {
    this.list = c5.addListBox(title)
      .setPosition(pos.x, pos.y)
      .setSize(int(size.x), int(size.y))
      .setItemHeight(20)
      .setBarHeight(20)
      .setColorBackground(this.colorBG)
      .setColorActive(this.colorSelected);
    this.list.captionLabel().set(title);
    this.list.captionLabel().style().marginTop = 3;
    this.list.captionLabel().style().marginLeft = 3;
    this.list.captionLabel().setColor(color(255));
      
    this.load();
    if (this.length() > 0) { this.selected(0); }
  }
  
  int length() {
    return this.count;
  }
  
  void load() {
    int i = 0;
    for (i=0;i<80;i++) {
       ListBoxItem lbi = list.addItem("item "+i, i);
       lbi.setColorBackground(this.colorBG);
     }
     this.count = i - 1;
  }
  
  void selected(int currentIndex) {
    println("currentIndex:  "+currentIndex + " length: " + this.length());
    if (this.length() <= currentIndex) { return; }
    if(this.selectedIndex >= 0){//if something was previously selected
      ListBoxItem previousItem = list.getItem(this.selectedIndex);//get the item
      previousItem.setColorBackground(this.colorBG);//and restore the original bg colours
    }
    this.selectedIndex = currentIndex;//update the selected index
    this.list.getItem(this.selectedIndex).setColorBackground(this.colorSelected);//and set the bg colour to be the active/'selected one'...until a new selection is made and resets this, like above
  }
  
   String name() {
     return list.name();
   }
}

class SequenceLoadList extends LoadList {
  SequenceLoadList(ControlP5 c5, String title, PVector pos, PVector size) {
    super(c5, title, pos, size);
  }
  
  void load() {
    File file = new File(config.get("dataPath") + "\\sequences\\");
    File[] files = file.listFiles();
    this.list.clear();
    for (int i = 0; i < files.length; i++) {
      ListBoxItem lbi = this.list.addItem(files[i].getName(), i);
      lbi.setColorBackground(this.colorBG);
    }
    this.count = files.length;
    this.selected(0);
  }
  
  void selected(int currentIndex) {
    super.selected(currentIndex);
    ListBoxItem li = this.list.getItem(currentIndex);
    if (grid != null && li != null) { 
      grid.seq_id = li.getText();
      println("Loaded " + grid.seq_id);
    }
  }
}

class PaletteLoadList extends LoadList {
  PaletteLoadList(ControlP5 c5, String title, PVector pos, PVector size) {
    super(c5, title, pos, size);
  }
  
  void load() {
    File file = new File(config.get("dataPath") + "\\palettes\\");
    File[] files = file.listFiles();
    int iX = 0;
    for (int i = 0; i < files.length; i++) {
      String name = files[i].getName();
      if (name.toLowerCase().endsWith(".tsv") == false) { continue; }
      ListBoxItem lbi = this.list.addItem(name, iX);
      lbi.setColorBackground(this.colorBG);
      iX++;
    }
    this.count = files.length;
  }
  
  void selected(int currentIndex) {
    super.selected(currentIndex);
    ListBoxItem li = this.list.getItem(currentIndex);
    if (grid != null && li != null) {
      String pname = li.getText(); 
      grid.p.load(li.getText());
      println("Loaded " + pname);
    }
  } 
}
