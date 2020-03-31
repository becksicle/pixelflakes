PImage img;
ArrayList<Particle> particles;
ArrayList<Particle> newParticles;
IntList pixelsToRemove;
int xOffset = 400;
int yOffset = 450;
int maxParticles = 50000;
int radius;

void setup() {
    particles = new ArrayList<Particle>();
    newParticles = new ArrayList<Particle>();
    reset();    
    size(3000, 2000);
}
    
void reset() {   
    img = loadImage("[Path to Image]");
    img.loadPixels();      
    println("img height: "+img.height+" img width: "+img.width+" tot pixels: "+img.width * img.height);
    
    xOffset = max(0, (3000 - img.width)/2);
    yOffset = max(0, (2000 - img.height)/2);
    radius = 4;
    println("xoffset: "+xOffset+" yoffset: "+yOffset +" radius: "+radius);
        
    pixelsToRemove = new IntList();
    for(int y=0; y < img.height; y += radius) {
      for(int x=0; x < img.width; x += radius) {
        pixelsToRemove.append(y*img.width + x);        
      }
    }    
    println("num pixels to remove: "+pixelsToRemove.size());      
    pixelsToRemove.shuffle();  
}

void draw() {
    background(0);    
    image(img, xOffset, yOffset);
    
    if(particles.size() == 0 && pixelsToRemove.size() == 0) {
      reset();
    }
    
    while(pixelsToRemove.size() > 0 && (particles.size() < maxParticles)) {
      int i = pixelsToRemove.get(0);
      pixelsToRemove.remove(0);
      
      int y = (i / img.width);
      int x = (i - y * img.width) + xOffset;
      y += yOffset;
      
      color origColor = img.pixels[i];
      
      for(int yOff = 0; yOff < radius; yOff++) {
        for(int xOff = 0; xOff < radius; xOff++) { 
          i = (y + yOff - yOffset) * img.width + x + xOff - xOffset;
          if(i < img.pixels.length) {            
            img.pixels[i] = color(0, 0, 0);
          }
        }
      }
      Particle p = new Particle(new PVector(x, y), origColor, radius, new PVector(-2.8, 0.0));
      particles.add(p);             
    }
         //<>//
    img.updatePixels();
    loadPixels();    
  
    newParticles.clear();
    for(Particle p : particles) {
      p.update();
      p.draw();
      if(!p.isOffscreen()) {
        newParticles.add(p);
      }            
    }  
    
    ArrayList<Particle> tmp = particles;
    particles = newParticles;        
    newParticles = tmp;
    updatePixels();    
}

class Particle {
  PVector loc;
  int radius;
  float theta = 0;
  float thetaScale;
  float dy;
  float driftX;
  PVector wind;
  color c;
  
  Particle(PVector loc, color c, int radius, PVector wind) {
    this.loc = loc;
    this.c = c;
    this.radius = radius;    
    this.wind = wind;
    thetaScale = random(1, 4);
    dy = random(1, 4);
    driftX = random(-1.0, 1.0);
  }
  
  void update() {
    loc.x += driftX + cos(thetaScale*theta) + wind.x;
    theta += 0.1;
    loc.y -= dy + wind.y;
  }
  
  boolean isOffscreen() {
    return (loc.x < 0) || (loc.x >= width) || (loc.y < 0) || (loc.y >= height);
  }
  
  void draw() {
    if(!isOffscreen()) {
      for(int yOff = 0; yOff < radius; yOff++) {
        for(int xOff = 0; xOff < radius; xOff++) { 
          int i = ((int)loc.y+yOff)*width + (int)loc.x + xOff;
          if(i < pixels.length) {
            pixels[i] = c;
          }
        }
      }
    }
  }
  
  void printCoords() {
    print("("+loc.x+","+loc.y);
  }

}
    
