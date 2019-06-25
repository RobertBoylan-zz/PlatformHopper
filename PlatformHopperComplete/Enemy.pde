class Enemy {
 float xPos, yPos;
 float yVel;
 
 int enemyWidth = 80; 
 int enemyHeight = 100;
 
 PImage enemyImage;
 
 Enemy(Platform p) {
    xPos = p.xPos;
    yPos = p.yPos - p.platformHeight/2 - enemyHeight/2;
    
    yVel = p.yVel;
  }
  
  void loadEnemyImage() {
    enemyImage = loadImage("Alien.png");
  }
  
  void display() {
      image(enemyImage, xPos, yPos, enemyWidth, enemyHeight);
  }
  void move() {
    yPos += yVel;
  }
}