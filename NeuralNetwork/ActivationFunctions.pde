class ActivationFunction {
 String mode; // "RELU" or "SIGMOID" as of now
 
 float getActivation(float input) {
   if(mode.equals("SIGMOID")) {
     return 1/(1+exp(-input));
   }
   else if (mode.equals("RELU")) {
     if(input <= 0) {
      return 0; 
     }
     else {
      return input; 
     }
   }
   else { // should not ever happen
     return 0;
   }
 }
 
 float getDerivativeByOutput(float output) { // should be the output of the activation function
  if(mode.equals("SIGMOID")) {
     return output * (1 - output);
   }
   else if (mode.equals("RELU")) {
     if(output <= 0) {
      return 0; 
     }
     else {
      return 1; 
     }
   }
   else { // should not ever happen
     return 0;
   }
 }
 
 float getDerivativeByInput(float input) { // should be the input of the activation function
   if(mode.equals("SIGMOID")) {
     return exp(input)/((1+exp(input))*(1+exp(input)));
   }
   else if (mode.equals("RELU")) {
     if(input <= 0) {
      return 0; 
     }
     else {
      return 1; 
     }
   }
   else { // should not ever happen
     return 0;
   }
 }
 
 ActivationFunction(String mode) {
  this.mode = mode; 
 }
}
