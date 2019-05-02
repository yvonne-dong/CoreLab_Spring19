
//pot event class (for PartSys)
class Particle {
  float x, y; //position of the particle
  float dx, dy; //speed 
  color cStart, cEnd, cFill; //lerp color
  float s; //sizes
  float life; //remove at certain num 

  Particle(float _x, float _y, color _cS, color _cE) {
    x = _x;
    y = _y;
    dx = random(-0.5, 0.5);
    dy = 0; 
    cStart = _cS;
    cEnd = _cE;
    cFill = color(255);
    s = 30;
    //s = random(40, 100); 
    life = 80;
  }

  //pass in transparency, lerp steps
  void display(float f, float _c) {
    noStroke();
    cFill = lerpColor(cStart, cEnd, _c);
    fill(cFill, f);
    ellipse(x, y, s, s);
  }

  void update() {
    life --;
    s = map(life, 80, 0, 30, 0);
    x += dx;
    y += dy;
  }
}