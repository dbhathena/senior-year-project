/*
Air Hockey: A simple air hockey simulation with four
different levels of difficulty. 

Author: Darian Bhathena
Course: Period 1 AP CS, Dr. Miles
Due Date: 2016-06-02

Sources:
  Processing website (text, color, rectangle, keyboard/mouse interaction, buttons)
*/

HockeyTable table;
Puck puck;
Mallet player;
Mallet comp;
private enum Mode {NEW_GAME, CHOOSE_LEVEL, START_SCREEN, PLAY_GAME, PLAY_AGAIN_L, PLAY_AGAIN_W, PAUSED};
Mode mode;
int level = -1;

/*
Sets up a new game at the start of the program.
*/
void setup() {
  background(0);
  size(1000, 740);
  table = new HockeyTable(600, 340);
  puck = new Puck();
  player = new Mallet(false, table);
  comp = new Mallet(true, table);
  mode = Mode.NEW_GAME;
}


void draw() {
  background(0);
  switch (mode) {
    case NEW_GAME:
      cursor(ARROW);
      newGame();
      mousePressed = false;
      break;
    case CHOOSE_LEVEL:
      cursor(ARROW);
      chooseLevel();
      mousePressed = false;
      break;
    case START_SCREEN:
      cursor(ARROW);
      startScreen();
      mousePressed = false;
      break;
    case PLAY_GAME:
      noCursor();
      playGame();
      mousePressed = false;
      break;
    case PLAY_AGAIN_L:
      cursor(ARROW);
      playAgainScreenLost();
      mousePressed = false;
      break;
    case PLAY_AGAIN_W:
      cursor(ARROW);
      playAgainScreenWon();
      mousePressed = false;
      break;
    case PAUSED:
      cursor(ARROW);
      paused();
      mousePressed = false;
      break;
  }
}


/*
Displays the opening game screen.
*/
void newGame() {
  color red = color(255, 50, 50);
  color darkRed = color(170, 50, 50);
  color blue = color(30, 75, 200);
  noStroke();
  PFont font = loadFont("OCRAStd-90.vlw");
  textAlign(CENTER);
  textFont(font);
  fill(red);
  text("Air Hockey", width/2, height/3);
  rectMode(CENTER);
  fill(blue);
  stroke(255);
  strokeWeight(1);
  rect(width/2-200, height/2, 250, 50);
  rect(width/2+200, height/2, 250, 50);
  noStroke();
  textSize(35);
  if(overRect(width/2-200, height/2, 250, 50)) {
    fill(darkRed);
    text("New Game", width/2-200, height/2+15);
    fill(red);
    text("Quit", width/2+200, height/2+15);
    if (mousePressed) {
      mode = Mode.CHOOSE_LEVEL;
    }
  } else if(overRect(width/2+200, height/2, 250, 50)) {
    fill(darkRed);
    text("Quit", width/2+200, height/2+15);
    fill(red);
    text("New Game", width/2-200, height/2+15);
    if (mousePressed) {
      exit();
    }
  } else {
    fill(red);
    text("New Game", width/2-200, height/2+15);
    text("Quit", width/2+200, height/2+15);
  }
}


/*
Displays the screen for choosing a level.
*/
void chooseLevel() {
  color red = color(255, 50, 50);
  color darkRed = color(170, 50, 50);
  color blue = color(30, 75, 200);
  noStroke();
  PFont font = loadFont("OCRAStd-90.vlw");
  textAlign(CENTER);
  textFont(font);
  fill(red);
  text("Choose Level:", width/2, height/3);
  rectMode(CENTER);
  fill(blue);
  stroke(255);
  strokeWeight(1);
  rect(width/2-200, height/2, 250, 50);
  rect(width/2+200, height/2, 250, 50);
  rect(width/2-200, height/2+100, 250, 50);
  rect(width/2+200, height/2+100, 250, 50);
  noStroke();
  textSize(32);
  if(overRect(width/2-200, height/2, 250, 50)) {
    fill(darkRed);
    text("Easy", width/2-200, height/2+15);
    fill(red);
    text("Medium", width/2+200, height/2+15);
    text("Hard", width/2-200, height/2+115);
    text("Impossible", width/2+200, height/2+115);
    if (mousePressed) {
      comp.setLevelAndSpeed(0);
      mode = Mode.START_SCREEN;
    }
  } else if (overRect(width/2+200, height/2, 250, 50)) {
    fill(darkRed);
    text("Medium", width/2+200, height/2+15);
    fill(red);
    text("Easy", width/2-200, height/2+15);
    text("Hard", width/2-200, height/2+115);
    text("Impossible", width/2+200, height/2+115);
    if (mousePressed) {
      comp.setLevelAndSpeed(1);
      mode = Mode.START_SCREEN;
    }
  } else if (overRect(width/2-200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("Hard", width/2-200, height/2+115);
    fill(red);
    text("Easy", width/2-200, height/2+15);
    text("Medium", width/2+200, height/2+15);
    text("Impossible", width/2+200, height/2+115);
    if (mousePressed) {
      comp.setLevelAndSpeed(2);
      mode = Mode.START_SCREEN;
    }
  } else if (overRect(width/2+200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("Impossible", width/2+200, height/2+115);
    fill(red);
    text("Easy", width/2-200, height/2+15);
    text("Medium", width/2+200, height/2+15);
    text("Hard", width/2-200, height/2+115);
    if (mousePressed) {
      comp.setLevelAndSpeed(3);
      mode = Mode.START_SCREEN;
    }
  } else {
    fill(red);
    text("Easy", width/2-200, height/2+15);
    text("Medium", width/2+200, height/2+15);
    text("Hard", width/2-200, height/2+115);
    text("Impossible", width/2+200, height/2+115);
  }
}


/*
Displays the start screen, during which the 
player must click on their mallet to start the game.
*/
void startScreen() {
  table.drawTable();
  puck.display();
  table.drawGoals();
  player.display();
  comp.display();
  noStroke();
  textSize(23);
  PVector mouseLoc = new PVector(mouseX, mouseY);
  PVector playerLoc = player.getLocation();
  float distance = PVector.sub(mouseLoc, playerLoc).mag();
  if(distance <= player.getRadius()) {
    strokeWeight(1);
    stroke(0);
    fill(255);
    text("Click to\nStart", player.getLocation().x, player.getLocation().y - 125);
    triangle(player.getLocation().x-13, player.getLocation().y-85,
             player.getLocation().x+13, player.getLocation().y-85,
             player.getLocation().x, player.getLocation().y-40);
    if(mousePressed) {
      mode = Mode.PLAY_GAME;
    }
  } else {
    strokeWeight(1);
    stroke(0);
    fill(0);
    text("Click to\nStart", player.getLocation().x, player.getLocation().y - 125);
    triangle(player.getLocation().x-13, player.getLocation().y-85,
             player.getLocation().x+13, player.getLocation().y-85,
             player.getLocation().x, player.getLocation().y-40);
  }
}


void playGame() {
  table.drawTable();
  puck.move(table);
  puck.display();
  table.drawGoals();
  player.move(puck, table);
  player.display();
  comp.move(puck, table);
  comp.display();
  textSize(25);
  fill(255);
  text("Press 'p' to pause", width/2, height - 125);
  if (keyPressed && key == 'p') {
    mode = Mode.PAUSED;
  }
  if(table.getCompScore() == 7) {
    table.resetScores();
    player.resetPlayerLocation();
    mode = Mode.PLAY_AGAIN_L;
  } else if(table.getPlayerScore() == 7) {
    player.resetPlayerLocation();
    table.resetScores();
    mode = Mode.PLAY_AGAIN_W;
  }
}


/*
Displays the screen for when the player loses
(computer wins).
*/
void playAgainScreenLost() {
  strokeWeight(1);
  background(0);
  color red = color(255, 50, 50);
  color darkRed = color(170, 50, 50);
  color blue = color(30, 75, 200);
  noStroke();
  PFont font = loadFont("OCRAStd-90.vlw");
  textAlign(CENTER);
  textFont(font);
  fill(red);
  text("You Lose!", width/2, height/3);
  textSize(60);
  text("Play Again?", width/2, height/2);
  rectMode(CENTER);
  fill(blue);
  stroke(255);
  rect(width/2-200, height/2+100, 250, 50);
  rect(width/2+200, height/2+100, 250, 50);
  noStroke();
  textSize(35);
  if(overRect(width/2-200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("Yes", width/2-200, height/2+115);
    fill(red);
    text("No", width/2+200, height/2+115);
    if (mousePressed) {
      mode = Mode.CHOOSE_LEVEL;
    }
  } else if(overRect(width/2+200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("No", width/2+200, height/2+115);
    fill(red);
    text("Yes", width/2-200, height/2+115);
    if (mousePressed) {
      exit();
    }
  } else {
    fill(red);
    text("Yes", width/2-200, height/2+115);
    text("No", width/2+200, height/2+115);
  }
}


/*
Displays the screen for when the player wins.
*/
void playAgainScreenWon() {
  strokeWeight(1);
  background(0);
  color red = color(255, 50, 50);
  color darkRed = color(170, 50, 50);
  color blue = color(30, 75, 200);
  noStroke();
  PFont font = loadFont("OCRAStd-90.vlw");
  textAlign(CENTER);
  textFont(font);
  fill(red);
  text("You Win!", width/2, height/3);
  textSize(60);
  text("Play Again?", width/2, height/2);
  rectMode(CENTER);
  fill(blue);
  stroke(255);
  rect(width/2-200, height/2+100, 250, 50);
  rect(width/2+200, height/2+100, 250, 50);
  noStroke();
  textSize(35);
  if(overRect(width/2-200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("Yes", width/2-200, height/2+115);
    fill(red);
    text("No", width/2+200, height/2+115);
    if (mousePressed) {
      mode = Mode.CHOOSE_LEVEL;
    }
  } else if(overRect(width/2+200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("No", width/2+200, height/2+115);
    fill(red);
    text("Yes", width/2-200, height/2+115);
    if (mousePressed) {
      exit();
    }
  } else {
    fill(red);
    text("Yes", width/2-200, height/2+115);
    text("No", width/2+200, height/2+115);
  }
}


/*
Displays the pause screen.
*/
void paused() {
  strokeWeight(1);
  background(0);
  color red = color(255, 50, 50);
  color darkRed = color(170, 50, 50);
  color blue = color(30, 75, 200);
  noStroke();
  PFont font = loadFont("OCRAStd-90.vlw");
  textAlign(CENTER);
  textFont(font);
  fill(red);
  text("Paused", width/2, height/3);
  rectMode(CENTER);
  fill(blue);
  stroke(255);
  rect(width/2-200, height/2+100, 250, 50);
  rect(width/2+200, height/2+100, 250, 50);
  noStroke();
  textSize(35);
  if(overRect(width/2-200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("Continue", width/2-200, height/2+115);
    fill(red);
    text("Quit Game", width/2+200, height/2+115);
    if (mousePressed) {
      mode = Mode.PLAY_GAME;
    }
  } else if(overRect(width/2+200, height/2+100, 250, 50)) {
    fill(darkRed);
    text("Quit Game", width/2+200, height/2+115);
    fill(red);
    text("Continue", width/2-200, height/2+115);
    if (mousePressed) {
      player.resetPlayerLocation();
      table.resetScores();
      mode = Mode.NEW_GAME;
    }
  } else {
    fill(red);
    text("Continue", width/2-200, height/2+115);
    text("Quit Game", width/2+200, height/2+115);
  }
}


/*
Tests to see if the mouse cursor is hovering over
a particular rectangle with location (x,y) and 
dimensions w and h.
*/
boolean overRect(int x, int y, int w, int h)  {
  if (mouseX >= x-w/2 && mouseX <= x+w/2 && 
      mouseY >= y-h/2 && mouseY <= y+h/2) {
    return true;
  } else {
    return false;
  }
}