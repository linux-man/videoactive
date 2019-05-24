import processing.video.*;
import boofcv.factory.background.*;
import boofcv.processing.*;
import gab.opencv.*;
import java.awt.*;

Base effect;
Capture cam;
PApplet main = this;

int nList;

/*
String list format:
  "Video, Video(string), Duration(int), FullScreen(boolean)",
  "Ar, Image(string), Duration(int), Horizontal Offset(float), Vertical Offset(float), Scale(float), FullScreen(boolean)",
  "Motion, Style(int), Duration(int), Color Duration(int), Show Cam(boolean), FullScreen(boolean)",
  "Slideshow, Folder(string), 1000, Duration(int), FullScreen(boolean)",
  "Stop",
  
  Duration and Color Change in miliseconds.
  At Video, Duration = 0 reads video duration.
  Style can be 1 to 3. Style 3 uses Color Duration.
  Horizontal Offset, Vertical Offset and Scale are fractions of the "face box".
  Video and Image files and Slideshow folder should be inside data folder.
  FullScreen fill all the screen (can end up nonscaled).
  "Stop" exits the program, otherwise it cycles.
  
  Keyboard:
  ESC: Quit
  SPACE: Pause at current effect/unpause.
  ENTER: Screenshot saved on application folder.
  LEFT/RIGHT: Move to previous/next effect.
*/

String[] list = {
  "Video, logo.mp4, 20000, true",
  "Video, Pexels Videos 1572315.mp4, 0, false",
  "Ar, moustache.png, 20000, 0, 0, 1.2, true",
  "Ar, crown.png, 20000, 0, -1, 1.4, true",
  "Motion, 1, 5000, 0, false, true",
  "Motion, 2, 5000, 0, false, true",
  "Motion, 3, 10000, 2000, false, true",
  "Motion, 1, 5000, 0, true, true",
  "Motion, 2, 5000, 0, true, true",
  "Motion, 3, 10000, 4000, true, true",
  "Slideshow, photos, 3000, false",
};
                 
void setup() {
  fullScreen();
  imageMode(CENTER);
  rectMode(CENTER);
  initializeCamera();
  nList = 0;
  effect = newEffect();
}

void draw() {
  if(effect == null) effect = newEffect();
  else {
    effect.draw();
    if(effect.kill) effect = null;
  }
}

void keyPressed() {
  if(key == ' ') effect.paused = !effect.paused;
  if(keyCode == ENTER) saveFrame();
  if(keyCode == RIGHT) effect.kill = true;
  if(keyCode == LEFT) {
    nList -= 2;
    effect.kill = true;
  }
}

void movieEvent(Movie m) {
  m.read();
}

void initializeCamera() {
  String[] cameras = Capture.list();

  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  }
  else {
    printArray(cameras);
/*
Choose your camera from the console list. Depending on the computer, a VGA camera can show some lag. In this case it's better to use half resolution.
*/
    //cam = new Capture(this, cameras[cameras.length - 1]);
    //cam = new Capture(this, 640, 480, cameras[0], 25);
    cam = new Capture(this, 320, 240, cameras[0]);
    cam.start();
    println("Width: ", cam.width);
    println("Height: ", cam.height);
    println("fps: ", cam.frameRate);
  }
}

Base newEffect() {
  if(nList >= list.length) nList = 0;
  if(nList < 0) nList = list.length - 1;
  String command = list[nList];
  if(command == "Stop") exit();
  else {
    nList++;
    String[] args = split(command, ',');
    for(int n = 0; n < args.length; n++) args[n] = trim(args[n]);
    if(args[0].equals("Ar")) return new Ar(args[1], int(args[2]), float(args[3]), float(args[4]), float(args[5]), boolean(args[6]));
    else if(args[0].equals("Motion"))
    switch(int(args[1])) {
        case 1:
          return new Motion(int(args[1]), int(args[2]), int(args[3]), boolean(args[4]), boolean(args[5])) {
            @Override public void drawStyle() {
              background(0);
              if(showCam) {
                iDetector.mask(iDetector);
                image(cam, width / 2, height / 2, pW, pH);
              }
              image(iDetector, width / 2, height / 2, pW, pH);
            }
          };
        case 2: case 3:
          return new Motion(int(args[1]), int(args[2]), int(args[3]), boolean(args[4]), boolean(args[5])) {
            @Override public void drawStyle() {
              for(int n = 0; n < iDetector.pixels.length; n++) {
                if(iDetector.pixels[n] != color(0)) iPaint.pixels[n] = defaultColor;
                iPaint.pixels[n] = color(red(iPaint.pixels[n]), green(iPaint.pixels[n]), blue(iPaint.pixels[n]), max(1, alpha(iPaint.pixels[n]) - 8));
              }
              iPaint.updatePixels();
              background(0);
              if(showCam) image(cam, width / 2, height / 2, pW, pH);
              image(iPaint, width / 2, height / 2, pW, pH);
            }
          };
    }
    else if(args[0].equals("Slideshow")) return new Slideshow(args[1], int(args[2]), boolean(args[3]));
    else if(args[0].equals("Video")) return new Video(args[1], int(args[2]), boolean(args[3]));
  }
  return null;
}
