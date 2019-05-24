class Video extends Base {
  Movie movie;

  Video(String src, int duration, boolean fullScreen) {
    super(duration);
    movie = new Movie(main, src);
    movie.loop();
    movie.volume(100);
    if(fullScreen) {
      pW = width;
      pH = height;
    }
    else {
      float ratio = float(movie.width) / movie.height;
      pW = min(width, height * ratio);
      pH = min(height, width / ratio);
    }
  }

  void draw() {
    if(duration == 0) duration = int(movie.duration() * 1000);
    if(millis() - lastMillis >= duration && !paused) {
      movie.stop();
      movie = null;
      kill = true;
    }
    if(!kill) {
      background(0);
      image(movie, width / 2, height / 2, pW, pH);    
    }
  }
}
