// Flowing Pagoda - alpha
// created by Michael Braverman
// December 6th, 2015

import ddf.minim.*;

AudioPlayer player;
Minim minim;//audio context

// load all the assets
PImage bg, bg1, bg2, bg3, bg4, bg5, pagoda, pagodaBot, pagodaTop;
Cloud cloud1;
Cloud cloud2;

int seasonCount;
boolean nextSeason;
int seasonDuration = 10000; // in milliseconds
int year;

Particle[] particels = new Particle[120];
Plant[] mamboos = new Plant[50];

void setup() {
  minim = new Minim(this);
  player = minim.loadFile("soundtrack.mp3", 2048);
  // player.play();

  size(640, 480);
  pixelDensity(1);
  bg = loadImage("bg.png");
  bg1 = loadImage("bg1Spring.png");
  bg2 = loadImage("bg2Spring.png");
  bg3 = loadImage("bg3Spring.png");
  bg4 = loadImage("bg4Spring.png");
  bg5 = loadImage("bg5Spring.png");

  pagodaBot = loadImage("pagodaBottom.png");
  pagodaTop = loadImage("pagodaTop.png");

  cloud1 = new Cloud(600, 120, -0.2, 1.7);
  cloud2 = new Cloud(0, 200, 0.35, 1.0);

  // set all particles as sakura leafs
  for (int i = 0; i < particels.length; i++) {
    particels[i] = new Particle(1, random(0.3, 0.6));
  }

  // set all plants as mamboos
  for (int i = 0; i < mamboos.length; i++) {
    mamboos[i] = new Plant(1, int(random(0, width)), int(random(300, 420)), 0.75, int(random(10000, 20000)));
  }
}

void draw() {
  background(bg);
  frameRate(60);
  stroke(255);

  // check if it is time for a season change
  if (millis() > seasonCount * seasonDuration) {
    seasonCount++;
    nextSeason = true;
  }

  // load the images only when there is a season change
  if (nextSeason == true) {
    if (seasonCount % 4 == 0) {
      // spring
      bg1 = loadImage("bg1Spring.png");
      bg2 = loadImage("bg2Spring.png");
      bg3 = loadImage("bg3Spring.png");
      bg4 = loadImage("bg4Spring.png");
      bg5 = loadImage("bg5Spring.png");
    } else
    if (seasonCount % 4 == 1) {
      // summer
      bg1 = loadImage("bg1.png");
      bg2 = loadImage("bg2.png");
      bg3 = loadImage("bg3.png");
      bg4 = loadImage("bg4.png");
      bg5 = loadImage("bg5.png");
    } else
    if (seasonCount % 4 == 2) {
      // fall
      bg1 = loadImage("bg1Autumn.png");
      bg2 = loadImage("bg2Autumn.png");
      bg3 = loadImage("bg3Autumn.png");
      bg4 = loadImage("bg4Autumn.png");
      bg5 = loadImage("bg5Spring.png");
    } else
    if (seasonCount % 4 == 3) {
      // winter
      bg1 = loadImage("bg1Winter.png");
      bg2 = loadImage("bg2Winter.png");
      bg3 = loadImage("bg3Winter.png");
      bg4 = loadImage("bg4Winter.png");
      bg5 = loadImage("bg5Winter.png");
    }
  }

  image(bg1, 0, 0);
  cloud1.display();
  image(bg2, 0, 0);
  image(bg3, 0, 0);
  cloud2.display();
  image(bg4, 0, 0);
  image(bg5, 0, 0);


  for (int i = 0; i < mamboos.length; i++) {
    mamboos[i].update();
    mamboos[i].display();
  }

  // draw the pagoda diffirently based on season
  if (seasonCount % 4 == 3) {
    // snowey pagoda
    pagodaBot = loadImage("pagodaBottomSnow.png");
    pagodaTop = loadImage("pagodaTopSnow.png");
  } else {
    // normal pagoda
    pagodaBot = loadImage("pagodaBottom.png");
    pagodaTop = loadImage("pagodaTop.png");
  }

  year = seasonCount/4;

  for (int i = constrain(year, 1, 5); i > 0; i--) {
    // draw a pagoda with a maximum height of 5
    image(pagodaBot, 240, 349 - (constrain(i - 1, 1, 4) * 49));
  }

  if (year > 1) {
    // draw a roof on top of the pagoda with a maximum height of 5
    image(pagodaTop, 240, 349 - (constrain(year, 1, 5) * 49));
  }

  // irriterate through all of the particels
  for (int i = 0; i < particels.length; i++) {
    // check if it is time for a season change
    if (nextSeason) {
      //update the to next season
      particels[i].changeIdTo = (seasonCount % 4) + 1;
      particels[i].seasonChange = true;
    }
    particels[i].update();
    particels[i].display();
  }

  nextSeason = false;
  println(seasonCount);

}

void stop() {
  player.close();
  minim.stop();
  super.stop();
}
