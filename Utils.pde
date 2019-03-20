/*
 * Renvoie si oui ou non l'entité est entré en colision avec le joueur
 *
 * @param entityX       Position X de l'entité
 * @param entityY       Position Y de l'entité
 * @param entityWidth   Largeur de l'entité
 * @param entityHeight  Hauteur de l'entité
 *
 * @param playerX       Position X du joueur
 * @param playerY       Position Y du joueur
 * @param playerWidth   Largeur du joueur
 * @param playerHeight  Hauteur du joueur
 */
static boolean collided(float entityX, float entityY, float entityWidth, float entityHeight, float playerX, float playerY, float playerWidth, float playerHeight) {
    float playerLeft = playerX - playerWidth/2; // Hitbox à gauche
    float playerRight = playerX + playerWidth/2;
    
    float entityLeft = entityX - entityWidth/2 ; // Hitbox gauche de l'entité
    float thisRight = entityX + entityWidth/2;

    if ((playerLeft<= thisRight && playerRight >= entityLeft ) || (entityLeft <= playerRight && thisRight >= playerLeft)) {
      float playerUp = playerY + playerHeight/2;
      float playerDown = playerY - playerHeight/2;
      float thisUp = entityY + entityHeight/2;
      float thisDown = entityY - entityHeight/2;
      if (playerDown <= thisUp && playerUp >= thisDown) {
        return true;
      }
    }
    return false;
  }
