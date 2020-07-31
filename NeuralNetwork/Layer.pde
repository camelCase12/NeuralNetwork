class NeuronLayer {
 Neuron[] neurons;
 AxonBundle[] axonBundles;
 int Length;
 int layer;
 void initializeNeurons() {
  for(int i = 0; i < neurons.length; i++) {
   neurons[i] = new Neuron(layer);
  }
 }
 
 NeuronLayer() { }
}

class InputLayer extends NeuronLayer{
  
 InputLayer(int size, int layer) { 
   neurons = new Neuron[size];
   axonBundles = new AxonBundle[size];
   Length = neurons.length;
   this.layer = layer;
   initializeNeurons();
 } 
}

class HiddenLayer extends NeuronLayer {
  
  HiddenLayer(int size, int layer) { 
    neurons = new Neuron[size];
    axonBundles = new AxonBundle[size];
    Length = neurons.length;
    this.layer = layer;
    initializeNeurons();
  }
}

class OutputLayer extends NeuronLayer {
  
  
  OutputLayer(int size, int layer) {
    neurons = new Neuron[size];
    axonBundles = new AxonBundle[size];
    Length = neurons.length;
    this.layer = layer;
    initializeNeurons();
  }
  OutputLayer() { }
}
