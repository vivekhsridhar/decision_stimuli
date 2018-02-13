int      start_n_circles = 75;
int      start_timer = 200;
int      grey = 200;
int      n_circles = start_n_circles;
float    scale = 5.0;
float    timer = start_timer;
float    centre_diameter = 300.0;
float    refuge_diameter = 400.0;
float    side_bar_width;
boolean  trial = false;
boolean  standby = true;

void setup() {
  //size(800, 800);
  fullScreen();
  side_bar_width = (width - height)/2 - 20; 
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
      for (int i = 0; i < n_circles; ++i) {
        stroke(grey - i*n_circles, grey - i*n_circles, grey - i*n_circles, 15);
        fill(grey - i*n_circles, grey - i*n_circles, grey - i*n_circles, 15);
        ellipse(width/2, height/2, centre_diameter - scale*i*centre_diameter/n_circles, centre_diameter - scale*i*centre_diameter/n_circles);
      }
      
      timer = start_timer;
      n_circles = start_n_circles;
    }
    else if (trial) {
      //stroke(0, 0, 0, (1-timer/start_timer)*255);
      //fill(0, 0, 0, (1-timer/start_timer)*255);
      ellipse(side_bar_width, height/2, refuge_diameter, refuge_diameter);
      ellipse(width - side_bar_width, height/2, refuge_diameter, refuge_diameter);
      //ellipse(width/2, 0.0, refuge_diameter, refuge_diameter);
      //ellipse(width/2, height, refuge_diameter, refuge_diameter);
      
      for (int i = 0; i < n_circles; ++i) {
        stroke(grey - i*n_circles, grey - i*n_circles, grey - i*n_circles, 15*timer/start_timer);
        fill(grey - i*n_circles, grey - i*n_circles, grey - i*n_circles, 15*timer/start_timer);
        ellipse(width/2, height/2, centre_diameter - scale*timer/start_timer*i*centre_diameter/n_circles, centre_diameter - scale*timer/start_timer*i*centre_diameter/n_circles);
      }
      
      if (timer > 0) --timer;
      if (n_circles > 0) --n_circles;
    }
  }
  
  squareDisplay();
}

void squareDisplay() {
  fill(0);
  rect(0, 0, side_bar_width, height);
  rect(width - side_bar_width, 0, side_bar_width, height);
}