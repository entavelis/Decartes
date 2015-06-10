//source = https://processing.org/discourse/beta/num_1230597092.html
import ddf.minim.*;
import ddf.minim.analysis.*;
import ddf.minim.analysis.*;

Minim minim;
BeatDetect beat;
BeatListener bl;
AudioInput song;
PImage cat1;
float kickSize, snareSize, hatSize;

void setup()
{
 size(1024,1024);
 smooth();
 
 minim = new Minim(this);
 
 song = minim.getLineIn();
 
 // a beat detection object that is FREQ_ENERGY mode that
 // expects buffers the length of song's buffer size
 // and samples captured at songs's sample rate
 beat = new BeatDetect(song.bufferSize(), song.sampleRate());
 // set the sensitivity to 300 milliseconds
 // After a beat has been detected, the algorithm will wait for 300 milliseconds
 // before allowing another beat to be reported. You can use this to dampen the
 // algorithm if it is giving too many false-positives. The default value is 10,
 // which is essentially no damping. If you try to set the sensitivity to a negative value,
 // an error will be reported and it will be set to 10 instead.
 beat.setSensitivity(100);  
 kickSize = snareSize = hatSize = 16;
 // make a new beat listener, so that we won't miss any buffers for the analysis
 bl = new BeatListener(beat, song);  
 textFont(createFont("SanSerif", 16));
 textAlign(CENTER);
 
 cat1 = loadImage("/home/ctrlaltv/Downloads/cat11.jpg");

}

void draw()
{
 background(0);
 fill(255);
 if ( beat.isKick() ) kickSize = 1; else kickSize = 0;
 if ( beat.isSnare() ) snareSize = 1; else snareSize = 0;
 if ( beat.isHat() ) hatSize = 1; else hatSize = 0;
 textSize(kickSize);
 text("KICK", width/4, height/2);
 textSize(snareSize);
 text("SNARE", width/2, height/2);
 textSize(hatSize);
 text("HAT", 3*width/4, height/2);
 kickSize = constrain(kickSize * 0.95, 16, 32);
 snareSize = constrain(snareSize * 0.95, 16, 32);
 hatSize = constrain(hatSize * 0.95, 16, 32);
 
 int mysize = int(256*kickSize + 128*snareSize + 64*hatSize);
 cat1.resize(mysize,mysize);
 image(cat1,0,0);
}

void stop()
{
 // always close Minim audio classes when you are finished with them
 song.close();
 // always stop Minim before exiting
 minim.stop();
 // this closes the sketch
 super.stop();
}



class BeatListener implements AudioListener
{
 private BeatDetect beat;
 private AudioInput source;
 
 BeatListener(BeatDetect beat, AudioInput source)
 {
   this.source = source;
   this.source.addListener(this);
   this.beat = beat;
 }
 void samples(float[] samps)
 {
   beat.detect(source.mix);
 }
 void samples(float[] samps,float[] samps2)
 {
   beat.detect(source.mix);
 }
 }
