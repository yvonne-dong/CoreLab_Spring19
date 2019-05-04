
/*
 input: Serial data from Arduino
 output: OSC signal to Sonic Pi
 OSC example: OSCsendreceive (http://www.sojamo.de/oscP5)
*/

//libraries
//import codeanticode.syphon.*; //send Processing to Mad Mapper
import processing.serial.*; //read Serial from Arduino
import oscP5.*; //send OSC to Sonic Pi
import netP5.*; //send OSC to Sonic Pi (net)

//** not sure if we need them but I'll leave them for now
import controlP5.*; //send OSC to Sonic Pi (control P5)
import codeanticode.syphon.*;

SyphonServer server;
//set up OSC port
OscP5 oscP5; 
NetAddress sonicPi;

int sound = 0; // ** do I still need this sound thingy
//boolean callsendNote = true; 

//set up Serial port
Serial myPort; 
String val; //Serial signal input 
//** change to ArrayList<int>?
int nums[] = {0, 0, 0, 0, 0};
int cNums[] = {0, 0, 0, 0, 0};

//color palettes - haven't use this yet
color lerpCs[] = {color(111, 0, 205), color(252, 134, 29), color(44, 218, 255)};

//for pot visuals
ArrayList<ParticleSystem> systems = new ArrayList<ParticleSystem>();
float time, fLerp; //** do I need this time thingy? //fLerp: have lerp color or not

int push = 10; //** do I need this for counting?
boolean pushY = false; //** do I need this?
int sBefore, sAfter; //** do I need this?

//for button visuals
ArrayList<Blob> blobs = new ArrayList<Blob>();


void setup() {

  //would be fullScreen
  //size(600, 600, P3D);
  fullScreen(P3D);

  //initiate OSC
  oscP5 = new OscP5(this, 8000); //listening on this port
  sonicPi = new NetAddress("127.0.0.1", 4559);
  server = new SyphonServer(this, "Processing Syphon");
  //initiate visuals
  int b = 160; //add position to fit in grid for projection mapping

  //set up swirls: pos x, pos y, start ang, amplitude, rate, lerp color start & color end
  //theme colors: color(111, 0, 205), color(252, 134, 29), color(44, 218, 255)
  systems.add(new ParticleSystem(width/3 + b/2, height/2 + b, 0, 4, 0.03, color(255), color(255)));
  systems.add(new ParticleSystem(width/3 * 2 + b/2, b, 0, 4, 0.03, color(255), color(255)));

  //setup blobs: pos(x,y), rate, size, lerp color start & color end
  //theme colors: color(111, 0, 205), color(252, 134, 29), color(44, 218, 255)
  PVector pos1 = new PVector(b, b);
  PVector pos2 = new PVector(b, height/2 + b);
  PVector pos3 = new PVector(width/3 + b, b);
  blobs.add(new Blob(pos1, 5, 80, color(111, 0, 205), color(44, 218, 255)));
  blobs.add(new Blob(pos2, 5, 80, color(111, 0, 205), color(252, 134, 29)));
  blobs.add(new Blob(pos3, 5, 80, color(252, 134, 29), color(44, 218, 255)));
  noStroke();

  push = 0; //** do I need this for counting?

  //initiate Serial
  String portName = Serial.list()[7];
  myPort = new Serial(this, portName, 9600);
}

void draw() {
  background(0);
  time ++; //** do I need this time thingy?

  //visual displays
  for (int i = 0; i < systems.size(); i++) {
    updateSwirl(i); //display should be called display + update, for some reason it's not in the ParticleSystem class IDK y
  }
  for (int j = 0; j < blobs.size(); j ++) {
    Blob thisB = blobs.get(j); 
    thisB.display(); //display blob
  } 

  //call serial function
  
  serialEvent(myPort); //** check income signal here or change to ArrayList?
  server.sendScreen();
}

//function to send OSC signal
//example: OSCsendreceive (http://www.sojamo.de/oscP5)
void sendOscNote() {
  //OSC messages start with "/"
  OscMessage toSend = new OscMessage("/toPi");
  //print(nums[0]+" ");
  //print(nums[1]+" ");
  //print(nums[2]+" ");
  //print(nums[3]+" ");
  //print(nums[4]+" ");
  //println(" ");

  //attach Serial array to OSC message and send it (0-2: 0/1 showing which button is pushed, 3,4: pot value input)
  toSend.add(nums); 
  oscP5.send(toSend, sonicPi);
}

//function for button event, parameter: index of button in Serial array
void buttonEvent(int button) {
  for (int i = 0; i < nums.length; i ++) {
    //just to check if it is 0-2, should probably change the way of writing this
    if (button == i && i < 3) {
      //when button = 1, call OSC function 
      sendOscNote(); 
      //set up a countdown for button event (because button value goes back immpediately to 0 when released) 
      blobs.get(button).countAdd = 100;
    } else {      
      //when button = 0: normal display, white 
      for (int j = 0; j < blobs.size(); j ++) {
        blobs.get(j).a = 0; //** do I need to reset a to 0...?
      }
      push = 0; //** do I need this for counting?
    }
  }
}

void potEvent(int whichPot, int pot) { 
  for (int i = 3; i < nums.length; i ++) {
    //int note = int(map(pot, 0, 1023, 0, 100));  
    nums[whichPot+3] = pot; //add input value to the OSC array
    sendOscNote(); //pot at Sonic Pi side: prc[0] = 4, 5, prc[1] = input value
  }

  //random factor for particle movements
  float swirlP = map(pot, 0, 1023, 0, 0.5); 
  //when pot val > 0: enable lerp color
  if (pot > 0) {
    fLerp = 1; 
    systems.get(whichPot).upRand = swirlP; //add random factor to particle movements
    //different color scheme for the two swirls
    if (whichPot == 0) { 
      systems.get(whichPot).cS = color(111, 1, 205);
      systems.get(whichPot).cE = color(252, 134, 29);
    } else if (whichPot == 1) {
      systems.get(whichPot).cS = color(111, 0, 205);
      systems.get(whichPot).cE = color(44, 218, 255);
    }

    //when pot val = 0: no lerp color (white)
  } else {
    //fLerp = 0
    systems.get(whichPot).cS = color(255);
    systems.get(whichPot).cE = color(255);
  }
}


void serialEvent(Serial myPort) {
  if ( myPort.available() > 0) { 
    val = myPort.readStringUntil('\n'); 
    
    println("gfjfk");
    
    if (val != null) {
      val = trim(val);
      if (int(split(val, ".")).length == 5) {
        nums = int(split(val, "."));
      }

      //println(val);
      for (int i = 0; i < nums.length; i ++) {
        if (nums[i] != cNums[i]) {
          cNums[i] = nums[i];
          //array [0],[1],[2]: buttons
          if (i < 3) {
            if (nums[i] == 1) {
              buttonEvent(i);
            }

            //array [3],[4]: pot
          } else if (i >= 3) {            
            potEvent(i-3, nums[i]);
          }
        }
      }
    }
  }
}

//function to display + update swirls, for some reason it's not in the ParticleSystem Class IDK y
void updateSwirl(int whichSwirl) {
  ParticleSystem thisSwirl = systems.get(whichSwirl);
  //angle update clockwise
  thisSwirl.x = thisSwirl.x+sin(thisSwirl.ang)*thisSwirl.amp;
  thisSwirl.y = thisSwirl.y+cos(thisSwirl.ang)*thisSwirl.amp;
  thisSwirl.ang += thisSwirl.r;

  //t: transparency of particles (newest -> oldest: opaque -> transparent)
  //** should prob be 100 instead of 255
  float t = map(sin(thisSwirl.ang)*thisSwirl.amp, -4, 4, 5, 255);

  //visual before interaction: no lerp color 
  if (fLerp == 0) {
    thisSwirl.cS = color(255);
    thisSwirl.cE = color(255);
  }

  //call ParticleSystem class update function, pass in transparency
  thisSwirl.update(t);

  //** do I need this time thingy?
  if (time > 300) {
    time = 0;
  }
}