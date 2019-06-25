class Bullet {
 float xPos, yPos;
 float bulletRadius = 5;
 float yVel = 8;
 
 Bullet(float _xPos, float _yPos) {
   xPos = _xPos;
   yPos = _yPos;
 }
 
 void display() {
   fill(0);
   ellipse(xPos, yPos, bulletRadius*2, bulletRadius*2);
 }
 
 void move() {
   yPos -= yVel;
 }
 
 boolean enemyCollision(Enemy enemy) {
   if(xPos >= (enemy.xPos-(enemy.enemyWidth/2)) && xPos <= (enemy.xPos+(enemy.enemyWidth/2)) && yPos <= enemy.yPos+(enemy.enemyHeight/2)) {
     return true;
   }
   return false;
 }
}