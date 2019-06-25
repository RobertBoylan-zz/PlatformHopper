class Player {
  float gravity = 0.14;
  float bounceVel = 6.1;
  float maxYVel = 14;
  float maxXVel = 4;

  float xPos, yPos, xVel, yVel;

  int animationSpeed = 3;
  int imageCount;

  int reloadWaitTime = 500;
  int reloadStart;
  int reloadEnd;

  int playerWidth, playerHeight;

  int playerSpeed = 2;
  int frame;

  boolean playerRight = true;
  boolean reload = false;

  PImage imagesRight[];
  PImage imagesLeft[];

  Player(int _xPos, int _yPos) {
    xPos = _xPos;
    yPos = _yPos;
  }

  void loadImages(String imagePrefix, int count) {
    imageCount = count;
    imagesRight = new PImage[imageCount];
    imagesLeft = new PImage[imageCount];

    for (int i = 0; i < imageCount; i++) {
      String filename = imagePrefix + nf(i, 1) + ".gif";
      imagesRight[i] = loadImage(filename);
      imagesRight[i].loadPixels();
      imagesLeft[i] = createImage(imagesRight[i].width, imagesRight[i].height, ARGB);
      imagesLeft[i].loadPixels();
      for (int y = 0; y < imagesRight[i].height; y++ ) {
        for (int x = 0, x2 = imagesRight[i].width - 1; x < imagesRight[i].width && x2 >= 0; x++, x2--) {
          imagesLeft[i].pixels[x2+y*imagesRight[i].width] = imagesRight[i].pixels[x+y*imagesRight[i].width];
        }
      }
      imagesLeft[i].updatePixels();
    }
    playerWidth = imagesRight[0].width;
    playerHeight = imagesRight[0].height;
  }

  void animate() {
    if (frameCount % animationSpeed == 0) {
      frame = (frame+1) % imageCount;
    }
  }

  void display() {
    imageMode(CENTER);
    if (playerRight == false) {
      image(imagesLeft[frame], xPos, yPos);
    } else {
      image(imagesRight[frame], xPos, yPos);
    }
  }

  void move() {
    xPos += xVel;
    yPos += yVel;

    if (xPos  > width) {
      xPos = 0;
    } else if (xPos  < 0) {
      xPos = width;
    }

    if (keyPressed) {
      if (key == 'a') {
        animate();
        playerRight = false;
        xVel -= 0.1;
      } else if (key == 'd') {
        animate();
        playerRight = true;
        xVel += 0.1;
      }
    }

    if (abs(xVel) < 0.01) {
      xVel = 0;
    }
    xVel = min(maxXVel, xVel);
    xVel = max(-maxXVel, xVel);

    yVel += gravity;
    yVel = min(maxYVel, yVel);
    yVel = max(-maxYVel, yVel);
  }

  void shoot(ArrayList<Bullet> bulletList, ArrayList<Enemy> enemyList) {
    if (keyPressed) {
      if (key == ' ') {
        if (!reload) {
          bulletList.add(new Bullet(xPos, yPos-playerHeight/2));
          reload = true;
          reloadStart = millis();
        }
      }
    }

    reloadEnd = millis();

    if (reloadEnd - reloadStart >= reloadWaitTime) {
      reload = false;
    }
    for (int i=0; i<bulletList.size()-1; i++) {
      bulletList.get(i).display();
      bulletList.get(i).move();

      if (bulletList.get(i).yPos < 0) {
        bulletList.remove(i);
      }

      for (int j=0; i<enemyList.size()-1; i++) {
        if (bulletList.get(j).enemyCollision(enemyList.get(j))) {
          bulletList.remove(j);
          enemyList.remove(j);
        }
      }
    }
  }

  void platformCollision(Platform platform) {
    if (xPos >= (platform.xPos-(platform.platformWidth/2)) && xPos <= (platform.xPos+(platform.platformWidth/2)) && yPos+(playerHeight/2) >= (platform.yPos-(platform.platformHeight/2)-5) && yPos+(playerHeight/2) <= (platform.yPos-(platform.platformHeight/2)+5)) {
      if (yVel > 0) {
        yVel = -bounceVel;
      }
    }
  }

  boolean enemyCollision(Enemy enemy) {
    if (xPos >= (enemy.xPos-(enemy.enemyWidth/2)) && xPos <= (enemy.xPos+(enemy.enemyWidth/2)) && yPos >= (enemy.yPos-(enemy.enemyHeight/2)-(playerHeight/2)-5) && yPos <= (enemy.yPos+(enemy.enemyHeight/2)+(playerHeight/2)+5)) {
      return true;
    }
    return false;
  }
}