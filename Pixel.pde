class Pixel {
  color rgb = color(0, 0, 0);
  int weight = 0;
  
  void clear() {
    rgb = color(0, 0, 0);
    weight = 0;
  }
  
  void set(color _rgb) {
    weight++;
    float opweight = 1.0 / float(weight);
    //println(rgb + " to " + _rgb + " weight=" + opweight);
    rgb = lerpColor(rgb, _rgb, opweight);
    //println(rgb);
  }
  
  void draw() {
    fill(rgb);
  }
}
