import processing.pdf.*;

// nodes
int nodeCount; 
Node[] nodes = new Node[100];
HashMap nodeTable = new HashMap();

// selection
Node selection;

// record
boolean record; 

// edges
int edgeCount; 
Edge[] edges = new Edge[500];

// font
PFont font; 

void setup() {
  size(559, 559);
  font = createFont("SansSerif", 10);
  loadData();
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
    edges[i].draw();
  }
  
  // draw the nodes
  for (int i = 0; i < nodeCount; i++) {
    nodes[i].draw();
  }
  
  //display station names
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
    text(selection.label, selection.x+2, selection.y+2);
  }  
  
  
  if (record) {
    endRecord();
    record = false;
  }
}

void mousePressed() {
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

void mouseDragged() {
  if (selection != null) {
    selection.x = mouseX;
    selection.y = mouseY;
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
