import processing.pdf.*;

// Settings of Ex_1_2_4
int numOfNodes;
float numOfMinutes;
boolean[] activeNodes;
boolean[] activeEdges;
Node A;
Node B;

// nodes
int nodeCount; 
Node[] nodes = new Node[130];
HashMap nodeTable = new HashMap();

// selection
Node selection;

// record
boolean record; 

// edges
int edgeCount; 
Edge[] edges = new Edge[200];

// font
PFont font; 

void setup() {
  size(559, 559);
  font = createFont("SansSerif", 10);
  loadData();
  initializeActiveDataStructures();
  initializeAdjacencyMatrix();
}

void loadData() {
  Table myEdge = new Table("connections.csv");
  for(int i = 0; i < myEdge.getRowCount(); i++) { 
    String lineColo = myEdge.getString(i, 2);   
    if(i < 28) lineColo = "r";     
    else if(i < 45) lineColo = "o";
    else if(i < 110) lineColo = "g";
    else lineColo = "b";
    addEdge(myEdge.getString(i, 0), myEdge.getString(i, 1), myEdge.getFloat(i, 3), lineColo);
  }
}

void addEdge(String fromLabel, String toLabel, float minutes, String col) {
  // find nodes
  Node from = findNode(fromLabel);
  Node to = findNode(toLabel);

  // old edge?
  for (int i = 0; i < edgeCount; i++) {
    if (edges[i].from == from && edges[i].to == to) {
      return;
    }
  }
  // add edge
  Edge e = new Edge(from, to, minutes, col);
  if (edgeCount == edges.length) {
    edges = (Edge[]) expand(edges);
  }
  edges[edgeCount++] = e;
}

Node findNode(String label) {
  Node n = (Node) nodeTable.get(label);
  if (n == null) {
    return addNode(label);
  }
  return n;
}

Node addNode(String label) {
  Table myNode = new Table("locations.csv");
  float xaxis = myNode.getFloat(myNode.getRowIndex(label), 1);
  float yaxis = myNode.getFloat(myNode.getRowIndex(label), 2); 
  Node tmpNode = new Node(label, xaxis, yaxis, nodeCount);
  if (nodeCount == nodes.length) nodes = (Node[]) expand(nodes);
  nodeTable.put(label, tmpNode);
  nodes[nodeCount++] = tmpNode;
  return tmpNode;
}

void draw() {
  if (record) {
    beginRecord(PDF, "output.pdf");
  }

  textFont(font); 
  smooth();

  background(255); 

  // draw the edges
  for (int i = 0; i < edgeCount; i++) {
    if (activeEdges[i]){
      edges[i].draw();
    }
  }

  // draw the nodes
  for (int i = 0; i < nodeCount; i++) {
    if (activeNodes[i]){
      nodes[i].draw();
    }
  }
  // display station name
  float closest = 5;
  for (int i = 0; i < nodeCount; i++) {
     Node n = nodes[i];
     float d = dist(mouseX, mouseY, n.x, n.y);
     if (d < closest) {
       selection = n;
       closest = d;
     }
  }
  if (selection != null) {
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text(selection.label, selection.x+4, selection.y+2);
  }
    
  // draw the text of short path
  if(numOfNodes==1){
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text("From:",10, 30);
    text(A.label, 55, 30);
  }
  if(numOfNodes==2){
    String travelTime  = nf(numOfMinutes,2,1);  //convert minute to 3 digital. step1.2.4
    textAlign(LEFT, BOTTOM);
    textSize(16);
    fill(50);
    text("From:",10, 30);
    text(A.label, 55, 30);
    text("To:",10, 50);
    text(B.label, 55, 50);
    textSize(16);
    text("Travel Time:",10, 70);
    text(travelTime, 120, 70);
    text("min",160, 70);
  }
  textSize(18);
  fill(50);
  text("MBTA TRAVEL TIME",5, 530);
    
  if (record) {
    endRecord();
    record = false;
  }
}
    
void mousePressed() {
  if (mouseButton == RIGHT) {
    if(numOfNodes == 2){
      numOfNodes = 0;
      numOfMinutes = 0;
      initializeActiveDataStructures();
    }
    for (int i = 0; i < nodeCount; i++) {
      Node calNode = nodes[i];
      if (dist(mouseX, mouseY, calNode.x, calNode.y) < 5) {
        if(numOfNodes == 0){
          A = calNode;
          numOfNodes = numOfNodes + 1;
        }
        else if (numOfNodes == 1){
          B = calNode;
          numOfMinutes = shortestPath(A.getIndex(),B.getIndex());
          numOfNodes = numOfNodes + 1;
        }
      }
    }
  }
  
  if (mouseButton == LEFT) {
    float closest = 5;
    for (int i = 0; i < nodeCount; i++) {
      Node n = nodes[i];
      float d = dist(mouseX, mouseY, n.x, n.y);
      if (d < closest) {
        selection = n;
        closest = d;
      }
    }
  }
}

void mouseReleased() {
  selection = null;
}

void keyPressed() {
  if (key == 'p') {
    record = true;
  }
}
