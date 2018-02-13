int      total = 2000;
float    centre_diameter = 400.0;
float    refuge_diameter = 400.0;
float    side_bar_width;
boolean  trial = false;
boolean  standby = true;

//[offset-up] Have you ever seen this syntax before? This is a new feature in Java 1.6 (called "generics") that Processing now supports. It allows us to specify in advance what type of object we intend to put in the ArrayList.
ArrayList<Particle> plist = new ArrayList<Particle>();

void setup() {
  //size(800, 800);
  fullScreen();
  side_bar_width = (width - height)/2 - 20; 
  PVector centre =  new PVector(width/2, height/2);
  
  for (int i = 0; i < total; i++) {
    // An object is added to an ArrayList with add().
    plist.add(new Particle(PVector.random2D().mult(random(width)/1.5).add(centre)));
  }
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    trial = !trial;
  }
  
  if (key == 's' || key == 'S') {
    standby = !standby;
  }
}

void draw() {
  background(255);
  stroke(0);
  fill(0);
  
  if (!standby) {
    if (!trial) {
      for (int i = 0; i < plist.size(); i++) {
        // An object is accessed from the ArrayList with get().  Because we are using generics, we do not need to specify a type when we pull objects out of the ArrayList.
        Particle p = plist.get(i);
        p.run();
      }
      
      ellipse(width/2, height/2, centre_diameter, centre_diameter);
    }
    else if (trial) {
      ellipse(side_bar_width, height/2, refuge_diameter, refuge_diameter);
      ellipse(width - side_bar_width, height/2, refuge_diameter, refuge_diameter);
      //ellipse(width/2, 0.0, refuge_diameter, refuge_diameter);
      //ellipse(width/2, height, refuge_diameter, refuge_diameter);
    }
  }
  
  squareDisplay();
}

class Particle {
  PVector location;
  PVector velocity;
  float   speed;
  float   diameter;

  Particle(PVector l) {
    //[offset-up] For demonstration purposes we assign the Particle an initial velocity and constant acceleration.
    velocity = new PVector(random(-1,1),random(-2,0));
    location = l.get();
    speed    = 3.0;
    diameter = 8.0;
  }

  // Sometimes it’s convenient to have a “run”
  // function that calls all the other functions we need.
  void run() {
    update();
    display();
  }

  void update() {
    PVector centre = new PVector(width/2, height/2);
    velocity.add(PVector .sub(centre, location).normalize().mult(speed));
    location.add(velocity);
    
    if (PVector .sub(centre, location).mag() < centre_diameter/2) {
      location.add(PVector.random2D().mult(height/1.5));
    }
    
    velocity.set(new PVector(0.0, 0.0));
  }

  void display() {
    stroke(0);
    fill(0);
    ellipse(location.x, location.y, diameter, diameter);
  }
}

void squareDisplay() {
  fill(0);
  rect(0, 0, side_bar_width, height);
  rect(width - side_bar_width, 0, side_bar_width, height);
}