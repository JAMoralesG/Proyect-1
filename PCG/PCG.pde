
//Programa principal
import beads.*;
import java.util.*;
import controlP5.*;

int NB = 2;
float[] frecuencia = { 170, 250};

ControlP5 cp5;
ControlFont font;
float ganancia1 = .5;
float ganancia2 = .5;
float FrecuenciaS1, FrecuenciaS2, g1, g2;
int indiceSlider = 0;

Slider agregaSlider(String nombre, float min, float max, float inicial) {
  Slider slider;
  slider = cp5.addSlider(nombre).setRange(min, max).setSize(100, 10);
  slider.setPosition(50, 50 + 50 * indiceSlider);
  slider.getCaptionLabel().setFont(font);  // cambiar fuente de la etiqueta
  slider.getValueLabel().setFont(font);    // cambiar fuente del valor mostrado
  slider.setValue(inicial);
  indiceSlider++;
  return slider;
}

void setup(){
  size(1200,600);
  setupConexion(NB,frecuencia,ganancia1,ganancia2);
  
  PFont pfont = createFont("Arial",12);
  font = new ControlFont(pfont,12);
  cp5 = new ControlP5(this);
  agregaSlider("FrecuenciaS1",10,170,20);
  agregaSlider("FrecuenciaS2",50,250,100);
  agregaSlider("g1",0,1,.5);
  agregaSlider("g2",0,1,.5);
  
  ac.start();
}

void draw(){
  
  background(0);
  Scope(NB,setCambios(FrecuenciaS1, FrecuenciaS2, g1, g2));
  
}
