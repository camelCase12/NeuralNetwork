
Network cachedNetwork;
String cachedFileLocation;

void setup() {
 size(750, 750);
 background(0);
  test2();
}

void draw() {
  //background(0);
  renderNetwork(cachedNetwork);
}

void keyPressed() {
 if(key=='S') {
   saveNetwork(cachedNetwork, cachedFileLocation);
   println("\nFile Saved to " + cachedFileLocation);
 }
}
