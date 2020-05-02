import teilchen.*; 
import teilchen.behavior.*; 
import teilchen.constraint.*; 
import teilchen.cubicle.*; 
import teilchen.force.*; 
import teilchen.integration.*; 
import teilchen.util.*; 

PImage basket;
PImage basketbar;
PImage ball;

Physics mPhysics;
LineDeflector2D mDeflector;
LineDeflector2D nDeflector;

void settings() {
    size(640, 480, P3D);
}
void setup() {
    smooth();
    frameRate(30);
    mPhysics = new Physics();
    
    // load graphics
    basket = loadImage("basket.png");
    ball = loadImage("basket_ball.png");
    basketbar = loadImage("basketbar.png");
    
    // set gravity
    Gravity myGravity = new Gravity();
    myGravity.force().y = 70;
    mPhysics.add(myGravity);
}

void draw() {
    
    final float mDeltaTime = 1.0f / frameRate;
    mPhysics.step(mDeltaTime);
    
    background(255);
    
    //draw basket
    image(basket, 145, 50);
    
    // draw deflectors
    makeBasket(240,200, 100,10);
   
   // draw a particle for basketball
    for (int i = 0; i < mPhysics.particles().size(); i++) {
        Particle mParticle = mPhysics.particles(i);
        float myRatio = 1 - ((ShortLivedParticle) mParticle).ageRatio();
        stroke(0, 127);
        stroke(0, 64 * myRatio);
        if (mParticle.tagged()) {
            fill(255, 127, 0, 127 * myRatio);
        } else {
            fill(0, 32 * myRatio);
        }
        
        // this is the basketball
        image(ball,mParticle.position().x-35, mParticle.position().y-35, mParticle.radius() * 2, mParticle.radius() * 2);

  }
  
    // the basketball net goes in the front
    image(basketbar, 145, 50);
    
    mPhysics.removeTags();
}

// make a basketball on mouse click
void mouseClicked(){
  ShortLivedParticle myNewParticle = new ShortLivedParticle();
    myNewParticle.position().set(mouseX, mouseY);
    myNewParticle.velocity().set(70, random(100) - 250);
    // this particle is removed after a specific interval 
    myNewParticle.setMaxAge(8);
    myNewParticle.radius(35);  
    mPhysics.add(myNewParticle);
}

void makeBasket(int p, int q, int gap, int w){
  mDeflector = new LineDeflector2D();
  mDeflector.a().set(p,q);
  mDeflector.b().set(p+w,q+3);
  mPhysics.add(mDeflector);
  //mDeflector.draw(g);
  
  nDeflector = new LineDeflector2D();
  nDeflector.a().set(p+gap,q+3);
  nDeflector.b().set(p+gap+w,q);
  mPhysics.add(nDeflector);
  //nDeflector.draw(g);
}
