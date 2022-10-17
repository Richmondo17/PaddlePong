float pOneY = 250; //stores the y-value for player one's paddle
float pTwoY = 250; //stores the y-value for player two's paddle
float padHeight = 100; //paddle height

float ballX = 400; //inital x-position for ball
float ballY = 300; //initial y-position for ball
float radius = 10; //radius of ball

float xRandom = random(1)>0.5?-4:4; //chooses a random value, either -4 or 4
float yRandom1 = random(-10, -3); //chooses a random value between -10 and -3, and -3 is not inclusive
float yRandom2 = random(10, 3); //chooses a random value between 10 and 3, and 3 is not inclusive
float xSpeed = xRandom; //sets the random value for x equal to the x-value velocity of the ball
float ySpeed = random(1)>0.5?yRandom1:yRandom2; //chooses a random value for the y-value velocity of the ball

int pOneLives = 2; //initial number of lives for player one
int pTwoLives = 2; //initial number of lives for player two
float gOverX = 800; //x-value of size of the rectangle used to cover screen when game is over
float gOverY = 600; //y-value of size of the rectangle used to cover screen when game is over

String gameOverText = "GAME OVER"; //displays game over text on screen when game is over
String gWinP1 = "PLAYER ONE WINS!"; //displays the text when player one wins
String gWinP2 = "PLAYER TWO WINS!"; //displays the text when player two wins

boolean moveBall = false; //if this boolean is true, then ball will move 
boolean roundOver = false; //is true when number of lives decrements, and when number of lives is less then 1

//arrays for x and y coordinates
float[] x = new float[20];
float[] y = new float[20];

void setup() {
  size(800, 600); //size of canvas
  noStroke();
  //this loops through the array length, and draws 20 balls in the center of the canvas
  for (int i = 0; i<x.length; i++) {
    circle(x[0], y[0], 20-i);
  }
}

void draw() {
  background(0);
  //paddles
  fill(255); 
  rect(0, pOneY, 20, 100);
  rect(780, pTwoY, 20, 100);
  //sets the x and y values from the array for the circle coordinates
  circle(x[0], y[0], 20);

  //displays the score on the screen
  text();

  if (key == 't' || key == 'T') { // starts the game
    moveBall = true; //moveBall boolean is set to true
  }

  //condition allows for the ball to move with velocity
  if (moveBall == true) {
    //controls velocity of the ball
    ballX+=xSpeed; 
    ballY+=ySpeed;
  }

  //this array rotates to the right
  for (int i =0; i<x.length-1; i++) {
    //the previous element now takes the position of the i+1 element for both arrays
    x[x.length-1-i] = x[x.length-2-i]; 
    y[y.length-1-i] = y[y.length-2-i];
    fill(255, 255, 255, 100-i);
    circle(x[i], y[i], 20-i);
  }
  x[0]=ballX; //sets the new first value to the x-value position of the ball
  y[0]=ballY; //sets the new first value to the y-value position of the ball  

  //bounce ball on top and bottom of canvas
  topBottom();  
  //bounce ball off the paddles
  leftRight();
  //moves the paddles up and down
  movePaddle();

//if the ball goes past the left paddle then the following will occur
  if (outOfBoundsLeft()) { 
    if (keyPressed && key == 'c' || key == 'C') {
      ballX = 30; //set the ball position to the x position of the left paddle
      ballY = pOneY+50; //set the ball position to the middle of the left paddle
      moveBall = true; //allows ball to move
      pOneLives--; //number of lives for player one is decremented if ball passes the left paddle
    }
  } else if (outOfBoundsRight()) {
    //if the ball goes past the right paddle then the following will occur
    if (keyPressed && key == 'c' || key == 'C') {
      ballX = 770; //set the ball position to the x position of the right paddle
      ballY = pTwoY+50; //set the ball position to the middle of the right paddle
      moveBall = true; //allows ball to move
      pTwoLives--; //number of lives for player two is decremented if ball passes the right paddle
    }
  }
  
  //if player one lives is less than 1, then the game is over
  if (pOneLives<1) {
    gameOverOne();
    roundOver = true;
  } else if (pTwoLives<1) {
    //if player two lives is less than 1, then the game is over
    gameOverTwo();
    roundOver = true;
  }

  if (roundOver == true) {
    if (key == 'n' || key == 'N') {
      background(0); //if n or N is pressed
      gOverX = 0; //the rectangle that covers the screen when the game is over
      gOverY = 0; // will have a width and height of 0
      pOneLives = 2; //player one lives reset to 2
      pTwoLives = 2; //player two lives reset to 2
      ballX = 400; //reset x-value of ball at the center of the canvas
      ballY = 300; //reset y-value of ball at the center of the canvas 
      pOneY = 250; //reset the y-value of the paddles
      pTwoY = 250; //at the original positon

      gameOverText = " "; //erase game over text
      gWinP1 = " "; //erase player one wins
      gWinP2 = " "; //erase player two wins

      //positions ball at the center of canvas
      fill(255); 
      rect(0, pOneY, 20, 100); //reset paddles at original position
      rect(780, pTwoY, 20, 100); //when game started
      circle(x[0], y[0], 20); //ball is at original position 

      //displays a game over screen
      gameOverAgain();
    }
  }

//resets game when key is pressed
  if (key == 'n' || key == 'N') {
    ballX = 400; 
    ballY = 300;
    pOneY = 250;
    pTwoY = 250;
  }
}

//method for ball to bounce off top or bottom of canvas
void topBottom() {
  //draws borders
  rect(0, 35, 800, 2);
  rect(0, 550, 800, 2);

  //Bouncing ball off of the top
  if (ballY-radius<35) {
    ySpeed = 4;
  }
  //Bouncing ball off of the bottom
  if (ballY+radius>550) {
    ySpeed = -4;
  }
}

//after game is over once, this method makes sure
//that gameOverOne() and gameOverTwo() work again
void gameOverAgain() {
  gOverX = 800; 
  gOverY = 600;
  gameOverText = "GAME OVER";
  gWinP1 = "PLAYER ONE WINS!";
  gWinP2 = "PLAYER TWO WINS!";

  if (pOneLives<1) {  
    gameOverOne();
    roundOver = true;
  } else if (pTwoLives<1) {
    gameOverTwo();
    roundOver = true;
  }
}

//method to bounce ball off the left and right paddles
void leftRight() {
  if (xSpeed<0) {
    if (ballY+radius>pOneY && ballY<pOneY+padHeight) { 
      if (ballX-radius<20 && ballX+radius>15) {
        xSpeed = 4;
      }
    }
  }
  if (xSpeed>0) {
    if (ballY+radius>pTwoY && ballY<pTwoY+padHeight) {
      if (ballX+radius>780 && ballX-radius<775) {
        xSpeed =-4;
      }
    }
  }
}

//method for when player one loses
void gameOverOne() {
  fill(0);
  rect(0, 0, gOverX, gOverY);
  fill(255, 0, 0);
  textSize(70);
  text(gameOverText, 190, 250);
  text(gWinP2, 100, 400);
}

//method for when player two loses
void gameOverTwo() {
  fill(0);
  rect(0, 0, gOverX, gOverY);
  fill(255, 0, 0);
  textSize(70);
  text(gameOverText, 190, 250);
  text(gWinP1, 100, 400);
}

//boolean method for when the ball goes out of 
//bounds on the left side
boolean outOfBoundsLeft() {
  boolean oob1 = false;
  if (ballX-radius<0) {
    oob1 = true;
  }
  return oob1;
}

//boolean method for when the ball goes out of
//bounds on the right side
boolean outOfBoundsRight() {
  boolean oob2 = false;
  if (ballX+radius>800) {
    oob2 = true;
  }
  return oob2;
}

//method that displays the player lives
void text() {  
  textSize(20); 
  text("PLAYER ONE LIVES: " + pOneLives, 10, 30);
  text("PLAYER TWO LIVES: " + pTwoLives, 550, 570);
}

//method that allows for the left and right paddles to move up and down
void movePaddle() {
  if (keyPressed && (key == 'w' || key == 'W')) {
    //if w or W is pressed, then the left paddle will go up by 5 units
    fill(255); 
    rect(0, pOneY, 20, 100); 
    if (pOneY<=35) {
      pOneY-=0;
    } else {
      pOneY-=5;
    }
  } else if (keyPressed && (key == 's' || key == 'S')) {
    //if s or S is pressed, then the left paddle will go down by 5 units
    fill(255);
    rect(0, pOneY, 20, 100);
    if (pOneY>=450) {
      pOneY+=0;
    } else {
      pOneY+=5;
    }
  }

  if (keyPressed && (key == 'i' || key == 'I')) {
    //if i or I is pressed, then the right paddle will go up by 5 units
    fill(255);
    rect(780, pTwoY, 20, 100);
    if (pTwoY<=35) {
      pTwoY-=0;
    } else {
      pTwoY-=5;
    }
  } else if (keyPressed && (key == 'k' || key == 'K')) {
    //if k or K is pressed, then the right paddle will go down by 5 units
    fill(255);
    rect(780, pTwoY, 20, 100);
    if (pTwoY>=450) {
      pTwoY+=0;
    } else {
      pTwoY+=5;
    }
  }
}
