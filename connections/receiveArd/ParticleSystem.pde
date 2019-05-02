
//pot event class
class ParticleSystem {
  float x, y; //position of the swirl
  float ang, r, amp; //** prob don't need these three anymore?
  color cS, cE; //lerp color start and end
  float lerpSt; //lerp steps
  ArrayList<Particle> p;
  float upRand; //update randomness based on pot input

  ParticleSystem(float _x, float _y, float _ang, float _amp, float _r, color _cS, color _cE) {
    p = new ArrayList<Particle>();
    x = _x;
    y = _y;
    ang = _ang;
    amp = _amp;
    r = _r;
    cS = _cS;
    cE = _cE;
    lerpSt = 0;
    upRand = 0;
  }

  //update transparency
  void update(float t) {
    Particle b = new Particle(x, y, cS, cE); //pos, lerp color start, end
    p.add(b);

    for (int i = p.size()-1; i >= 0; i--) {
      lerpSt += 0.02;
      Particle temp = p.get(i); 
      temp.dx += random(-upRand, upRand);
      temp.update();
      temp.display(t, lerpSt); //transparency, lerp steps

      //remove old particles
      if (temp.life < 0) {
        lerpSt = 0;
        p.remove(i);
      }
    }
  }
}