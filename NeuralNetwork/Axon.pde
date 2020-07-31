class Axon {
 int layer;
 float weight; // between -1 and 1
 int parentIndex; // within same layer
 int childIndex; // in the next layer
 float newWeight; // used for backpropogation temp. storage
 
 void updateWeight() {
  weight = newWeight; 
 }
 Axon(int layer, int parentIndex, int childIndex) { 
   this.layer = layer;
   this.parentIndex = parentIndex;
   this.childIndex = childIndex;
   weight = random(-1, 1);
 } 
}
