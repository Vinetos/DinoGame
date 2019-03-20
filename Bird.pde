class Bird {
  float w = 60;
  float h = 50;
  float posX;
  float posY;
  int flapCount = 0;
  int typeOfBird;
//------------------------------------------------------------------------------------------------------------------------------------------------------
 //constructor
  Bird(int type) {
    posX = width;
    typeOfBird = type;
    switch(type) {
    case 0:// Vol bas
      posY = 10 + h/2;
      break;
    case 1:// Vol au millieu
      posY = 100;
      break;
    case 2:// Vol haut
      posY = 180;
      break;
    }
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------
  // Montre l'oiseau
  void show() {
    flapCount++;
    
    if (flapCount < 0) {// Animation de vol (battement d'aile)
      image(bird,posX-bird.width/2,height - groundHeight - (posY + bird.height-20));
    } else {
      image(bird1,posX-bird1.width/2,height - groundHeight - (posY + bird1.height-20));
    }
    if(flapCount > 15){
     flapCount = -15; 
      
    }
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------
  // Déplace le zozio
  void move(float speed) {
    posX -= speed;
  }
//------------------------------------------------------------------------------------------------------------------------------------------------------
  // Renvoie si oui ou non l'oiseau est entré en colision avec le joueur
  boolean collided(float playerX, float playerY, float playerWidth, float playerHeight) {
    float playerLeft = playerX - playerWidth/2;
    float playerRight = playerX + playerWidth/2;
    float thisLeft = posX - w/2 ;
    float thisRight = posX + w/2;

    if ((playerLeft<= thisRight && playerRight >= thisLeft ) || (thisLeft <= playerRight && thisRight >= playerLeft)) {
      float playerUp = playerY + playerHeight/2;
      float playerDown = playerY - playerHeight/2;
      float thisUp = posY + h/2;
      float thisDown = posY - h/2;
      if (playerDown <= thisUp && playerUp >= thisDown) {
        return true;
      }
    }
    return false;
  }
}
