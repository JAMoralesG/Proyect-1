//Conexiones necesarias e implementación del banco de filtros

AudioContext ac;
Mezclador ampIN;
UGen audioInput;
Exponencial env;
VCA AmpR, AmpF;
VCF Filtro;
Amplimetro[] AM;
FiltroPBR[] fil;

void setupConexion(int NB,float[] frecuencia,float g1, float g2){
  int[] canales = new int[2];
  canales[0] = 1;
  canales[1] = 2;
  
  ac = new AudioContext();
  audioInput = ac.getAudioInput(canales);
  ampIN = new Mezclador(ac,2);
  fil = new FiltroPBR[NB];
  AM = new Amplimetro[NB];
  AmpR = new Crusher(ac);
  AmpF = new Shaper(ac);
  env = new Exponencial(ac);
  Filtro = new VCF(ac);
  
  //Envolvente exponencial
  env.addInput(audioInput);
  //Mezclador
  ampIN.addInput(audioInput);
  ampIN.setGs(1, 1);
  ampIN.setGs(2, 1);
  //Reducción de resolución
  AmpR.addPortadora(ampIN);
  AmpR.addModuladora(env);
  AmpR.setGanancia(1);
  AmpR.setIndice(1);
  //VCF
  Filtro.addPortadora(AmpR);
  Filtro.addModuladora(env);
  Filtro.setIndice(1);
  Filtro.setFrecuencia(300);
  //Saturación suave
  AmpF.addPortadora(Filtro);
  AmpF.addModuladora(env);
     
  //BancoFiltros
  for(int i = 0; i < NB; i++){
    fil[i] = new FiltroPBR(ac);
    fil[i].setFrecuencia(frecuencia[i]);
    fil[i].setQ(5);
    fil[i].setCompensacion(1);
    fil[i].addInput(AmpF);  ;
  //Seguidor de envolvente 
    AM[i] = new Amplimetro(ac,2);
    AM[i].addInput(fil[i]);
    AM[i].setTipo(Amplimetro.PEAK);
    ac.out.addDependent(AM[i]);
  }
}

//Establecemos los cambios 
//que se realizan desde la interfaz grafica
float[] setCambios(float frecuencia1, float frecuencia2,float _g1,float _g2){
  float[] newfrecuencia = {frecuencia1, frecuencia2};

  ampIN.setGs(1, _g1);
  ampIN.setGs(2, _g2);
  
  Filtro.setIndice(_g2);
  
  AmpR.setGanancia(_g1);
  AmpR.setIndice(_g2);
  
  for(int i = 0; i < NB; i++){
    fil[i].setFrecuencia(newfrecuencia[i]);
  }
  return newfrecuencia;
}
