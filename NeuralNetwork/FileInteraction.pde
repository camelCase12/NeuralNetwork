Network readNetwork(String file) {
 Network n = new Network();
 String[] lines = loadStrings(file);
 String[] basicData = new String[7];
 for(int i = 0; i < basicData.length; i++) {
  basicData[i] = lines[0].split(",")[i];
 }
 int layers = int(basicData[0]);
 int Width = int(basicData[1]);
 int Height = int(basicData[2]);
 int xpos = int(basicData[3]);
 int ypos = int(basicData[4]);
 int inputNeuronCount = int(basicData[5]);
 String activationMode = basicData[6];
 
 InputLayer inputLayer = new InputLayer(inputNeuronCount, 0);
 HiddenLayer[] hiddenLayers = new HiddenLayer[layers-2];
 OutputLayer outputLayer = new OutputLayer();
 AxonBundle[] cachedAxonBundles = new AxonBundle[inputNeuronCount];
 
 int currentAxonBundle = 0;
 int currentLayer = 0;
 
 for(int i = 2; i < lines.length; i++) {
   if(lines[i].split(",")[0].equals("ID")) {
     if(currentLayer == 0) { // finished input layer
       hiddenLayers[0] = new HiddenLayer(cachedAxonBundles[0].axons.length, 1); // set the number of neurons in the next layer based on the amount of axons coming out of a given axon bundle in the first layer
       inputLayer.axonBundles = cachedAxonBundles;
       cachedAxonBundles = new AxonBundle[hiddenLayers[0].neurons.length];
     }
     else if (currentLayer == layers-2) {
       outputLayer = new OutputLayer(cachedAxonBundles[0].axons.length, layers);
       hiddenLayers[currentLayer-1].axonBundles = cachedAxonBundles;
     }
     else {
       hiddenLayers[currentLayer] = new HiddenLayer(cachedAxonBundles[0].axons.length, currentLayer+1);
       hiddenLayers[currentLayer-1].axonBundles = cachedAxonBundles;
       cachedAxonBundles = new AxonBundle[hiddenLayers[currentLayer].neurons.length];
     }
     currentLayer++;
     currentAxonBundle = 0;
   }
   else { // layer storing raw axon weights, loads data into the cached axon bundles array
    String[] stringAxonWeights = lines[i].split(",");
    cachedAxonBundles[currentAxonBundle] = new AxonBundle(currentLayer, stringAxonWeights.length, currentAxonBundle);
    for(int j = 0; j < stringAxonWeights.length; j++) {
      cachedAxonBundles[currentAxonBundle].axons[j].weight = float(stringAxonWeights[j]);
    }
    currentAxonBundle++;
   }
 }
 
 int[] sizes = new int[layers];
 sizes[0] = inputLayer.neurons.length;
 for(int i = 0; i < hiddenLayers.length; i++) {
  sizes[i+1] = hiddenLayers[i].neurons.length; 
 }
 sizes[sizes.length-1] = outputLayer.neurons.length;
 
 n = new Network(sizes, Width, Height, xpos, ypos, activationMode);
 
 n.inputLayer = inputLayer;
 n.hiddenLayers = hiddenLayers;
 n.outputLayer = outputLayer;
 
 n.initializePositions();
 return n;
}

void saveNetwork(Network n, String file) {
  String basicData = "";
  basicData += str(n.layers) + "," + str(n.Width) + "," + str(n.Height) + "," + str(n.xPos) + "," + str(n.yPos) + "," + str(n.inputLayer.neurons.length) + "," + n.activationFunction.mode;
  int totalNeurons = 0;
  totalNeurons += n.inputLayer.neurons.length;
  for(int i = 0; i < n.hiddenLayers.length; i++) {
   totalNeurons += n.hiddenLayers[i].neurons.length; 
  }
  String[] totalData = new String[1 + totalNeurons + n.layers]; // 1 line for parameters, 1 line to designate each layer ( excluding output), 1 line for each axonbundle ( excluding output) (1 per neuron) in each layer, and 1 line to cap off the algorithm
  totalData[0] = basicData;
  totalData[1] = "ID," + n.inputLayer.axonBundles.length;
  
  int currentLayer = 0;
  
  for(int i = 2; i < totalData.length; i++) {
    if(currentLayer == 0) {
      for(int j = 0; j < n.inputLayer.axonBundles.length; j++) {
        totalData[i+j] = n.inputLayer.axonBundles[j].getTextWeights();
      }
      i += n.inputLayer.axonBundles.length-1;
      currentLayer++;
    }
    else if(currentLayer == n.layers-1) {
      totalData[i] = "ID";
    }
    else {
      totalData[i] = "ID," + n.hiddenLayers[currentLayer-1].axonBundles.length;
      i++;
      for(int j = 0; j < n.hiddenLayers[currentLayer-1].axonBundles.length; j++) {
        totalData[i+j] = n.hiddenLayers[currentLayer-1].axonBundles[j].getTextWeights();
      }
      i += n.hiddenLayers[currentLayer-1].axonBundles.length-1;
      currentLayer++;
    }
  }
  
  saveStrings(file, totalData);
}
