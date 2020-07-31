void test1() { // Determine which of two inputs is greater
  int[] sizes = new int[] { 2, 2, 2 };
  Network n = new Network(sizes, 650, 700, 85, 25, "SIGMOID");
  float learningRate = 0.15;
  for(int i = 0; i < 10000000; i++) {
    float[] inputs = new float[] { random(0, 1), random(0, 1)};
    n.setInputs(inputs);
    n.forwardPropogate();
    if(inputs[0] > inputs[1]) {
      n.backwardPropogate(new float[] {1, 0}, learningRate);
    }
    else {
      n.backwardPropogate(new float[] {0, 1}, learningRate);
    }
  }
  float totalCorrect = 0;
  for(int i = 0; i < 10000; i++) {
    float[] inputs = new float[] { random(0, 1), random(0, 1)};
    n.setInputs(inputs);
    n.forwardPropogate();
    float[] outputs = n.getOutputs();
    if(outputs[0] > outputs[1] && inputs[0] > inputs[1]) {
     totalCorrect++; 
    }
    else if(outputs[1] > outputs[0] && inputs[1] > inputs[0]) {
     totalCorrect++; 
    }
  }
  float accuracy = totalCorrect/10000;
  
  println("Example outputs: ");
  for(int i = 0; i < 10; i++) {
    float[] inputs = new float[] { random(0, 1), random(0, 1)};
    n.setInputs(inputs);
    n.forwardPropogate();
    float[] outputs = n.getOutputs();
    if(outputs[0] > outputs[1] && inputs[0] > inputs[1]) {
      println("(SUCCESS) { Inputs: (" + nf(inputs[0], 1, 4) + ", " + nf(inputs[1], 1, 4) + "), " + "Confidence that 1 is greater: " + nf(outputs[0]*100, 2, 4) + "%, Confidence that 2 is greater: " + nf(outputs[1]*100, 2, 4) + "% }");
    }
    else if(outputs[1] > outputs[0] && inputs[1] > inputs[0]) {
      println("(SUCCESS) { Inputs: (" + nf(inputs[0], 1, 4) + ", " + nf(inputs[1], 1, 4) + "), " + "Confidence that 1 is greater: " + nf(outputs[0]*100, 2, 4) + "%, Confidence that 2 is greater: " + nf(outputs[1]*100, 2, 4) + "% }");
    }
    else {
      println("(FAILURE) { Inputs: (" + nf(inputs[0], 1, 4) + ", " + nf(inputs[1], 1, 4) + "), " + "Confidence that 1 is greater: " + nf(outputs[0]*100, 2, 4) + "%, Confidence that 2 is greater: " + nf(outputs[1]*100, 2, 4) + "% }");
    }
  }
  println("\n");
  println("Test parameters: determine which input is greater");
  println("Accuracy: " + nf(accuracy*100, 2, 4) + "%");
  renderNetwork(n);
  
  cachedNetwork = n;
  cachedFileLocation = "Data/Test1.txt";
}

void test1Read(float[] inputs) {
  Network n = readNetwork("Data/Test1.txt");
  n.setInputs(inputs);
  n.forwardPropogate();
  renderNetwork(n);
}

void test2() { // Linear regression towards x^2
  int[] sizes = new int[] { 1, 16, 24, 24, 16, 1 };
  Network n = new Network(sizes, 650, 700, 85, 25, "SIGMOID");
  float learningRate = 5;
  for(int i = 0; i < 100000; i++) {
    float[] inputs = new float[] { random(0, 1) };
    n.setInputs(inputs);
    n.forwardPropogate();
    n.backwardPropogate(new float[] {inputs[0]*inputs[0]}, learningRate);
  }
  
  float totalDeviation = 0;
  for(int i = 0; i < 10000; i++) {
    float[] inputs = new float[] { random(0, 1)};
    n.setInputs(inputs);
    n.forwardPropogate();
    float[] outputs = n.getOutputs();
    totalDeviation += abs(inputs[0]*inputs[0]-outputs[0]);
  }
  float averageDeviation = totalDeviation/10000;
  
  println("Test parameters: linear regression to x^2");
  println("Average Deviation: " + averageDeviation);
  renderNetwork(n);
  
  cachedNetwork = n;
  cachedFileLocation = "Data/Test2.txt";
}

void test2Read() { 
  
}

void test3() { // Selection of highest of 5 input values
int[] sizes = new int[] { 5, 15, 15, 15, 15, 15, 5 };
  Network n = new Network(sizes, 650, 700, 85, 25, "SIGMOID");
  float learningRate = .4;
  for(int i = 0; i < 10000000; i++) {
    float[] inputs = new float[] { random(0, 1), random(0, 1), random(0, 1), random(0, 1), random(0, 1)};
    n.setInputs(inputs);
    n.forwardPropogate();
    
    float highestValue = inputs[0];
    int highestIndex = 0;
    for(int j = 1; j < inputs.length; j++) {
      if(inputs[j]>highestValue) {
        highestIndex = j;
        highestValue = inputs[j];
      }
    }
    
    float[] expectedOutputs = new float[5];
    for(int j = 0; j < expectedOutputs.length; j++) {
      if(j==highestIndex) {
        expectedOutputs[j] = 1;
      }
      else {
        expectedOutputs[j] = 0;
      }
    }
    
    if(inputs[0] > inputs[1]) {
      n.backwardPropogate(expectedOutputs, learningRate);
    }
    else {
      n.backwardPropogate(expectedOutputs, learningRate);
    }
  }
  float totalCorrect = 0;
  for(int i = 0; i < 10000; i++) {
    float[] inputs = new float[] { random(0, 1), random(0, 1), random(0, 1), random(0, 1), random(0, 1) };
    n.setInputs(inputs);
    n.forwardPropogate();
    float[] outputs = n.getOutputs();
    
    float highestValue = inputs[0];
    int highestIndex = 0;
    for(int j = 1; j < inputs.length; j++) {
      if(inputs[j]>highestValue) {
        highestIndex = j;
        highestValue = inputs[j];
      }
    }
    
    int selection = 0; // this will represent the ai's selection
    float highest = outputs[0];
    for(int j = 1; j < outputs.length; j++) {
      if(outputs[j]>highest) {
        highest = outputs[j];
        selection = j;
      }
    }
    
    if(selection==highestIndex) {
      totalCorrect++;
    }
  }
  float accuracy = totalCorrect/10000;
  
  println("Test parameters: determine which input is greater");
  println("Accuracy: " + nf(accuracy*100, 2, 4) + "%");
  renderNetwork(n);
  
  cachedNetwork = n;
  cachedFileLocation = "Data/Test3.txt";
}
