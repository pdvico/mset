// coordinates for rect selection
int rectStartX,rectStartY,rectEndX,rectEndY;

// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
double xmin, ymin;
double w,h;

// Maximum number of iterations for each point on the complex plane
int maxiterations;

double xmax,ymax;
double dx,dy;
  
PImage juliaImages;
  
int currentFrame, maxFrames;  
int tictac;
int iFrame;
boolean zoomSelected;

boolean playingSound;
boolean allowReset;
   
//optimized for ipad - horizontal mode

void setup(){
  size(480, 640);
  stroke(6);
  fill(0,0); 
  background(255);

  rectStartX=0;
  rectStartY=0;
  rectEndX=width;
  rectEndY=height; 
  
  juliaImages = new PImage[8];
  currentFrame = 0;
  maxFrames = 7;
  tictac = 0;
  iFrame = 0;
  maxiterations = 100;
  xmin = -1.5;
  ymin = -2.5;
  w = 3;
  h = 4;
  playingSound = false;
  zoomSelected=true;
  allowReset=false;
  
}

void draw(){
  // Make sure we can write to the pixels[] array.
  if (currentFrame <= maxFrames) {

     if (zoomSelected){
       loadPixels();  
       calcularMSet();
       updatePixels();
       juliaImages[currentFrame] = get(0,0,width,height);
       currentFrame++;
       maxiterations = maxiterations + 50; 
    //   println("maxiterations= " + maxiterations);
    //  println("currentFrame= " + currentFrame);
        zoomSelected=false;
      }

 
  }else{
    
    tictac++;
    
    //println("tictac = " + tictac);
    if (tictac % 60 == 0){
	if (!playingSound) {
		playSound();
		playingSound=true;
	     }		
      tictac=0;
      image(juliaImages[iFrame],0,0,width,height);
      iFrame++;
      //println("iFrame = " + iFrame);
      if (iFrame==maxFrames){
        iFrame = 0;
        allowReset=true;
      };
    }; 
  }
    
 
}

// respond to user interrect events


void mouseReleased(){

  
	if (currentFrame <= maxFrames) { 
      	  rectStartX=mouseX-37;
      	  rectStartY=mouseY-50;

      	  rectEndX=mouseX+38;
     	  rectEndY=mouseY+50; 
     	
      	  xmin = xmin + rectStartX*dx;
      	  ymin = ymin + rectStartY*dy;
          w = (rectEndX-rectStartX)*dx;
          h = (rectEndY - rectStartY)*dy;
    
       
	}else{
          if (allowReset){  
	    currentFrame = 0;
  	    tictac = 0;
            iFrame = 0;
            maxiterations = 100;
            xmin = -1.5;
            ymin = -2.5;
            w = 3;
            h = 4;
            stopSound();
            playingSound=false;
	    allowReset=false;
	  } 	
	}
  	zoomSelected=true;     
}


void calcularMSet(){
      
    // x goes from xmin to xmax
    //float xmax = xmin + w;
    xmax = xmin + w;
    
    // y goes from ymin to ymax
    //float ymax = ymin + h;
    ymax = ymin + h;
  
    // Calculate amount we increment x,y for each pixel
    //float dx = (xmax - xmin) / (width);
    dx = (xmax - xmin) / (width);
    //float dy = (ymax - ymin) / (height);  whose boundary is
    dy = (ymax - ymin) / (height); 
     
     // Start y
    float y = ymin;
    for (int j = 0; j < height; j++) {
      // Start x
      float x = xmin;
      for (int i = 0;  i < width; i++) {
    
        // Now we test, as we iterate z = z^2 + cm does z tend towards infinity?
        float a = y;
        float b = x;
        int n = 0;
        while (n < maxiterations) {
          float aa = a * a;
          float bb = b * b;
          float twoab = 2.0 * a * b;
          a = aa - bb + y;
          b = twoab + x;
          // Infinty in our finite world is simple, let's just consider it 16
          //if (aa + bb > 16.0) {
          if (aa + bb > 8.0) {
            break;  // Bail
          }
          n++;
        }
  
        // We color each pixel based on how long it takes to get to infinity
        // If we never got there, let's pick the color black
        if (n == maxiterations) {
          pixels[i+j*width] = color(0);
        } else {
          // Gosh, we could make fancy colors here if we wanted
          colorMode (HSB);
          pixels[i+j*width] = color(n*16 % 255,175,100 + n*8 % 255);
        }
        x += dx;
      }
      y += dy;
    }
    
 }

