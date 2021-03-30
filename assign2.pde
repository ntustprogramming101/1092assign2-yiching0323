PImage bg, groundhogIdle, groundhogDown, groundhogLeft, groundhogRight, life, soil, soldier, cabbage;
PImage startTitle, startNormal, startHovered, restartNormal, restartHovered, gameover;

final int GAME_START = 0;
final int GAME_RUN = 1;
final int GAME_OVER = 2;
int gameState = GAME_START;


final int BUTTON_TOP = 360;
final int BUTTON_BOTTOM = 420;
final int BUTTON_LEFT = 248;
final int BUTTON_RIGHT = 392;

float groundhogX = 320;
float groundhogY = 80;
float groundhogSpeed = 4;
float groundhogWidth = 80;
float groundhogHeight = 80;

int down = 0;
int right = 0;
int left = 0;
float step = 80.0;
int frames = 15;

int soldierX;
int soldierY;
float soldierXSpeed = 5;

int cabbageX;
int cabbageY;

int HP = 2;

boolean rightPressed = false;
boolean downPressed  = false;
boolean leftPressed  = false;
boolean upPressed  = false;



void setup() {

  size(640, 480, P2D);
  bg = loadImage("img/bg.jpg");
  startTitle = loadImage("img/title.jpg");
  startNormal = loadImage("img/startNormal.png");
  startHovered = loadImage("img/startHovered.png");
  restartNormal = loadImage("img/restartNormal.png");
  restartHovered = loadImage("img/restartHovered.png");
  gameover = loadImage("img/gameover.jpg");
  cabbage = loadImage("img/cabbage.png");
  groundhogIdle = loadImage("img/groundhogIdle.png");
  groundhogDown = loadImage("img/groundhogDown.png");
  groundhogLeft = loadImage("img/groundhogLeft.png");
  groundhogRight = loadImage("img/groundhogRight.png");
  life = loadImage("img/life.png");
  soil = loadImage("img/soil.png");
  soldier = loadImage("img/soldier.png");

  //soldierPosition
  soldierX = -80;
  soldierY = floor(random(2, 6))*80;
  soldierXSpeed = 5;

  //cabbagePosition
  cabbageX = floor(random(0, 8))*80;
  cabbageY = floor(random(2, 6))*80;
}

void draw() {

  switch(gameState) {

  case GAME_START:  
    background(startTitle);
    if (mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
      && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM) {
      image(startHovered, 248, 360);
      if (mousePressed) {
        gameState = GAME_RUN;
      }
    } else {
      image(startNormal, 248, 360);
    }
    break;

  case GAME_RUN:
    background(bg);
    image(soil, 0, 160); //soil

    //grass
    noStroke();
    fill(124, 204, 25);
    rect(0, 145, 640, 15); 

    //sun
    ellipseMode(CENTER);
    fill(255, 255, 0);
    ellipse(590, 50, 125, 125);
    fill(253, 184, 19);
    ellipse(590, 50, 120, 120); 

    //groundhog move
    //down
    if (down > 0) {
      if (down == 1) {
        groundhogY = round(groundhogY + step/frames);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogY = groundhogY + step/frames;
        image(groundhogDown, groundhogX, groundhogY);
      }
      down -=1;
    }

    //left
    if (left > 0) {
      if (left == 1) {
        groundhogX = round(groundhogX - step/frames);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX - step/frames;
        image(groundhogLeft, groundhogX, groundhogY);
      }
      left -=1;
    }

    //right
    if (right > 0) {
      if (right == 1) {
        groundhogX = round(groundhogX + step/frames);
        image(groundhogIdle, groundhogX, groundhogY);
      } else {
        groundhogX = groundhogX + step/frames;
        image(groundhogRight, groundhogX, groundhogY);
      }
      right -=1;
    }

    //no move
    if (down == 0 && left == 0 && right == 0 ) {
      image(groundhogIdle, groundhogX, groundhogY);
    }

    //life
    for (int x = 0; x < HP; x ++) {
      pushMatrix();
      translate(x*70, 0);
      image(life, 10, 10);
      popMatrix();
    }

    //soldierMove
    image(soldier, soldierX, soldierY);
    soldierX += soldierXSpeed;
    if (soldierX>=640) {
      soldierX = -80;
    }

    //soldierDetect
    if (groundhogX < soldierX + 80 && groundhogX + 80 > soldierX && groundhogY < soldierY + 80 && groundhogY + 80 > soldierY) {
      groundhogX = 320;
      groundhogY = 80;
      HP -= 1;
      down = 0;
      left = 0;
      right = 0;
    }

    //cabbage
    image(cabbage, cabbageX, cabbageY);
    if (groundhogX < cabbageX + 80 && groundhogX + 80 > cabbageX && groundhogY < cabbageY + 80 && groundhogY + 80 > cabbageY) {
      cabbageX = -80;
      cabbageY = 0;
      HP +=1 ;
    }
    
    //gameOver
    if (HP==0) {
      gameState=GAME_OVER;
    }

    break;

  case GAME_OVER:
    background(gameover);
    if (mouseX > BUTTON_LEFT && mouseX < BUTTON_RIGHT
      && mouseY > BUTTON_TOP && mouseY < BUTTON_BOTTOM) {
      image(restartHovered, 248, 360);
      if (mousePressed) {
        gameState = GAME_RUN;
        soldierY = floor(random(2, 6)) * 80;//reset
        soldierX = - 80;
        cabbageX = floor(random(0, 8)) * 80;
        cabbageY = floor(random(2, 6)) * 80;
        down = 0;
        left = 0;
        right = 0;
        HP=2;
      }
    } else {
      image(restartNormal, 248, 360);
    }

    break;
  }
}


void keyPressed() {  
  //groundhogMoveLock
  if (down>0 || left>0 || right>0) {
    return;
  }
  if (key == CODED) {
    switch(keyCode) {
    case DOWN:
      if (groundhogY < 400) {
        downPressed = true;
        down = 15;
      }
      break;
    case LEFT:
      if (groundhogX > 0) {
        leftPressed = true;
        left = 15;
      }
      break;
    case RIGHT:
      if (groundhogX < 560) {
        rightPressed = true;
        right = 15;
      }
      break;
    }
  }
}

void keyReleased() {
  if (key == CODED) {
    switch(keyCode) {
    case DOWN:
      downPressed = false;
      break;
    case LEFT:
      leftPressed = false;
      break;
    case RIGHT:
      rightPressed = false;
      break;
    }
  }
}
