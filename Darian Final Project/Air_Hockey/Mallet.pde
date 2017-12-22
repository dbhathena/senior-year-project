/*
Mallet: The object that either the computer or
the player uses to control and hit the puck.

Author: Darian Bhathena
Course: Period 1 AP CS, Dr. Miles
Due Date: 2016-06-02

Sources:
  Processing website (PVector)
*/

class Mallet {
  
  private PVector location;
  private PVector velocity;
  private boolean isComputer;
  private int level;
  private int speed;
  private final int radius = 20;
  private final int borderWeight = 8;
  private final float mass;
  
  
  /*
  Creates a mallet object, designated either computer- or human-controlled
  */
  Mallet(boolean isComp, HockeyTable table) {
    if (isComp) {
      location = new PVector(width/2 + table.getWidth()/2 - 100, height/2);
      mass = 0.8;
    } else {
      location = new PVector(width/2 - table.getWidth()/2 + 100, height/2);
      mass = 0.5;
    }
    velocity = new PVector();
    isComputer = isComp;
  }
  
  
  /*
  Defines the mallet's movement: if computer-controlled,
  usually makes the mallet move toward the puck. If
  human-controlled, corresponds to mouse location.
  */
  void move(Puck puck, HockeyTable table) {
    if(isComputer) {
      if(!puck.hasJustCollided() && puck.getLocation().x > width/2) {
        if(puck.getLocation().y > height/2 - table.getHeight()/3 || puck.getLocation().y < height/2 + table.getHeight()/3) {
          velocity = PVector.sub(puck.getLocation(), location);
          velocity.setMag(speed);
        }
      } else {
        goHomeComp();
      }
      location.add(velocity);
      
      int buffer = (table.getWeight()+borderWeight)/2;
      location.x = constrain(location.x, (width/2)+radius+(borderWeight/2)+2, (width/2)+(table.getWidth()/2)-radius-buffer);
      location.y = constrain(location.y, (height/2)-(table.getHeight()), (height/2)+(table.getHeight()));
    } else {
      location.x = mouseX;
      location.y = mouseY;
      velocity.x = mouseX-pmouseX;
      velocity.y = mouseY-pmouseY;
      
      int buffer = (table.getWeight()+borderWeight)/2;
      location.x = constrain(location.x, (width/2)-(table.getWidth()/2)+radius+buffer, (width/2)-(borderWeight/2)-radius-2);
      location.y = constrain(location.y, (height/2)-(table.getHeight()/2)+radius+buffer, (height/2)+(table.getHeight()/2)-radius-buffer);
    }
  }
  
  
  /*
  Directs this mallet to move towards the computer-
  controlled mallet's starting spot (only implemented
  if this mallet is a computer-controlled mallet).
  */
  void goHomeComp() {
    if(!(location.x < width/2 + table.getWidth()/2 - 100 + speed/2 && location.x > width/2 + table.getWidth()/2 - 100 - speed/2 && 
        location.y < height/2 + speed/2 && location.y > height/2 - speed/2)) {
      PVector reset = new PVector(width/2 + table.getWidth()/2 - 100, height/2);
      velocity = PVector.sub(reset, location);
      velocity.setMag(speed/2);
    } else {
      velocity.x = 0;
      velocity.y = 0;
    }
  }
  
  
  void display() {
    strokeWeight(borderWeight);
    stroke(230, 230, 150);
    fill(120, 90, 50);
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  
  
  void setVelocity(float x, float y) {
    velocity.x = x;
    velocity.y = y;
  }
  
  
  void setLevelAndSpeed(int lvl) {
    level = lvl;
    if(level == 0) {
      speed = 2;
    } else if(level == 1) {
      speed = 6;
    } else if(level == 2) {
      speed = 9;
    } else if(level == 3) {
      speed = 15;
    }
  }
  
  
  void resetPlayerLocation() {
    location.x = width/2 - table.getWidth()/2 + 100;
    location.y = height/2;
  }
  
  
  PVector getLocation() {
    return location;
  }
  
  
  PVector getVelocity() {
    return velocity;
  }
  
  
  float getMass() {
    return mass;
  }
  
  
  int getRadius() {
    return radius;
  }
  
  
  int getBorderWeight() {
    return borderWeight;
  }
}