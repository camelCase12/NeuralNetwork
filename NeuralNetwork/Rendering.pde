void renderNeuron(Neuron n) {
  float activationStrength = n.cachedOutput; // store the activation function output (between 0 and 1) as a value to determine neuron color
  stroke(255); // neuron outline is always white
  fill(255*activationStrength); // neuron fill will be black if 0, white if 1, or varying grey for in-between
  ellipse(n.xPos,n.yPos,n.Width,n.Height);
}

void renderAxon(Axon a, Neuron parent, Neuron child) {
  if(a.weight<=0) {
    stroke(255, 255-Math.abs(a.weight)*255, 255-Math.abs(a.weight)*255);
  }
  else {
    stroke(255-a.weight*255, 255, 255-a.weight*255); 
  }
  line(parent.xPos + parent.Width/2, parent.yPos, // from
       child.xPos - child.Width/2, child.yPos);
}

void renderNetwork(Network n) {
 for(int i = 0; i < n.inputLayer.Length; i++) {
  renderNeuron(n.inputLayer.neurons[i]);
  stroke(255); fill(255);
  text(""+n.inputLayer.neurons[i].cachedOutput, n.inputLayer.neurons[i].xPos - 60, n.inputLayer.neurons[i].yPos);
  for(int j = 0; j < n.inputLayer.axonBundles[i].axons.length; j++) {
    renderAxon(n.inputLayer.axonBundles[i].axons[j], n.inputLayer.neurons[i], n.hiddenLayers[0].neurons[j]);
  }
 }
 for(int k = 0; k < n.hiddenLayers.length; k++) {
   if(k < n.hiddenLayers.length-1) {
    for(int i = 0; i < n.hiddenLayers[k].Length; i++) {
     renderNeuron(n.hiddenLayers[k].neurons[i]);
     for(int j = 0; j < n.hiddenLayers[k].axonBundles[i].axons.length; j++) {
      renderAxon(n.hiddenLayers[k].axonBundles[i].axons[j], n.hiddenLayers[k].neurons[i], n.hiddenLayers[k+1].neurons[j]); 
     }
    }
   }
   else {
    for(int i = 0; i < n.hiddenLayers[k].Length; i++) {
     renderNeuron(n.hiddenLayers[k].neurons[i]);
     for(int j = 0; j < n.hiddenLayers[k].axonBundles[i].axons.length; j++) {
      renderAxon(n.hiddenLayers[k].axonBundles[i].axons[j], n.hiddenLayers[k].neurons[i], n.outputLayer.neurons[j]); 
     }
    }
   }
 }
 for(int i = 0; i < n.outputLayer.Length; i++) {
  renderNeuron(n.outputLayer.neurons[i]);
  //for now -> axon rendering disabled for output layer
  stroke(255); fill(255);
  text(""+n.outputLayer.neurons[i].cachedOutput, n.outputLayer.neurons[i].xPos + 50, n.outputLayer.neurons[i].yPos); // value output
 }
}
