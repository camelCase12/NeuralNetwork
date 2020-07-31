class Neuron {
  int layer;
  float xPos, yPos;
  float Width = 30;
  float Height = 30;
  float cachedInput;
  float cachedOutput;
  LearningCache learningCache;
  void bypassActivation(float value) { // caches the value directly as output, used to initialize the input layer.
    cachedOutput = value;
  }
  void activate(ActivationFunction af) { // sigmoid function
    cachedOutput = af.getActivation(cachedInput);
  }
  
  Neuron(int layer) { 
    this.layer = layer;
    learningCache = new LearningCache();
  }
}
