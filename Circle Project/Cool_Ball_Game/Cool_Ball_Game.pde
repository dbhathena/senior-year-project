import java.util.List;
import java.util.ArrayList;

List<Ball> balls;

void setup() {
  background(0);
  size(880, 660);
  balls = new ArrayList<Ball>();
}

void draw() {
  background(0);
  for (Ball b : balls) {
    b.move();
    b.display();
  }
}
  
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
    fill((int)(random(256)), (int)(random(256)),(int)(random(256)));
    balls.add(new Ball());
  }
}