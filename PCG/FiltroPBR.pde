// Filtro PasaBanda Resonante

class FiltroPBR extends UGen {
  // parámetros
  float frecuencia;  // frecuencia de interés en Hertz
  float Q;           // factor de calidad del filtro
  float s;           // exponente de compensación de ganancia
  
  // variables auxiliares
  float ynm1, ynm2, xnm1, xnm2;
  float a1, a2, b0, b2;
  
  FiltroPBR(AudioContext ac) {
    super(ac, 2, 1);
    frecuencia = ac.getSampleRate() / 2;
    Q = 1;
    s = 0.6;
    calculaCoeficientes();
  }
  
  void purgar() { ynm1 = 0; ynm2 = 0; }
  
  void setFrecuencia(float f) { 
    frecuencia = constrain(f, 0, context.getSampleRate() / 2);
    calculaCoeficientes();
  }
  
  float getFrecuencia() { return frecuencia; }
  
  void setQ(float _Q) {
    Q = max(_Q, 1);
    calculaCoeficientes();
  }
  
  float getQ() { return Q; }
  
  void setCompensacion(float _s) {
    s = constrain(_s, 0, 1);
    calculaCoeficientes();
  }
  
  float getCompensacion() { return s; }
    
  
  void calculaCoeficientes(float omega) {
    float p = max(1 - omega / Q, 0);
    a1 = 2 * p * cos(omega);
    a2 = -p * p;
    b0 = pow(1 - p, s);
    b2 = -p;
  }
  
  void calculaCoeficientes() {
    calculaCoeficientes(2 * PI * frecuencia / context.getSampleRate());
  }
  
  void calculateBuffer() {
    float[] x = bufIn[0];
    float[] y = bufOut[0];
    float b0xn;
    calculaCoeficientes();
    for (int n = 0; n < bufferSize; n++) {
      b0xn = b0 * x[n];
      y[n] = a1 * ynm1 + a2 * ynm2 + b0xn + b2 * xnm2;
      ynm2 = ynm1;
      ynm1 = y[n];
      
      xnm2 = xnm1;
      xnm1 = b0xn;
    }
  }
}

// VCF = Voltage Controlled Filter
// Filtro pasabanda resonante con modulación de frecuencia

class VCF extends FiltroPBR {
  float indiceModulacion;
  
  // constructor
  VCF(AudioContext ac) { super(ac); }
  
  void addPortadora(UGen ug) { addInput(0, ug, 0); }
  void addModuladora(UGen ug) { addInput(1, ug, 0); }
  
  void setIndice(float i) { indiceModulacion = i; }
  float getIndice() { return indiceModulacion; }
  
  // calculateBuffer
  void calculateBuffer() {
    float[] x = bufIn[0];
    float[] z = bufIn[1];
    float[] y = bufOut[0];
    float b0xn;
    float omega = 2 * PI * frecuencia / context.getSampleRate();

    for (int n = 0; n < bufferSize; n++) {
      calculaCoeficientes(omega * pow(2, indiceModulacion * z[n]));
      b0xn = b0 * x[n];
      y[n] = a1 * ynm1 + a2 * ynm2 + b0xn + b2 * xnm2;
      ynm2 = ynm1;
      ynm1 = y[n];
      
      xnm2 = xnm1;
      xnm1 = b0xn;
    }
  } 
}
