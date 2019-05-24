class Ar extends Base {
  OpenCV opencv;
  PImage img;
  float offsetX, offsetY, scale;

  Ar(String file, int duration, float offsetX, float offsetY, float scale, boolean fullScreen) {
    super(duration);
    this.offsetX = offsetX;
    this.offsetY = offsetY;
    this.scale = scale;
    opencv = new OpenCV(main, cam.width, cam.height);
    opencv.loadCascade(OpenCV.CASCADE_FRONTALFACE);

    img = loadImage(file);
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
      opencv = null;
      img = null;
      kill = true;
    }
    if(!kill && cam.available()) {
      cam.read();
      opencv.loadImage(cam);
      Rectangle[] faces = opencv.detect();
      background(0);
      translate(width, 0);
      scale(-1, 1);
      image(cam, width / 2, height / 2, pW, pH);
      for (int i = 0; i < faces.length; i++) {
        image(img, (faces[i].x + faces[i].width * (1 + 2 * offsetX) / 2) * pW / cam.width + (width - pW) / 2, (faces[i].y + faces[i].height * (1 + 2 * offsetY) / 2) * pH / cam.height + (height - pH) / 2, faces[i].width * pW / cam.width * scale, faces[i].height * pH / cam.height * scale);
// Rect test
/*
        stroke(255);
        noFill();
        rect((faces[i].x + faces[i].width * (1 + 2 * offsetX) / 2) * pW / cam.width + (width - pW) / 2, (faces[i].y + faces[i].height * (1 + 2 * offsetY) / 2) * pH / cam.height + (height - pH) / 2, faces[i].width * pW / cam.width * scale, faces[i].height * pH / cam.height * scale);
*/
      }
    }
  }
}
