
//button event class
class Blob {
  ArrayList<PVector> vertices; //for each vertex of the shape
  ArrayList<PShape> shapes; //layering up all the blobs
  PVector pos; //pos for center
  float size;
  int rate; //for size decreasing of layered blobs
  PVector add; //for movement: depending on the event, its either increasing proportionally or with noise function
  color cS, cE, cF; //lerp color start, end, fill in color
  //boolean wobble; 
  float a, localA; //a: movement acc when event happens, localA: normal acc

  int countAdd; //lifespan for the event 


  Blob(PVector _pos, int _rate, float _size, color _cS, color _cE) {
    pos = _pos;
    size = _size; //size for largest blob
    rate = _rate; 
    cS = _cS;
    cE = _cE;
    cF = color(255);
    //wobble = false;
    localA = 0; 

    vertices = new ArrayList<PVector>(); 
    shapes = new ArrayList<PShape>(); 
    a = 0; 

    //store each vertex pos
    for (float i = 0; i < TWO_PI; i += 0.08) {
      PVector vertex = new PVector(pos.x + cos(i), pos.y + sin(i));
      vertices.add(vertex);
    }
  }

  void display() {
    //when button = 0: normal display, blob increase proportionally  
    if (localA < 100) {
      localA ++;
    } else {
      localA = 0;
    }

    //when button = 1, countAdd starts count down, event a start add up
    if (countAdd > 0) {
      countAdd --;
      a ++; 
      //println("countAdd: " + countAdd);
      //println("a: "+a);
    } else {
      a = 0;
    }

    //drawing the largest (bottom) to smallest (top) blob
    for (float j = size; j > 0; j -= rate) {

      //using normalized vector for noise function
      pushMatrix();
      translate(pos.x, pos.y); //using pos as center point to get norm

      beginShape();
      for (int i = 0; i < vertices.size(); i ++) {
        PVector norm = new PVector(vertices.get(i).x-pos.x, vertices.get(i).y-pos.y);
        float d = dist(vertices.get(i).x, vertices.get(i).y, pos.x, pos.y);
        norm = norm.div(d); 

        //when button = 1, add noise function for expanding
        if (countAdd > 0) {          
          float nX = noise(millis()*0.0006+norm.x);
          float nY = noise(millis()*0.0006+norm.y); //noise function based on time
          add = new PVector(nX*j*2+a, nY*j*2+a);          

          cF = lerpColor(cS, cE, j/150);
          fill(cF, map(a, 0, 150, 100, 0));
          //fill(cF, map(a, 0, 50, 100, 0));
          
          //when button = 0, normal expanding, no wobbly effect
        } else {
          add = new PVector(j+localA, j+localA);
          cF = color((map(j, size, 0, 255, 0)), map(localA, 0, 100, 100, 0)); 
          //cF = color((map(j, size, 0, 255, 0)), map(localA, 0, 50, 100, 0)); 
          fill(cF);
        } 

        fill(cF, map(a, 0, 100, 150, 0)); //** repeating, should probably delete this

        vertex(norm.x*add.x, norm.y*add.y);
      }
      endShape();
      popMatrix();
    }
    fill(0);
    //ellipse(pos.x, pos.y, 70, 70); //covering out the center for projection
  }
}