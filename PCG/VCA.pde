class VCA extends UGen {
  float ganancia;
  float indice_modulacion;
  
  VCA(AudioContext ac) { super(ac, 2, 1); ganancia = 0; }
  
  void setGanancia(float g) { ganancia = g; }
  float getGanancia() { return ganancia; }
  
  void setIndice(float i) { indice_modulacion = i; }
  float getIndice() { return indice_modulacion; }
  
  // Métodos para agregar señal portadora o moduladora
  void addPortadora(UGen ugen) { addInput(0, ugen, 0); }
  void addPortadora(UGen ugen, int canal) { addInput(0, ugen, canal); }
  void addModuladora(UGen ugen) { addInput(1, ugen, 0); }
  void addModuladora(UGen ugen, int canal) { addInput(1, ugen, canal); }
  
  
  void calculateBuffer() {
    float[] in = bufIn[0];
    float[] mod = bufIn[1];
    float[] out = bufOut[0];
    for (int i = 0; i < bufferSize; i++) {
      out[i] = (ganancia + indice_modulacion * mod[i]) * in[i];
    }
  }
}

class Crusher extends VCA {
  Crusher(AudioContext ac){
    super(ac);
  }
  void calculateBuffer(){
    float[] in = bufIn[0];
    float[] mod = bufIn[1];
    float[] out = bufOut[0];
    float bits;
    float levels;
    
    for (int i = 0; i < bufferSize; i++){
      bits = 15* constrain(1- (ganancia + indice_modulacion*mod[i]), 0, 1);
      levels = pow(2, bits);
      out[i] = round(in[i]*levels)/levels;
    }
  }
}

class Shaper extends VCA {
  Shaper(AudioContext ac){
    super(ac);
  }
  void calculateBuffer(){
    float [] in = bufIn[0];
    float [] mod = bufIn[1];
    float [] out = bufOut[0];
    float alpha;
    
    for (int i = 0; i < bufferSize; i++){
      alpha = 1 - (ganancia + indice_modulacion*mod[i]);
      out[i] = (in[i] >= 0)?pow(in[i],alpha):-pow(-in[i],alpha);
    }
  }
}
