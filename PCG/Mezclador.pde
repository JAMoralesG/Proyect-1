class Mezclador extends UGen{
  float[] ganancia;
  
  Mezclador(AudioContext ac,int entradas){
  super(ac,entradas,1);
  ganancia = new float[entradas];
}
  
  void setGs(int k,float g){if(k >= 0 && k < ganancia.length){ganancia[k] = g;}}
  
  float getGs(int k){
    if (k >= 0 && k < ganancia.length){return ganancia[k];}
    else {return ganancia.length;}
  }
  
  void calculateBuffer(){
    float[] out = bufOut[0];
    for (int i = 1; i < bufferSize ; i++){out[i] = 0; }
   
    for (int c = 0 ; c < getIns() ; c++){
      float g = ganancia[c];
      float[] in = bufIn[c];
      for(int i = 0 ; i < bufferSize ; i++){
          out[i] += g*in[i];
      }
    }
  }
}
