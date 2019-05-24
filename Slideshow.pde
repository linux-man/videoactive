class Slideshow extends Base {
  String[] photos;
  String folder;
  int nPhoto;
  PImage photo;
  boolean fullScreen;

  Slideshow(String folder, int duration, boolean fullScreen) {
    super(duration);
    this.folder = folder;
    this.fullScreen = fullScreen;
    photos = listPhotos(folder);
    kill = photos.length == 0;
    if(!kill) {
      nPhoto = 0;
      photo = loadImage(folder + "/" + photos[nPhoto]);
      calcSize();
    }
  }

  void draw() {
    if(!kill) {
      if(millis() - lastMillis >= duration && !paused) {
        nPhoto++;
        kill = nPhoto == photos.length;
        if(!kill) photo = loadImage(folder + "/" + photos[nPhoto]);
        calcSize();
        lastMillis = millis();
      }
      background(0);
      image(photo, width / 2, height / 2, pW, pH);
    }
    if(kill) photo = null;
  }
  
  String[] listPhotos(String folder) {
    File file = dataFile(folder);
    if (file.isDirectory()) {
      String names[] = file.list();
      return names;
    }
    else return null;
  }

  void calcSize() {
    if(fullScreen) {
      pW = width;
      pH = height;
    }
    else {
      float ratio = float(photo.width) / photo.height;
      pW = min(width, height * ratio);
      pH = min(height, width / ratio);
    }
  }
}
