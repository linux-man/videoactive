abstract class Motion extends Base {
  SimpleMotionDetection detector;
  SimpleBinary binary;
  PImage iDetector, iPaint;
  int style, lastColor, colorDuration;
  color defaultColor;
  boolean showCam;

  Motion(int style, int duration, int colorDuration, boolean showCam, boolean fullScreen) {
    super(duration);
    this.style = style;
    this.colorDuration = colorDuration;
    this.showCam = showCam;
    if(style == 3) defaultColor = color(random(255), random(255), random(255));
    else defaultColor = color(255);
    iPaint = new PImage(cam.width, cam.height);
    iPaint.loadPixels();
    detector = Boof.motionDetector(new ConfigBackgroundBasic(50, 0.4f));
    //detector = Boof.motionDetector(new ConfigBackgroundGmm());
    if(fullScreen) {
      pW = width;
      pH = height;
    }
    else {
      float ratio = float(cam.width) / cam.height;
      pW = min(width, height * ratio);
      pH = min(height, width / ratio);
    }
  }

  void draw() {
    if(millis() - lastMillis >= duration && !paused) {
      detector = null;
      iDetector = null;
      iPaint = null;
      kill = true;
    }
    if(!kill) {
      if(style == 3 && millis() - lastColor > colorDuration) {
        defaultColor = color(random(255), random(255), random(255));
        lastColor = millis();
      }
      if(cam.available()) {
        cam.read();
        binary = detector.segment(cam);
        iDetector = binary.visualize();
        background(0);
        translate(width, 0);
        scale(-1, 1);
        drawStyle();
      }
    }
  }

  abstract public void drawStyle();
}
