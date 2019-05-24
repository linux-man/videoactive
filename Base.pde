class Base {
  float pW, pH;
  int lastMillis, duration;
  boolean kill, paused;
  
  Base(int duration) {
    this.duration = duration;
    kill = false;
    paused = false;
    lastMillis = millis();
  }
  
  void draw() {
    
  }
}
