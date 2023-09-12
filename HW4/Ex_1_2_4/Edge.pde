static final color red = #E61310; 
static final color green = #016842;
static final color blue = #00308C; 
static final color orange = #FF8305;


class Edge {
  Node from; 
  Node to; 
  float minutes;
  String col;
  Edge(Node from, Node to, float minutes, String col) {
    this.from = from; 
    this.to = to; 
    this.minutes = minutes;
    this.col = col;
  }
  
  Node getFromNode() {
    return from;
  }
  
  Node getToNode() {
    return to;
  }
  
  float getMinutes() {
    return minutes;
  }
  
  String getCol(){
    return col;
  }
  
  void draw() {
    if (col == "r") stroke(red);
    else if(col == "g") stroke(green);
    else if(col == "b") stroke(blue);
    else if(col == "o") stroke(orange);
    else print("Please input correct color!\n"); 
    strokeWeight(2);
    line(from.x, from.y, to.x, to.y);
  }
}  
