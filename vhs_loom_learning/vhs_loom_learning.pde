import java.io.*;
import java.util.*;
import java.text.DecimalFormat;
import ketai.net.KetaiNet;

// Logging setup
FileWriter fw;
BufferedWriter bw;
DecimalFormat formatter = new DecimalFormat("###.#");

// Global parameters
int      start_n_circles = 75;         // ncircles reset value
int      start_timer = 200;            // timer reset value
int      start_loom_dist = 10000;      // loom_dist reset value
int      grey = 200;                   // parameter for colour of start and choice locations
int      n_circles = start_n_circles;  // number of circles to create gradient in start ellipse
int      stage = 0;                    // 0 = standby; 1 = trial start; 2 = choice experiment
float    scale = 8.0;                  // scales the size of the start ellipse
float    timer = start_timer;          // timer for start ellipse to disappear
float    centre_diameter_x = 500.0;    // major axis of start ellipse
float    centre_diameter_y = 250.0;    // minor axis of start ellipse
float    side_bar_width;               // black bars to ensure squareness of frame
float    loom_size = 10000.0;          // size of approaching loom (remains const)
float    loom_dist = start_loom_dist;  // start distance of loom
float    loom_speed = 30.0;            // speed of approaching loom
float    loom_diameter = 2*loom_size / loom_dist;
boolean  trial = false;                // boolean to toggle trial start-stop
boolean  standby = true;               // boolean to toggle standby

String myIP;
int IPVal;
int [] IPinfo;

void setup() {
  myIP = KetaiNet.getIP();
  IPinfo = int(split(myIP, "."));
  IPVal = IPinfo[3] - 100;
  
  println("IP ADDRESS IS: ", myIP, ". IPVAL IS: ", str(IPVal));
  
  fullScreen();
  side_bar_width = (width - height)/2 - 20; 
  
  String start = (myIP + '\t' + write() + '\t' + "-------- Trial started --------" + '\n');
  logEntry(start, true);
}

void keyPressed() {
  if (key == 't' || key == 'T') {
    trial = !trial;
    String message = (myIP + '\t' + write() + '\t' + "trial" + '\t' + str(trial) + '\n');
    logEntry(message, true);
  }
  
  if (key == 's' || key == 'S') {
    standby = !standby;
    String message = (myIP + '\t' + write() + '\t' + "standby" + '\t' + str(standby) + '\n');
    logEntry(message, true);
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
        ellipse(width/2, 0.0, centre_diameter_x - scale*i*centre_diameter_x/n_circles, centre_diameter_y - scale*i*centre_diameter_y/n_circles);
      }
      
      timer = start_timer;
      n_circles = start_n_circles;
    }
    else if (trial) {
      stroke(0, 0, 0, 20);
      fill(0, 0, 0, 20);
      
      for (int i = 0; i < n_circles; ++i) {
        stroke(grey - i*n_circles, grey - i*n_circles, grey - i*n_circles, 15*timer/start_timer);
        fill(grey - i*n_circles, grey - i*n_circles, grey - i*n_circles, 15*timer/start_timer);
        ellipse(width/2, 0.0, centre_diameter_x - scale*i*centre_diameter_x/n_circles, centre_diameter_y - scale*i*centre_diameter_y/n_circles);
      }
      
      stroke(0);
      fill(0);
      ellipse(side_bar_width/2 + width/4, 3*height/4, loom_diameter, loom_diameter);
      
      if (timer > 0) --timer;
      if (n_circles > 0) --n_circles;
      if (loom_dist > 10.0) loom_dist -= loom_speed;
      if (loom_dist <= 10.0) {
        loom_dist = start_loom_dist;
        standby = true;
        trial = false;
      }
      
      loom_diameter = loom_size / loom_dist; 
    }
  }
  
  if (stage == 0 && ((minute() == IPVal) ||  (minute() == IPVal+20) || (minute() == IPVal+40))) {
    standby = false;
    String message = (myIP + '\t' + write() + '\t' + "standby" + '\t' + str(standby) + '\t' + "trial" + '\t' + str(trial) + '\n');
    logEntry(message, true);
    stage = 1;
  }
  if (stage == 1 && ((minute() == IPVal+3) ||  (minute() == IPVal+23) || (minute() == IPVal+43))) {
    trial = true;
    String message = (myIP + '\t' + write() + '\t' + "standby" + '\t' + str(standby) + '\t' + "trial" + '\t' + str(trial) + '\n');
    logEntry(message, true);
    stage = 2;
  }
  if (stage == 2 && ((minute() == IPVal+5) ||  (minute() == IPVal+25) || (minute() == IPVal+45))) {
    standby = true;
    trial = false;
    String message = (myIP + '\t' + write() + '\t' + "reset standby and trial" + '\n');
    logEntry(message, true);
    stage = 0;
    
    String end = (myIP + '\t' + write() + '\t' + "-------- Trial ended successfully --------" + '\n');
    logEntry(end, true);
  }
  
  squareDisplay();
}

void squareDisplay() {
  fill(0);
  rect(0, 0, side_bar_width, height);
  rect(width - side_bar_width, 0, side_bar_width, height);
}

void logEntry(String msg, boolean append) { 
  try {
    File file =new File("/Users/viveksridhar/Desktop/vhs_logfile.txt");
    if (!file.exists()) {
      file.createNewFile();
    }
 
    FileWriter fw = new FileWriter(file, append);///true = append
    BufferedWriter bw = new BufferedWriter(fw);
    PrintWriter pw = new PrintWriter(bw);

    pw.write(msg);
    pw.close();
  }
  catch(IOException ioe) {
    System.out.println("Exception ");
    ioe.printStackTrace();
  }
}

public String write(){
  Calendar cal = Calendar.getInstance(TimeZone.getTimeZone("GMT"));
  String time_now;
  time_now = formatter.format(cal.getTimeInMillis());
  return time_now;
}