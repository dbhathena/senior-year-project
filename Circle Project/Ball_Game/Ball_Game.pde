/*
Ball_Game: Creates a new, randomly colored, randomly sized
ball that moves randomly and bounces off the wall when a user clicks;
removes a ball when a user clicks on it while holding the "shift" key.

Authors: Darian Bhathena and Alisa Bhakta
Course: Period 1 AP CS, Dr. Miles
Due Date: 2016-05-16
*/

import java.util.List;
import java.util.ArrayList;
import processing.sound.*;

List<Ball> balls;

void setup() {
  noStroke();
  size(880, 660);
  balls = new ArrayList<Ball>();
}

void draw() {
  background(255);
  for (Ball b : balls) {
    b.move();
    b.display();
  }
}
  
/*
Adds a new Ball to the window under normal conditions;
Deletes a Ball when "shift" is held and the Ball is clicked.
*/
void mousePressed() {
  if (keyPressed && key == CODED && keyCode == SHIFT) {
   for (int i = balls.size() - 1; i >= 0; i--) {
    Ball b = balls.get(i);
    if (dist(mouseX, mouseY, b.location.x, b.location.y) <= b.getRadius()) {
      balls.remove(i);
      break;
    }
   }  
  } else {
    balls.add(new Ball());
  }
}

/*
Defines the Ball object.
*/
class Ball {
  
  private PVector location;
  private PVector velocity;
  private int radius;
  private int r, g, b;
  private SoundFile sound = new SoundFile(Ball_Game.this, "../bzz.wav");
  
  /*
  Creates a new Ball at the mouse's location
  with random color, size, and velocity.
  */
  Ball() {
    radius = (int)(random(10, 40));
    r = (int)(random(240));
    g = (int)(random(240));
    b = (int)(random(240));
    location = new PVector(mouseX, mouseY);
    velocity = new PVector((random(-4, 4)), (random(-4, 4)));
  }
  
  /*
  Defines a Ball's movement on the screen
  */
  void move() {
    location.add(velocity);
    
    if((location.x > width-radius)) {
      sound.play();
      velocity.x = abs(velocity.x)*-1;
    }
    if((location.x < radius)) {
      sound.play();
      velocity.x = abs(velocity.x);
    }
    if((location.y > height-radius)) {
      sound.play();
      velocity.y = abs(velocity.y)*-1;
    }
    if((location.y < radius)) {
      sound.play();
      velocity.y = abs(velocity.y);
    }
  }
 
  void display() {
    noStroke();
    fill(r, g, b);
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  
  int getRadius() {
    return radius;
  }
}