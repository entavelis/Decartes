import ddf.minim.*;
import ddf.minim.analysis.*;

Minim minim;
AudioInput song;
FFT fft;
int R = 0;
int G = 63;
int B = 127;
PImage cat1;
PImage cat2;
int cellsize = 2; // Dimensions of each cell in the grid
int cols, rows;   // Number of columns and rows in our system
int sinf = 0;
int cosf = 0;
int step;
void setup()


{
  size(1024,1024, P3D);

  minim = new Minim(this);
  
  // use the getLineIn method of the Minim object to get an AudioInput
  song = minim.getLineIn();


fft = new FFT(song.bufferSize(), song.sampleRate()); 
cat1 = loadImage("/home/ctrlaltv/Downloads/eyes.jpg");
cat1.resize(1024,1024);
//cat2 = loadImage("/home/ctrlaltv/Downloads/cat2.gif");
cols = width/cellsize;             // Calculate # of columns
rows = height/cellsize;            // Calculate # of rows
}  

void draw() { 
background(0); 
// first perform a forward fft on one of song's buffers
// I'm using the mix buffer 
// but you can use any one you like 
fft.forward(song.mix);  

// draw the spectrum as a series of vertical lines 
// I multiple the value of getBand by 4 
// so that we can see the lines better //
//drawimage(cat2);
sinf = (sinf + 8) % 360;
cosf = (cosf + 8) % 360;
step = 15;
newcircle(305+int(step*sin(radians(sinf))),417,0,1,128);
newcircle(480+int(step*sin(radians(sinf))),407,0,1,128);
newcircle(678,605,0,1,32);
newcircle(812,610,0,1,32);
tint(255,1255-fft.getBand(0)*4);
//fill(hue((int(fft.getBand(0))*4)));
//blue(int(fft.getBand(32))*8);
//tint(fft.getBand(0)*4,fft.getBand(16)*8,fft.getBand(128)*16);
image(cat1,0,0);
//newcircle(756,256,1,2);
// I draw the waveform by connecting
// neighbor values with a line. I multiply
// each of the values by 50 
// because the values in the buffers are normalized 
// this means that they have values between -1 and 1.
// If we don't scale them up our waveform 
// will look more or less like a straight line. 
//for(int i = 0; i < song.left.size() - 1; i++) { line(i, 50 + song.left.get(i)*250, i+1, 50 + song.left.get(i+1)*250); line(i, 150 + song.right.get(i)*250, i+1, 150 + song.right.get(i+1)*150); }
//linear();

}

void linear()
{
  R = (R+1)%128;
  G = (G+2)%128;
  B = (B+4)%128;
  stroke(R,G,B, 128);
 
 for(int j = 0; j < fft.specSize(); j++)
  {
  
    line(j, height, j, height - fft.getBand(j/2)*4);
    //line(width - j, 0,width - j, fft.getBand(j/16)*4);
  }
  

}


void newcircle(int w,int h,int start,int step, int ratio) {
  stroke(255);
  ellipse(w,h,fft.getBand(1)*4,fft.getBand(1)*4);;
 R = (R+1)%128;
  G = (G+2)%128;
  B = (B+4)%128;
  stroke(R,G,B, 128);
  ellipse(w,h,fft.getBand(1)*4,fft.getBand(1)*4);;
 
  for(int i = start; i < fft.specSize(); i+=step) {
  stroke(R,G,B, 128); 
  float nh = (h + i*ifft.getBand(i/4))/ratio;
  line(w, h, w + nh*sin(radians((i)*180/256)), h + nh*cos(radians((i)*180/256)));
  
   stroke(255, 0, 0, 128);
  // draw the spectrum as a series of vertical lines
  // I multiple the value of getBand by 4 
  // so that we can see the lines better
  } 
}

void drawimage(PImage img) {
 
  loadPixels();
  // Begin loop for columns
  for ( int i = 0; i < cols;i++) {
    // Begin loop for rows
    for ( int j = 0; j < rows;j++) {
      int x = i*cellsize + cellsize/2; // x position
      int y = j*cellsize + cellsize/2; // y position
      int loc = x + y*width;           // Pixel array location
      color c = img.pixels[loc];       // Grab the color
      // Calculate a z position as a function of mouseX and pixel brightness
      float z = (mouseX/(float)width) * brightness(img.pixels[loc]) - 100.0;
      // Translate to the location, set fill and stroke, and draw the rect
      pushMatrix();
      translate(x,y,z);
      fill(c);
      noStroke();
      rectMode(CENTER);
      rect(0,0,cellsize,cellsize);
      popMatrix();
    }
  }
}
