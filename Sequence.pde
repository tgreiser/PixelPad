import java.util.*;
import java.io.*;

/**
 * Data schema:
 * Variable # of steps
 * Each step is 100 boolean values
 */

class Sequence {
  int step = 0;
  Boolean[][] data = new Boolean[1][100];
  int initial_pixel = -1;
 
  void init() {
    initStep(0);
    
    // Create file and save 2D array
    //File file = new File (sketchPath("") + "arrayData");
    //saveData(file, array0);
    // Load the data into second 2D array
    //array1 = loadData(file);
  }
  
  void initStep(int iS) {
    for (int iX = 0; iX < data[iS].length; iX++) {
      data[iS][iX] = false;
    }
  }
  
  void addStep() {
    step++;
    Boolean[][] newdata = new Boolean[data.length + 1][100];
    System.arraycopy(data, 0, newdata, 0, data.length);
    data = newdata;
    initStep(data.length - 1);
  }
  
  void prevStep() {
    if (step > 0) {
      step--;
    }
  }
  
  void nextStep() {
    if (step < data.length - 1) {
      step++;
    }
  }
  
  void addPixel(int iP) {
    if (initial_pixel == -1) { initial_pixel = iP; }
    data[step][iP] = true;
  }
  
  void removePixel(int iP) {
    data[step][iP] = false;
  }
  
  // return all pixels in the current step
  Pixel[] pixels() {
    int len = data[step].length;
    Pixel[] newp = new Pixel[len];
      
    for (int iX = 0; iX < len; iX++) {
      newp[iX] = new Pixel();
      if (data[step][iX] == true) {
        newp[iX].set(color(255, 0, 0));
      }
    }
    return newp;
  }
  
  boolean stepHas(int value) {
    return data[step][value];
  }

  /**
   * Save the data to disk
   */
  public void saveData(File file) {
    try {
      FileOutputStream fos = new FileOutputStream(file);
      ObjectOutputStream oos = new ObjectOutputStream(fos);
      Integer initial = initial_pixel;
      oos.writeObject(initial);
      oos.writeObject(data);
      fos.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    }
  }
 
  /**
   * Load the data from disk 
   */
  public void loadData(File file) {
    Boolean[][] array = null;
    Integer initial = -1;
    try {
      FileInputStream fis = new FileInputStream(file);
      ObjectInputStream ois = new ObjectInputStream(fis);
      initial = (Integer) ois.readObject();
      array = (Boolean[][]) ois.readObject();
      fis.close();
    } 
    catch (IOException e) {
      e.printStackTrace();
    } 
    catch (ClassNotFoundException e) {
      e.printStackTrace();
    }
    initial_pixel = initial;
    data = array;
    println("Loaded with initial pixel " + initial_pixel);
  }
}

boolean array_contains(Integer array[], int value) {
  for (int iX = 0; iX < array.length; iX++) {
    if (array[iX] == value) { return true; }
  }
  return false;
}
