class Vector {
  int dimension;
  float[] values;
  
  Vector(int dimension) {
   this.dimension = dimension;
  }
  Vector(int dimension, float[] values) {
    this.dimension = dimension;
    this.values = values;
  }
  Vector() { }
}
