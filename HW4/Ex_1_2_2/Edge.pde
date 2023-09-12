static final color red=#E61310; //"r"=(230,19,16)
static final color green=#016842;//"g"=(1,104,66)
static final color blue=#00308C; //"b"=(0,48,140)
static final color orange=#FF8305;//"o"=(255,131,5)


class Edge {
  Node from; 
  Node to; 
  float minutes;
  String colo;
  Edge(Node from, Node to, float minutes, String colo) {
    this.from = from; 
    this.to = to; 
    this.minutes = minutes;
    this.colo=colo;
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
    return colo;
  }
  
  void draw() {
    if (colo=="r"){
    stroke(red);
    }else if(colo=="g"){
    stroke(green);
    }else if(colo=="b"){
    stroke(blue);
    }else if(colo=="o"){
    stroke(orange);
    }else {
      print("error with wrong color");
    }  
    strokeWeight(2);
    line(from.x, from.y, to.x, to.y);
  }
}  