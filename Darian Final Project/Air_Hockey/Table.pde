/*
Table: defines the table on which the air hockey
game is played.

Author: Darian Bhathena
Course: Period 1 AP CS, Dr. Miles
Due Date: 2016-06-02
*/

class HockeyTable {
  private int tWidth;
  private int tHeight;
  private int xCenter = width/2;
  private int yCenter = height/2;
  private final int borderStrokeWeight = 10;
  private int playerScore;
  private int compScore;
  
  /*
  Creates a hockey table object with the given dimensions.
  */
  HockeyTable(int w, int h) {
    tWidth = w;
    tHeight = h;
    playerScore = 0;
    compScore = 0;
  }
  
  
  /*
  Draws and displays the table.
  */
  void drawTable() {
    rectMode(CENTER);
    noStroke();
    fill(30, 75, 200);
    rect(xCenter, yCenter, tWidth, tHeight); //table (blue)
    fill(255);
    rect(xCenter, yCenter, 4, tHeight); //middle line (white)
    stroke(255);
    strokeWeight(4);
    noFill();
    ellipse(xCenter, yCenter, 100, 100); //middle circle (white)
    arc(xCenter-300, yCenter, 120, 120, -PI/2, PI/2); //left side arc (white)
    arc(xCenter+300, yCenter, 120, 120, PI/2, 3*PI/2); //right side arc (white)
    noStroke();
    fill(255, 50, 50);
    PFont font = loadFont("OCRAStd-90.vlw");
    textAlign(CENTER);
    textFont(font);
    textSize(100);
    text(playerScore, xCenter-tWidth/4, (height-tHeight)/4+30);
    text(compScore, xCenter+tWidth/4, (height-tHeight)/4+30);
  }
  
  
  /*
  Draws and displays the goals.
  */
  void drawGoals() {
    noStroke();
    fill(0);
    rectMode(CENTER);
    rect(xCenter-tWidth/2, yCenter, borderStrokeWeight, 100);
    rect(xCenter+tWidth/2, yCenter, borderStrokeWeight, 100);
    rect(xCenter-tWidth/2-50-borderStrokeWeight/2, yCenter, 100, tHeight);
    rect(xCenter+tWidth/2+50+borderStrokeWeight/2, yCenter, 100, tHeight);
    fill(150);
    rect(xCenter-tWidth/2, yCenter-tHeight/2+60, borderStrokeWeight, 120);
    rect(xCenter-tWidth/2, yCenter+tHeight/2-60, borderStrokeWeight, 120);
    rect(xCenter+tWidth/2, yCenter-tHeight/2+60, borderStrokeWeight, 120);
    rect(xCenter+tWidth/2, yCenter+tHeight/2-60, borderStrokeWeight, 120);
    rect(xCenter, yCenter-tHeight/2, tWidth+borderStrokeWeight, borderStrokeWeight);
    rect(xCenter, yCenter+tHeight/2, tWidth+borderStrokeWeight, borderStrokeWeight);
  }
  
  
  void playerScored() {
    playerScore++;
  }
  
  
  void compScored() {
    compScore++;
  }
  
  
  int getPlayerScore() {
    return playerScore;
  }
  
  
  int getCompScore() {
    return compScore;
  }
  
  
  void resetScores() {
    playerScore = 0;
    compScore = 0;
  }
  
  
  int getWidth() {
    return tWidth;
  }
  
  
  int getHeight() {
    return tHeight;
  }
  
  
  int getWeight() {
    return borderStrokeWeight;
  }
}