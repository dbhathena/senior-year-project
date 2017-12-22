class Ball {
  
  private PVector location;
  private PVector velocity;
  private int radius;
  
  Ball() {
    radius = (int)(random(10, 40));
    location = new PVector(mouseX, mouseY);
    velocity = new PVector((random(-4, 4)), (random(-4, 4)));
  }
  
  void move() {
    location.add(velocity);
    
    if((location.x > width-radius)) {
      velocity.x = abs(velocity.x)*-1;
    }
    if((location.x < radius)) {
      velocity.x = abs(velocity.x);
    }
    if((location.y > height-radius)) {
      velocity.y = abs(velocity.y)*-1;
    }
    if((location.y < radius)) {
      velocity.y = abs(velocity.y);
    }
  }
 
  void display() {
    ellipse(location.x, location.y, radius*2, radius*2);
  }
  
  int getRadius() {
    return radius;
  }
}