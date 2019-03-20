// Classe d'un Noeud
class Node {
  int number; // Numéro unique du noeud
  float inputSum = 0;//current sum i.e. before activation
  float outputValue = 0; //after activation function is applied
  ArrayList<connectionGene> outputConnections = new ArrayList<connectionGene>();
  int layer = 0;
  PVector drawPos = new PVector();
  //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //constructor
  Node(int no) {
    number = no;
  }

  //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //the node sends its output to the inputs of the nodes its connected to
  void engage() {
    if (layer!=0) {//no sigmoid for the inputs and bias
      outputValue = sigmoid(inputSum);
    }

    for (int i = 0; i< outputConnections.size(); i++) {//for each connection
      if (outputConnections.get(i).enabled) {//dont do shit if not enabled
        outputConnections.get(i).toNode.inputSum += outputConnections.get(i).weight * outputValue;//add the weighted output to the sum of the inputs of whatever node this node is connected to
      }
    }
 }
//----------------------------------------------------------------------------------------------------------------------------------------
//not used
  float stepFunction(float x) {
    if (x < 0) {
      return 0;
    } else {
      return 1;
    }
  }
  //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //Fonction d'activation : Sigmoid
  // Elle va de 0 à 1
  float sigmoid(float x) {
    float y = 1 / (1 + pow((float)Math.E, -4.9*x)); // 1 / ( 1 + exp (-4.9 * x) )
    return y;
  }
  
  //----------------------------------------------------------------------------------------------------------------------------------------------------------
  // Renvoie vrai si ce noeud est connecté au noeud en paramètre
  // Utilisé lors de l'ajout d'une connexion
  boolean isConnectedTo(Node node) {
    if (node.layer == layer) // Les noeuds d'une même couche ne peuvent pas être connectés
      return false;

    if (node.layer < layer) {// La couche du noeud est avant
      for (int i = 0; i < node.outputConnections.size(); i++) {
        if (node.outputConnections.get(i).toNode == this) {
          return true;
        }
      }
      
    } else {// La couche du noeud est après
      for (int i = 0; i < outputConnections.size(); i++) {
        if (outputConnections.get(i).toNode == node) {
          return true;
        }
      }
    }

    return false;
  }
  
  //---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  //Renvoie une copie du noeud
  Node clone() {
    Node clone = new Node(number);
    clone.layer = layer;
    return clone;
  }
}
