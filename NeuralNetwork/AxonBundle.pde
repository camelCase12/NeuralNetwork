class AxonBundle { // bundle of axons which goes out of a given neuron and into each neuron in the next layer
 int layer;
 Axon[] axons;
 
 String getTextWeights() {
  String weights = "";
  for(int i = 0; i < axons.length; i++) {
    weights += str(axons[i].weight);
    if(i<axons.length-1) { weights += ","; }
  }
  return weights;
 }
 
 void updateWeights() {
  for(int i = 0; i < axons.length; i++) {
   axons[i].updateWeight();
  }
 }
 
 AxonBundle(int layer, int axonCount, int parentIndex) {
   this.layer = layer;
   axons = new Axon[axonCount];
   for(int i = 0; i < axonCount; i++) {
     axons[i] = new Axon(layer, parentIndex, i);
   }
 }
}
