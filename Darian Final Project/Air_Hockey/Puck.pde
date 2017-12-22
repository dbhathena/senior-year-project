/*
Puck: the air hockey puck.

Author: Darian Bhathena
Course: Period 1 AP CS, Dr. Miles
Due Date: 2016-06-02

Sources:
  Processing website (PVector, Sound, Bouncing circles)
  Java Methods Student Files, Ch. 16 (for sound "goal.wav")
  http://www.hoomanr.com/Demos/Elastic2/ (two circles colliding)
  http://soundbible.com/1747-Hockey-Stick-Slap-2.html (for sound "side.wav")
*/

import processing.sound.*;

class Puck {
  
  private PVector location;
  private PVector velocity;
  private SoundFile side = new SoundFile(Air_Hockey.this, "side.wav");
  private SoundFile goal = new SoundFile(Air_Hockey.this, "goal.wav");
  private final int radius = 17;
  private final int borderWeight = 4;
  private final float friction = 0.75;
  private final float mass = 0.2;
  boolean justCollided = false;
  
  
  /*
  Creates puck object.
  */
  Puck() {
    location = new PVector(width/2 - table.getWidth()/4 + 20, height/2);
    velocity = new PVector(0, 0);
  }
  
  
  /*
  Controls movement of puck, including collisions
  with walls or mallets.
  */
  void move(HockeyTable table) {
    velocity.setMag(constrain(velocity.mag(), 0, 12));
    location.add(velocity);
    int buffer = (table.getWeight()+borderWeight)/2;
    location.y = constrain(location.y, (height/2)-(table.getHeight()/2)+radius+buffer-2, (height/2)+(table.getHeight()/2)-radius-buffer+2);
    if (location.y < height/2-60 || location.y > height/2+60) {
      location.x = constrain(location.x, (width/2)-(table.getWidth()/2)+radius+buffer-2, (width/2)+(table.getWidth()/2)-radius-buffer+2);
    }
    checkCollisionMallet(comp);
    checkCollisionMallet(player);
    checkCollisionWall(table);
  }
  
  
  /*
  Makes the puck bounce off walls.
  */
  void checkCollisionWall(HockeyTable table) {
    int buffer = (table.getWeight()+borderWeight)/2 + radius;
    float minX = (width/2)-(table.getWidth()/2)+buffer;
    float maxX = (width/2)+(table.getWidth()/2)-buffer;
    float minY = (height/2)-(table.getHeight()/2)+buffer;
    float maxY = (height/2)+(table.getHeight()/2)-buffer;
    if(location.x < minX) {
      if (location.y < (height/2)-60 || location.y > (height/2)+60) {
        float distance = minX - location.x;
        location.x += (distance*2);
        velocity.x = abs(velocity.x)*friction;
        side.play();
      } else if (location.x < (width/2) - (table.getWidth()/2)-radius) {
        location = new PVector(width/2 - table.getWidth()/4 + 20, height/2);
        velocity = new PVector(0, 0);
        goal.play();
        table.compScored();
        comp.location.x = width/2 + table.getWidth()/2 - 100;
        comp.location.y = height/2;
      }
    } else if(location.x > maxX) {
      if (location.y < (height/2)-60 || location.y > (height/2) + 60) {
        float distance = location.x - maxX;
        location.x -= (distance*2);
        velocity.x = abs(velocity.x)*friction*-1;
        side.play();
      } else if (location.x > (width/2)+(table.getWidth()/2)+radius) {
        location = new PVector(width/2 + table.getWidth()/4 - 20, height/2);
        velocity = new PVector(0, 0);
        goal.play();
        table.playerScored();
        comp.location.x = width/2 + table.getWidth()/2 - 100;
        comp.location.y = height/2;
      }
    }
    if(location.y < minY) {
      float distance = minY - location.y;
      location.y += (distance*2);
      velocity.y = abs(velocity.y)*friction;
      side.play();
    } else if(location.y > maxY) {
      float distance = location.y - maxY;
      location.y -= (distance*2);
      velocity.y = abs(velocity.y)*friction*-1;
      side.play();
    }
  }
  
  
  /*
  Makes the puck bounce off mallets.
  
  (This is where information found at
  http://www.hoomanr.com/Demos/Elastic2/ is used).
  */
  void checkCollisionMallet(Mallet mallet) {
    PVector d = PVector.sub(mallet.location, this.location);
    float distance = d.mag();
    if (!isInCorner() && distance < this.radius + mallet.radius+mallet.getBorderWeight()) {
      side.play();
      float A = atan2(this.location.y-mallet.location.y, this.location.x-mallet.location.x);
      float u1 = this.velocity.mag();
      float u2 = mallet.velocity.mag();
      float v1x = u1*cos(this.velocity.heading()-A);
      float v1y = u1*sin(this.velocity.heading()-A);
      float v2x = u2*cos(mallet.velocity.heading()-A);
      float f1x = (v1x * (this.mass-mallet.mass) + 2*mallet.mass*v2x) / (mallet.mass + this.mass);
      float puckFinalVelocity = sqrt(f1x*f1x + v1y*v1y);
      float puckFinalDirection = atan2(v1y, f1x) + A;
      velocity.x = puckFinalVelocity * cos(puckFinalDirection);
      velocity.y = puckFinalVelocity * sin(puckFinalDirection);
      location.add(velocity);
      if (!isInCorner() && distance < this.radius + mallet.radius+mallet.getBorderWeight()+borderWeight) {
        PVector quickMove = new PVector(velocity.x, velocity.y);
        quickMove.setMag(this.radius + mallet.radius+mallet.getBorderWeight()-distance);
        quickMove.setMag(constrain(quickMove.mag(), 0, 12));
        location.add(quickMove);
      }
      justCollided = true;
    }
    if (distance > this.radius + mallet.radius + mallet.getBorderWeight()+borderWeight+20) {
      justCollided = false;
    }
  }
  
  
  void display() {
    strokeWeight(borderWeight);
    stroke(165, 45, 40);
    fill(250, 70, 60);
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  
  
  void setVelocity(PVector v) {
    velocity.x = v.x;
    velocity.y = v.y;
  }
  
  
  /*
  Checks whether the puck is in a corner of the table.
  */
  boolean isInCorner() {
    int buffer = borderWeight + table.getWeight();
    float xMin = width/2 - table.getWidth()/2 + radius + buffer;
    float xMax = width/2 + table.getWidth()/2 - radius - buffer;
    float yMin = height/2 - table.getHeight()/2 + radius + buffer;
    float yMax = height/2 + table.getHeight()/2 - radius - buffer;
    return (location.x <= xMin+10 && location.y <= yMin+10)
        || (location.x >= xMax-10 && location.y >= yMax-10)
        || (location.x <= xMin+10 && location.y >= yMax-10)
        || (location.x >= xMax-10 && location.y <= yMin+10);
  }
  
  
  boolean hasJustCollided() {
    return justCollided;
  }
  
  
  PVector getLocation() {
    return location;
  }
  
  
  int getRadius() {
    return radius;
  }
}