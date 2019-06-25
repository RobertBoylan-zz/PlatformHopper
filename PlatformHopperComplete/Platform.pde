class Platform {
  float xPos, yPos;
  float platformWidth = 120;
  float platformHeight = 40;
  float yVel = 1;
  float red, green, blue;

  Platform(float _xPos, float _yPos) {
    xPos = _xPos;
    yPos = _yPos;
    red = random(0,255);
    green = random(0,255);
    blue = random(0,255);
  }
  
  void display() {
    rectMode(CENTER);
    noStroke();
    fill(red, green, blue);
    rect(xPos, yPos, platformWidth, platformHeight, 50);
  }
  
  void move() {
    yPos += yVel;
  }
}