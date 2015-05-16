class Pixel {
  color rgb = color(0, 0, 0);
  int weight = 0;
  
  void clear() {
    rgb = color(0, 0, 0);
    weight = 0;
  }
  
  void set(color _rgb) {
    rgb = lerpColor(rgb, _rgb, 1.0 / float(weight++));
  }
  
  void draw() {
    fill(rgb);
  }
}
