//Seguidor de envolvente
class Amplimetro extends UGen {
  static final int PEAK = 0;
  static final int RMS = 1;
  float [] amplitud;
  int tipo;
  
  Amplimetro(AudioContext context, int canales){
    super(context, canales, 0);
    amplitud = new float[canales];
    Arrays.fill(amplitud,0);
    tipo = PEAK;
  }
  
  void setTipo(int t){ tipo=t;}
  
  int tipo(){return tipo;}
  
  float getAmplitud(int canal){
    return (canal >= 0 && canal < getIns())? amplitud[canal]:0;
  }
  
  void calculateBuffer(){
    float max;
    for (int c = 0; c < getIns();c++){
      float[] in = bufIn[c];
      switch(tipo){
        case PEAK: 
          max = 0;
          for (int i = 0; i < bufferSize; i++){
            if (abs(in[i]) > max ) max = abs(in[i]);
          }
          amplitud[c] = max;
          break;
        
        case RMS:
          amplitud[c] = 0;
          for (int  i = 0; i < bufferSize; i++){
            amplitud[c] += in[i]*in[i];
          }
          amplitud[c] = sqrt(amplitud[c]/bufferSize);
          break;
      }
    }
  }
}
