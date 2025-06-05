
class Exponencial extends UGen {
  float g; // factor de atenuación de la envolvente
  float y_anterior;
  float x_anterior;
  
  String secuencia;
  int indice;
  
  Exponencial(AudioContext ac) { 
    super(ac, 1, 1);
    setSecuencia("1");
  }
  
  void setDuracion(float t) {
    float delta_n = t * context.getSampleRate();
    float lambda = delta_n / log(2);
    g = exp(-1.0 / lambda);
  }
  
  void setSecuencia(String s) { secuencia = s; indice = 0; }
  
  void dispara() { y_anterior = 1; }
  
  void calculateBuffer() {
    float[] y = bufOut[0];
    float[] x = bufIn[0];
    for (int i = 0; i < bufferSize; i++) {
      y[i] = y_anterior;
      y_anterior *= g;
      
      // procesar señal de entrada para detectar cruces por cero
      if (x[i] * x_anterior < 0) {
        // detectar flanco positivo
        if (x[i] - x_anterior > 0) {
          if (secuencia.charAt(indice) > '0') {
            dispara();
          }
          indice = (indice + 1) % secuencia.length();
        }
      }
      x_anterior = x[i];
    }
  }
}
