// Button for rect selection
boolean rectSelection = false;

// coordinates for rect selection
int rectStartX,rectStartY,rectEndX,rectEndY;

// margin for selecting rect rectangle 
int marginX,marginY,marginW,marginH;

int copyrectX=0,copyrectY=0,copyrectWidth=0,copyrectHeight=0;
boolean rectSelected = false;

// Establish a range of values on the complex plane
// A different range will allow us to "zoom" in or out on the fractal
float xmin, ymin;
float w,h;

// Maximum number of iterations for each point on the complex plane
int maxiterations;

float xmax,ymax;
float dx,dy;
  
PImage juliaImages;
  
int currentFrame, maxFrames;  
int tictac;
int iFrame;
  
//optimized for ipad - horizontal mode

void setup(){
  size(480, 640);
  stroke(6);
  fill(0,0); 
  background(255);
  
  initRect();
  rectSelection = true;
  rectSelected = true;  

  juliaImages = new PImage[255];
  currentFrame = 0;
  maxFrames = 7;
  tictac = 0;
  iFrame = 0;
  maxiterations = 100;
  xmin = -1.5;
  ymin = -2.5;
  w = 3;
  h = 4;
  
}

void draw(){
  // Make sure we can write to the pixels[] array.
  if (currentFrame <= maxFrames) {
    if (rectSelected){
      loadPixels();  
      calcularMSet();
      updatePixels();
      juliaImages[currentFrame] = get(0,0,width,height);
      currentFrame++;
    //  println("currentFrame= " + currentFrame);
      rectSelected = false; 
    }else{ 
      if (rectSelection){
        image(juliaImages[currentFrame-1],0,0,width,height);
        rect(copyrectX+marginX,copyrectY+marginY,copyrectWidth+marginW,copyrectHeight+marginH);
      }      
    } 
  }else{
    tictac++;
   
    //println("tictac = " + tictac);
    if (tictac % 60 == 0){
      tictac=0;
      image(juliaImages[iFrame],0,0,width,height);
      iFrame++;
      //println("iFrame = " + iFrame);
      if (iFrame==maxFrames){
        iFrame = 0;
      };
    }; 
  }
    
 
}

// respond to user interrect events
void mousePressed(){
   
    if (rectSelection) {
         rectStartX=mouseX;
         rectStartY=mouseY;
       }
}
void mouseDragged(){
  
  //draw rect for selection
  if (rectSelection){
        rectEndX=mouseX;
        rectEndY=mouseY;     
        copyrectX = rectStartX;
        copyrectY = rectStartY;
        copyrectWidth = (rectEndX-rectStartX);
        copyrectHeight = (rectEndY - rectStartY);
        if ((rectEndX-rectStartX) > 0){
            marginX=-3;
            marginW=+6;
        }else{
            marginX=+3;
            marginW=-6;
        }
        if ((rectEndY-rectStartY) > 0) {
            marginY=-3;
            marginH=+6;
        }else{
            marginY=+3;
            marginH=-6;
       }
   }
}

void mouseReleased(){
       
    //end rectangle for rect selection
    if (rectSelection){
                       
        xmin = xmin + copyrectX*dx;
        ymin = ymin + copyrectY*dy;
        w = copyrectWidth*dx;
        h = copyrectHeight*dy;
      
        rectSelected = true; 
        initRect();
      
    }
    
}

void initRect(){
   copyrectX = 0;
   copyrectY = 0;
   copyrectWidth = width;
   copyrectHeight = height;
   marginX=-3;
   marginW=+6;
   marginY=-3;
   marginH=+6; 
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
    //float dy = (ymax - ymin) / (height); 
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

