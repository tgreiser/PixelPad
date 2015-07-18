public void section1(OPC opc) {
  
  strip(opc, 0, 1);
  strip(opc, 10, 2);
  strip(opc, 20, 3);
  strip(opc, 30, 4);
  strip(opc, 40, 5);
  strip(opc, 50, 6);
  strip(opc, 60, 7);
  strip(opc, 70, 8);
  strip(opc, 80, 9);
  strip(opc, 90, 10);
  
}
  
void strip(OPC opc, int index, int col) {
  for (int iX = 0; iX < 10; iX++) {
    opc.led(index + iX, int(grid.sw*col-1), int(grid.sh*iX)+1);
  }
}
