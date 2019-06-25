Player player; //<>//

ArrayList<Enemy> enemyList;
ArrayList<Bullet> bulletList;
ArrayList<Platform> platformList;

int score, fallCount, enemyChance;

boolean gameOver;

void setup() {
  size(1000, 1000);

  frame.setAlwaysOnTop(true);

  score = 0;
  fallCount = 0;

  gameOver = false;

  platformList = new ArrayList<Platform>();
  enemyList = new ArrayList<Enemy>();
  bulletList = new ArrayList<Bullet>();

  for (int i=1000; i>0; i-=50) {
    platformList.add(new Platform(random(60, width-60), i));
  }
  enemyList.add(new Enemy(platformList.get(int(random(0, platformList.size())))));
  enemyList.get(0).loadEnemyImage();

  player = new Player(width/2, height/2);
  player.loadImages("Player", 8);
}

void draw() {
  background(155, 236, 255);

  for (int i=0; i<platformList.size(); i++) {
    if (!gameOver) { 
      player.platformCollision(platformList.get(i));
      platformList.get(i).move();
    }
    platformList.get(i).display();
  }

  gameOver();
  adjustViewport();
  addPlatform();
  removePlatform();

  player.display();
  player.move();
  player.shoot(bulletList,enemyList);

  for (int i=0; i<enemyList.size(); i++) {
    enemyList.get(i).display();
    
    if (!gameOver) {
      enemyList.get(i).move();
    }
  }

  addEnemy();
  removeEnemy();

  if (gameOver) {
    fill(0);
    textSize(40);
    textAlign(CENTER);
    text("Game Over", width/2, height/2);
  }
}

void adjustViewport() {
  // above midpoint
  float overHeight = height * 0.5 - player.yPos;
  if (overHeight > 0) {
    player.yPos += overHeight;
    for (int i=0; i<platformList.size(); i++) {
      platformList.get(i).yPos += overHeight;
    }
    for (int i=0; i<enemyList.size(); i++) {
      enemyList.get(i).yPos += overHeight;
    }
    score += overHeight;
  }

  // falling
  float underHeight = player.yPos - (height-player.playerHeight-4);
  if (underHeight > 0) {
    player.yPos -= underHeight;
    for (int i=0; i<platformList.size(); i++) {
      platformList.get(i).yPos -= underHeight;
    }
    for (int i=0; i<enemyList.size(); i++) {
      enemyList.get(i).yPos -= underHeight;
    }
  }
}

void addPlatform() {
  if (platformList.size() < 20) {
    platformList.add(new Platform(random(60, width-60), -20));
  }
}

void removePlatform() {
  for (int i=platformList.size()-1; i>=0; i--) {
    if (platformList.get(i).yPos > height) {
      platformList.remove(i);
    }
  }
}

void addEnemy() {
  enemyChance = int(random(0, 1001));
  if (enemyChance >= 0 && enemyChance <= 1) {
    enemyList.add(new Enemy(platformList.get(platformList.size()-1)));
    for (int i=0; i<enemyList.size(); i++) {
      enemyList.get(i).loadEnemyImage();
    }
  }
}

void removeEnemy() {
  for (int i=0; i<enemyList.size()-1; i++) {
    if (enemyList.get(i).yPos > height+enemyList.get(i).enemyHeight/2 || (player.enemyCollision(enemyList.get(i)) && player.yVel > 0)) {
      enemyList.remove(i);
    }
  }
}

int platformsBelow() {
  int count = 0;
  for (int i=0; i<platformList.size(); i++) {
    if (platformList.get(i).yPos >= player.yPos) {
      count++;
    }
  }
  return count;
}

void gameOver() {
  for (int i=0; i<enemyList.size(); i++) {
    if (platformsBelow() == 0 || player.enemyCollision(enemyList.get(i))) {
      gameOver = true;
    }
  }
}