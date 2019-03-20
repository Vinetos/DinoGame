// Sert uniquement à afficher des points sur le sol
class Ground {
  float posX = width;
  float posY = height -floor(random(groundHeight - 20, groundHeight +30));
  int w = floor(random(1,10)); // auteur aléatoire
  
  Ground(){}
 
  void show() {
    stroke(0);
    strokeWeight(3);
    line(posX, posY, posX + w, posY);
  }
  
  void move(float speed) {
    posX -= speed;
  }
  
}
