// Globals
int nextConnectionNo = 1000;
Population pop;
int frameSpeed = 60;


boolean showBestEachGen = false;
int upToGen = 0;
Player genPlayerTemp;

boolean showNothing = false;


// Images
PImage dinoRun1, dinoRun2, dinoJump, dinoDuck, dinoDuck1;
PImage smallCactus, manySmallCactus, bigCactus;
PImage bird, bird1;


ArrayList<Obstacle> obstacles = new ArrayList<Obstacle>();
ArrayList<Bird> birds = new ArrayList<Bird>();
ArrayList<Ground> grounds = new ArrayList<Ground>();


int obstacleTimer = 0;
int minimumTimeBetweenObstacles = 60;
int randomAddition = 0;
int groundCounter = 0;
float speed = 10;

int groundHeight = 250;
int playerXpos = 150;

ArrayList<Integer> obstacleHistory = new ArrayList<Integer>();
ArrayList<Integer> randomAdditionHistory = new ArrayList<Integer>();



/*--------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * Méthode d'initialisation.
 * Appelée une seule fois lors de l'ouverture du programme
 */
void setup() {
  frameRate(60);
  fullScreen();
  // Chargement des images
  dinoRun1 = loadImage("dinorun0000.png");
  dinoRun2 = loadImage("dinorun0001.png");
  dinoJump = loadImage("dinoJump0000.png");
  dinoDuck = loadImage("dinoduck0000.png");
  dinoDuck1 = loadImage("dinoduck0001.png");

  smallCactus = loadImage("cactusSmall0000.png");
  bigCactus = loadImage("cactusBig0000.png");
  manySmallCactus = loadImage("cactusSmallMany0000.png");
  bird = loadImage("berd.png");
  bird1 = loadImage("berd2.png");

  pop = new Population(500); // Nombre de dinosaures dans chaque génération
}

/*--------------------------------------------------------------------------------------------------------------------------------------------------------
 *
 * Méthode de rendu.
 * Appelée à chaque tick (c.f. framerate).
 */
void draw() {
  drawToScreen();
  if (showBestEachGen) {// Montre le meilleur de chaque génération
    if (!genPlayerTemp.dead) {// Si le joueur n'est pas mort, on le met à jour
      genPlayerTemp.updateLocalObstacles();
      genPlayerTemp.look();
      genPlayerTemp.think();
      genPlayerTemp.update();
      genPlayerTemp.show();
    } else {// S'il est mort, on fait une nouvelle génération
      upToGen ++;
      if (upToGen >= pop.genPlayers.size()) {// S'il n'y a plus de génération à montrer, on retourne au début
        upToGen= 0;
        showBestEachGen = false;
      } else {// Si ce n'est pas la dernière, on montre la suivante
        genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
      }
    }
  } else {// Si c'est une évolution normale
    if (!pop.done()) {// Si des joueurs sont en vie, on les met à jour
      updateObstacles();
      pop.updateAlive();
    } else {// Ils sont morts
      // Algorithme génétique
      pop.naturalSelection();
      resetObstacles();
    }
  }
}



//---------------------------------------------------------------------------------------------------------------------------------------------------------
// Dessine l'écran
void drawToScreen() {
  if (!showNothing) {
    background(250); 
    stroke(0);
    strokeWeight(2);
    line(0, height - groundHeight - 30, width, height - groundHeight - 30);
    drawBrain();
    writeInfo();
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Dessine le cerveau de tout ce que montre le génome actuellement
void drawBrain() {
  int startX = 600;
  int startY = 10;
  int w = 600;
  int h = 400;
  if (showBestEachGen) {
    genPlayerTemp.brain.drawGenome(startX, startY, w, h); // Ancien génome
  } else {
    for (int i = 0; i< pop.pop.size(); i++) {// Affiche le genome le premier jouer de la liste encore vivant 
      if (!pop.pop.get(i).dead) {
        pop.pop.get(i).brain.drawGenome(startX, startY, w, h);
        break;
      }
    }
  }
}
//-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
// Ecrit les informations du joueur
void writeInfo() {
  fill(0);
  textAlign(LEFT);
  textSize(40);
  
  if (showBestEachGen) { // Si on affiche le meilleur pour chaque génération, on écrit les informations appropriées
    text("Score: " + genPlayerTemp.score, 30, height - 30);
    textAlign(RIGHT);
    text("Gen: " + (genPlayerTemp.gen +1), width -40, height-30);
  }
  else { // Évolution normale
    text("Score: " + floor(pop.populationLife/3.0), 30, height - 30);
     textAlign(RIGHT);
    text("Gen: " + (pop.gen +1), width -40, height-30);
    text("Ind: " + pop.getSize(), width -40, height-80);
  }
  
  textAlign(RIGHT);
  textSize(20);
  int x = 580;
    text("Distance avec le prochain obstacle", x, 18+44.44444);
    text("Hauteur de l'obstacle", x, 18+2*44.44444);
    text("Longueur de l'obstacle", x, 18+3*44.44444);
    text("Hauteur de l'oiseau", x, 18+4*44.44444);
    text("Vitesse", x, 18+5*44.44444);
    text("Position y des joueurs", x, 18+6*44.44444);
    text("Écart entre les obstacles", x, 18+7*44.44444);
    text("Préjugé (Biais)", x, 18+8*44.44444);

  textAlign(LEFT);
    text("Petit Saut", 1220, 118);
    text("Grand Saut", 1220, 218);
    text("Esquive", 1220, 318);
}


//--------------------------------------------------------------------------------------------------------------------------------------------------
// Méthode appelée lors d'un appui clavier
void keyPressed() {
  switch(key) {
  case '+':// + frame rate (= rendu par seconde)
    frameSpeed += 10;
    frameRate(frameSpeed);
    println(frameSpeed);
    break;
  case '-':// - frame rate
    if (frameSpeed > 10) {
      frameSpeed -= 10;
      frameRate(frameSpeed);
      println(frameSpeed);
    }
    break;
  case 'g':// Voir les générations
    showBestEachGen = !showBestEachGen;
    upToGen = 0;
    genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
    break;
  case 'n':// Ne montre rien pour augmenter la vitesse de calcul
    showNothing = !showNothing;
    break;
  case CODED:// Flèches clavier
    switch(keyCode) {
    case RIGHT:// Droite utilisée pour naviguer entre les générations
      if (showBestEachGen) {// Si on montre le meilleur joueur de chaque génération, passage à la génération suivante
        upToGen++;
        if (upToGen >= pop.genPlayers.size()) {// Si la génération actuelle est atteinte, on quitte le mode d'affichage des générations
          showBestEachGen = false;
        } else {
          genPlayerTemp = pop.genPlayers.get(upToGen).cloneForReplay();
        }
        break;
      }
      break;
    }
  }
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
// Appelé toutes les frames
void updateObstacles() {
  obstacleTimer ++;
  speed += 0.002;
  if (obstacleTimer > minimumTimeBetweenObstacles + randomAddition) { // Si le compteur d'obstacles est suffisamment élevé, ajout d'un nouvel obstacle
    addObstacle();
  }
  groundCounter ++;
  if (groundCounter> 10) { //toutes les 10 frames, ajout d'un point au sol
    groundCounter =0;
    grounds.add(new Ground());
  }

  moveObstacles();// Déplacement du jeu
  if (!showNothing) {// On montre tout
    showObstacles();
  }
}

//---------------------------------------------------------------------------------------------------------------------------------------------------------
// Déplace les obstacles vers la gauche en fonction de la vitesse du jeu 
void moveObstacles() {
  println(speed);
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).move(speed);
    if (obstacles.get(i).posX < -playerXpos) { 
      obstacles.remove(i);
      i--;
    }
  }

  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).move(speed);
    if (birds.get(i).posX < -playerXpos) {
      birds.remove(i);
      i--;
    }
  }
  for (int i = 0; i < grounds.size(); i++) {
    grounds.get(i).move(speed);
    if (grounds.get(i).posX < -playerXpos) {
      grounds.remove(i);
      i--;
    }
  }
}
//------------------------------------------------------------------------------------------------------------------------------------------------------------
// Ajoute de temps en temps un obstacle
void addObstacle() {
  int lifespan = pop.populationLife;
  int tempInt;
  if (lifespan > 1000 && random(1) < 0.15) { // 15% du temps ajout d'un oiseau
    tempInt = floor(random(3));
    Bird temp = new Bird(tempInt);//floor(random(3))); random = type d'oiseau (haut, milieu, bas)
    birds.add(temp);
  } else {// Sinon ajout d'un cactus
    tempInt = floor(random(3));
    Obstacle temp = new Obstacle(tempInt);//floor(random(3)));
    obstacles.add(temp);
    tempInt+=3;
  }
  obstacleHistory.add(tempInt);

  randomAddition = floor(random(50));
  randomAdditionHistory.add(randomAddition);
  obstacleTimer = 0;
}
//---------------------------------------------------------------------------------------------------------------------------------------------------------
// What do you think this does?
void showObstacles() {
  for (int i = 0; i< grounds.size(); i++) {
    grounds.get(i).show();
  }
  for (int i = 0; i< obstacles.size(); i++) {
    obstacles.get(i).show();
  }

  for (int i = 0; i< birds.size(); i++) {
    birds.get(i).show();
  }
}

//-------------------------------------------------------------------------------------------------------------------------------------------
// Reset tous les obstacles après que tous les dinos soient morts
void resetObstacles() {
  randomAdditionHistory = new ArrayList<Integer>();
  obstacleHistory = new ArrayList<Integer>();

  obstacles = new ArrayList<Obstacle>();
  birds = new ArrayList<Bird>();
  obstacleTimer = 0;
  randomAddition = 0;
  groundCounter = 0;
  speed = 10;
}
