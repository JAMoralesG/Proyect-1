
void simplescopio(float[] buffer) {
  int x, t;
  float[] y = new float[width];
  float dt = (float)buffer.length / width;
  for (x = 0; x < width; x++) {
    t = (int)(x * dt);
    y[x] = height/2 - buffer[t] * height / 4;
  }
  for (x = 0; x < width - 1; x++) {
    line(x, y[x], x+1, y[x+1]);
  }
}
//Graficas que nos permite observar el comportamiento de la entrada fisica 
//y la salida de cada filtro
void Scope(int NB,float[] frecuencia){
  fill(255);
  pushMatrix();
  translate(0, -height / 4);
  stroke(0, 255, 0);
  simplescopio(audioInput.getOutBuffer(0));
  translate(0, height / 4);
  stroke(255, 0, 255);
  simplescopio(fil[0].getOutBuffer(0));
  translate(0, height / 4);
  stroke(255, 255, 0);
  simplescopio(fil[1].getOutBuffer(0));
  popMatrix();
  float dx = width / NB;
  float xi, y, a;
  textAlign(CENTER, CENTER);
  //Barras que muestran la
  //energía de cada filtro 
  for (int i = 0; i < NB; i++) {
    xi = dx * i;
    a = 0.25 * (AM[i].getAmplitud(0) + AM[i].getAmplitud(1));
    y = a * (height - 100);
    stroke(255, 255, 0, a * 128 + 64);
    fill(200, 200, 0, a * 200);
    rect(xi + 1, height - 50 - y, dx - 2, y, 10);
    fill(255);
    text(frecuencia[i] + " Hz", xi + dx / 2, height - 50 );
  }
}
