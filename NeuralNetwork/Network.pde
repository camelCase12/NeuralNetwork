class Network { // assumed to have at least 2 hidden layers
  int layers;
  float Width;
  float Height;
  float xPos, yPos;
  InputLayer inputLayer;
  HiddenLayer[] hiddenLayers;
  OutputLayer outputLayer;
  ActivationFunction activationFunction;
  
  void setInput(float input) {
    inputLayer.neurons[0].bypassActivation(input);
  }
  
  void setInputs(float[] inputs) {
    for(int i = 0; i < inputs.length; i++) {
     inputLayer.neurons[i].bypassActivation(inputs[i]); 
    }
  }
  
  float getOutput() {
    return outputLayer.neurons[0].cachedOutput;
  }
  float[] getOutputs() {
    float[] outputs = new float[outputLayer.neurons.length];
    for(int i = 0; i < outputs.length; i++) {
      outputs[i] = outputLayer.neurons[i].cachedOutput; 
    }
    return outputs;
  }
  
  void backwardPropogate(float[] expectedValues, float learningRate) { // complete, untested
    for(int i = 0; i < hiddenLayers[hiddenLayers.length-1].axonBundles.length; i++) { // derives correction for output layer
      for(int j = 0; j < hiddenLayers[hiddenLayers.length-1].axonBundles[i].axons.length; j++) {
        //setup parameters
        float wij = hiddenLayers[hiddenLayers.length-1].axonBundles[i].axons[j].weight;
        float oj = outputLayer.neurons[j].cachedOutput;
        float netj = outputLayer.neurons[j].cachedInput;
        float oi = hiddenLayers[hiddenLayers.length-1].neurons[i].cachedOutput;
        //setup parameters
        //derive dE/dwij
        float dnetjdwij = oi;
        float dojdnetj = activationFunction.getDerivativeByOutput(oj); // based on activation function
        float dEdoj =  oj - expectedValues[j];
        float dEdwij = dEdoj*dojdnetj*dnetjdwij;
        //derive dE/dwij
        //cache derivative values
        outputLayer.neurons[j].learningCache.dodnet = dojdnetj;
        outputLayer.neurons[j].learningCache.dEdo = dEdoj;
        //cache derivative values
        
        //modify weight
        hiddenLayers[hiddenLayers.length-1].axonBundles[i].axons[j].newWeight = -1 * learningRate * dEdwij + wij;
        //modify weight
      }
    } 
    for(int k = hiddenLayers.length-2; k >= -1; k--) {  // derive the correction for each hidden layer
      if(k > -1) {
        for(int i = 0; i < hiddenLayers[k].axonBundles.length; i++) {
         for(int j = 0; j < hiddenLayers[k].axonBundles[i].axons.length; j++) {
          //setup parameters
          float wij = hiddenLayers[k].axonBundles[i].axons[j].weight;
          float oj = hiddenLayers[k+1].neurons[j].cachedOutput;
          float netj = hiddenLayers[k+1].neurons[j].cachedInput;
          float oi = hiddenLayers[k].neurons[i].cachedOutput;
          //setup parameters
          //derive dE/dwij
          float dnetjdwij = oi;
          float dojdnetj = activationFunction.getDerivativeByOutput(oj); // based on the sigmoid function
          float dEdojsum = 0;
          if(k < hiddenLayers.length-2) {
            for(int l = 0; l < hiddenLayers[k+1].axonBundles[j].axons.length; l++) {
             float wjl = hiddenLayers[k+1].axonBundles[j].axons[l].weight;
             float doldnetl = hiddenLayers[k+2].neurons[l].learningCache.dodnet;
             float dEdol = hiddenLayers[k+2].neurons[l].learningCache.dEdo;
             dEdojsum += dEdol*doldnetl*wjl;
            }
          }
          else { // secondarily borders output layer
            for(int l = 0; l < hiddenLayers[k+1].axonBundles[j].axons.length; l++) {
             float wjl = hiddenLayers[k+1].axonBundles[j].axons[l].weight;
             float doldnetl = outputLayer.neurons[l].learningCache.dodnet;
             float dEdol = outputLayer.neurons[l].learningCache.dEdo;
             dEdojsum += dEdol*doldnetl*wjl;
            }
          }
          float dEdoj = dEdojsum;
          float dEdwij = dEdoj*dojdnetj*dnetjdwij;
          //derive dE/dwij
          //cache derivative values
          hiddenLayers[k+1].neurons[j].learningCache.dodnet = dojdnetj;
          hiddenLayers[k+1].neurons[j].learningCache.dEdo = dEdoj;
          //cache derivative values
        
          //modify weight
          hiddenLayers[k].axonBundles[i].axons[j].newWeight = -1 * learningRate * dEdwij + wij;
          //modify weight
         }
        }
      }
      else { // will border input layer NOTE: k==-1 
        for(int i = 0; i < inputLayer.axonBundles.length; i++) {
         for(int j = 0; j < inputLayer.axonBundles[i].axons.length; j++) {
          //setup parameters
          float wij = inputLayer.axonBundles[i].axons[j].weight;
          float oj = hiddenLayers[k+1].neurons[j].cachedOutput;
          float netj = hiddenLayers[k+1].neurons[j].cachedInput;
          float oi = inputLayer.neurons[i].cachedOutput;
          //setup parameters
          //derive dE/dwij
          float dnetjdwij = oi;
          float dojdnetj = activationFunction.getDerivativeByOutput(oj); // based on the sigmoid function
          float dEdojsum = 0;
          if(k < hiddenLayers.length-2) {
            for(int l = 0; l < hiddenLayers[k+1].axonBundles[j].axons.length; l++) {
             float wjl = hiddenLayers[k+1].axonBundles[j].axons[l].weight;
             float doldnetl = hiddenLayers[k+2].neurons[l].learningCache.dodnet;
             float dEdol = hiddenLayers[k+2].neurons[l].learningCache.dEdo;
             dEdojsum += dEdol*doldnetl*wjl;
            }
          }
          else { // secondarily borders output layer
            for(int l = 0; l < hiddenLayers[k+1].axonBundles[j].axons.length; l++) {
             float wjl = hiddenLayers[k+1].axonBundles[j].axons[l].weight;
             float doldnetl = outputLayer.neurons[l].learningCache.dodnet;
             float dEdol = outputLayer.neurons[l].learningCache.dEdo;
             dEdojsum += dEdol*doldnetl*wjl;
            }
          }
          float dEdoj = dEdojsum;
          float dEdwij = dEdoj*dojdnetj*dnetjdwij;
          //derive dE/dwij
          //cache derivative values
          hiddenLayers[k+1].neurons[j].learningCache.dodnet = dojdnetj;
          hiddenLayers[k+1].neurons[j].learningCache.dEdo = dEdoj;
          //cache derivative values
        
          //modify weight
          inputLayer.axonBundles[i].axons[j].newWeight = -1 * learningRate * dEdwij + wij;
          //modify weight
         }
        }
      }
    }
    //no correction necessary for input layer because no axons come in front of them
   updateWeights(); 
  }
  
  void updateWeights() {
    for(int i = 0; i < inputLayer.axonBundles.length; i++) {
      inputLayer.axonBundles[i].updateWeights();
    }
    for(int j = 0; j < hiddenLayers.length; j++) {
      for(int i = 0; i < hiddenLayers[j].axonBundles.length; i++) {
       hiddenLayers[j].axonBundles[i].updateWeights(); 
      }
    }
    // no updates necessary for output layer because no axons come after them
  }
  
  void clearInputs() {
    for(int i = 0; i < hiddenLayers.length; i++) {
     for(int j = 0; j < hiddenLayers[i].neurons.length; j++) {
      hiddenLayers[i].neurons[j].cachedInput = 0; 
     }
    }
    for(int i = 0; i < outputLayer.neurons.length; i++) {
     outputLayer.neurons[i].cachedInput = 0; 
    }
  }
  
  void forwardPropogate() {
    clearInputs();
   for(int i = 0; i < inputLayer.neurons.length; i++) { // caches the axon-processed output of the input neurons into the next layer
     for(int j = 0; j < inputLayer.axonBundles[i].axons.length; j++) {
      
      hiddenLayers[0].neurons[j].cachedInput += inputLayer.neurons[i].cachedOutput*inputLayer.axonBundles[i].axons[j].weight; 
     }
    }
    for(int j = 0; j < hiddenLayers.length; j++) {  // caches the axon-processed output of the hidden neurons into the next layer
      if(j < hiddenLayers.length-1) {
       for(int i = 0; i < hiddenLayers[j].neurons.length; i++) {
         hiddenLayers[j].neurons[i].activate(activationFunction);
         for(int k = 0; k < hiddenLayers[j].axonBundles[i].axons.length; k++) {
           hiddenLayers[j+1].neurons[k].cachedInput += hiddenLayers[j].neurons[i].cachedOutput*hiddenLayers[j].axonBundles[i].axons[k].weight;
         }
       }
      }
      else {
        for(int i = 0; i < hiddenLayers[j].neurons.length; i++) {
         for(int k = 0; k < hiddenLayers[j].axonBundles[i].axons.length; k++) {
          hiddenLayers[j].neurons[i].activate(activationFunction);
          outputLayer.neurons[k].cachedInput += hiddenLayers[j].neurons[i].cachedOutput*hiddenLayers[j].axonBundles[i].axons[k].weight;
         }
        }
      }
    }
    for(int i = 0; i < outputLayer.neurons.length; i++) { // activation-function processes the output layer
      outputLayer.neurons[i].activate(activationFunction);
    } 
  }
  
  void initializePositions() { // sets the positions of each neuron in the network
    for(int i = 0; i < inputLayer.neurons.length; i++) { // sets the positions of the input neurons
     inputLayer.neurons[i].xPos = xPos;
     inputLayer.neurons[i].yPos = (Height / inputLayer.neurons.length)*i + yPos;
    }
    for(int j = 0; j < hiddenLayers.length; j++) { // sets the positions of the hidden neurons
     for(int i =0; i < hiddenLayers[j].neurons.length; i++) {
      hiddenLayers[j].neurons[i].xPos = (Width / layers)*(1+j) + xPos;
      hiddenLayers[j].neurons[i].yPos = (Height / hiddenLayers[j].neurons.length)*i + yPos;
     }
    }
    for(int i = 0; i < outputLayer.neurons.length; i++) { // sets the positions of the output neurons
     outputLayer.neurons[i].xPos = Width - (Width / layers) + xPos;
     outputLayer.neurons[i].yPos = (Height / outputLayer.neurons.length)*i + yPos;
    }
  }
  
  void initializeAxons() { // creates and initializes the axon bundles in the network
    for(int i = 0; i < inputLayer.axonBundles.length; i++) { // initializes input Axons
      inputLayer.axonBundles[i] = new AxonBundle(0, hiddenLayers[0].neurons.length, i);
    }
    for(int j = 0; j < hiddenLayers.length; j++) { // initializes hidden Axons
      if(j < hiddenLayers.length-1) {
       for(int i =0; i < hiddenLayers[j].axonBundles.length; i++) {
         hiddenLayers[j].axonBundles[i] = new AxonBundle(j+1, hiddenLayers[j+1].neurons.length, i);
       }
      }
      else {
        for(int i =0; i < hiddenLayers[j].axonBundles.length; i++) {
         hiddenLayers[j].axonBundles[i] = new AxonBundle(j+1, outputLayer.neurons.length, i);
       }
      }
    }
    for(int i = 0; i < outputLayer.axonBundles.length; i++) { // initializes output Axons
      //outputLayer.axonBundles[i] = new AxonBundle(layers-1, outputLayer.neurons.length, i);
    }
  }
  
  Network(int[] sizes, int Width, int Height, int xPos, int yPos, String activationMode) {  // sizes must >= 3
    this.layers = sizes.length;
    this.Width = Width;
    this.Height = Height;
    this.xPos = xPos;
    this.yPos = yPos;
    inputLayer = new InputLayer(sizes[0], 0); // uses the first size for the first layer
    hiddenLayers = new HiddenLayer[sizes.length-2]; // the hidden layers omit the input and output layer, totalling 2 omissions
    for(int i = 1; i < sizes.length-1; i++) { // iterates through all layers except the first and last
     hiddenLayers[i-1] = new HiddenLayer(sizes[i], i-1); 
    }
    outputLayer = new OutputLayer(sizes[sizes.length-1], layers-1);
    initializePositions();
    initializeAxons();
    activationFunction = new ActivationFunction(activationMode);
  }
  
  Network() { }
}
