/**
 * 
 * PixelFlow | Copyright (C) 2016 Thomas Diewald - http://thomasdiewald.com
 * 
 * A Processing/Java library for high performance GPU-Computing (GLSL).
 * MIT License: https://opensource.org/licenses/MIT
 * 
 */



import com.thomasdiewald.pixelflow.java.DwPixelFlow;
import com.thomasdiewald.pixelflow.java.softbodydynamics.DwPhysics;
import com.thomasdiewald.pixelflow.java.softbodydynamics.particle.DwParticle2D;
import de.voidplus.leapmotion.*;
import controlP5.Accordion;
import controlP5.ControlP5;
import controlP5.Group;
import processing.core.*;



  //
  // 2D Verlet Particle System.
  // 
  // + Collision Detection
  //
  //
  
int viewport_w = 1280;
int viewport_h = 720;


int gui_w = 200;
int gui_x = 20;
int gui_y = 20;

// particle system, cpu
ParticleSystem particlesystem;

// ref for LeapMotion
LeapMotion leap;

// physics parameters
DwPhysics.Param param_physics = new DwPhysics.Param();

// verlet physics, handles the update-step
DwPhysics<DwParticle2D> physics;

// some state variables for the GUI/display
int     BACKGROUND_COLOR    = #1B294A;
boolean COLLISION_DETECTION = true;
float INTERACTION_SPACE_WIDTH = 200; // left-right from user
float INTERACTION_SPACE_DEPTH = 150; // away-and-toward user
float FINGER_DOT = 30;


public void settings() {
  size(viewport_w, viewport_h, P2D);
  smooth(4);
}
  
  public void setup() {
    leap = new LeapMotion(this);
    
    // main library context
    DwPixelFlow context = new DwPixelFlow(this);
    context.print();
//    context.printGL();
    
    // particle system object
    particlesystem = new ParticleSystem(this, width, height);
    
    // set some parameters
    particlesystem.PARTICLE_COUNT              = 7000;
    particlesystem.PARTICLE_SCREEN_FILL_FACTOR = 0.60f;

    particlesystem.MULT_GRAVITY                = 0.00f;

    particlesystem.particle_param.DAMP_BOUNDS    = 0.99999f;
    particlesystem.particle_param.DAMP_COLLISION = 0.99999f;
    particlesystem.particle_param.DAMP_VELOCITY  = 0.93333f;
    
    particlesystem.initParticles();
    
    physics = new DwPhysics<DwParticle2D>(param_physics);
    param_physics.GRAVITY = new float[]{0, 0.1f};
    param_physics.bounds  = new float[]{0, 0, width, height};
    param_physics.iterations_collisions = 8;
    param_physics.iterations_springs    = 0; // no springs in this demo
   
    createGUI();

    background(0);
    frameRate(600);
  }
  
 
public void draw() {    

      //  //loop for listening for hands
 
  
  ////  add force: Middle Mouse Button (MMB) -> particle[0]
    //if(mousePressed){
    //  float[] mouse = {mouseX, mouseY};
    //  particlesystem.particles[0].moveTo(mouse, 0.3f);
    //  particlesystem.particles[0].enableCollisions(false);
    //} else {
    //  particlesystem.particles[0].enableCollisions(true);
    //}
    
    // update physics step
    boolean collision_detection = COLLISION_DETECTION && particlesystem.particle_param.DAMP_COLLISION != 0.0;
    
    physics.param.GRAVITY[1] = 0.05f * particlesystem.MULT_GRAVITY;
    physics.param.iterations_collisions = collision_detection ? 4 : 0;

    physics.setParticles(particlesystem.particles, particlesystem.particles.length);
    physics.update(1);

    // RENDER
    background(BACKGROUND_COLOR);

    // draw particlesystem
    PGraphics pg = this.g;
    pg.hint(DISABLE_DEPTH_MASK);
    pg.blendMode(BLEND);
//    pg.blendMode(ADD);
    particlesystem.display(pg);
    pg.blendMode(BLEND);
    
  for (Hand hand : leap.getHands ()) {
    boolean handIsLeft         = hand.isLeft();
    boolean handIsRight        = hand.isRight();
    //PVector thumbTip = hand.getThumb().getRawPositionOfJointTip();
    //PVector indexTip = hand.getIndexFinger().getRawPositionOfJointTip();
    //PVector ringTip = hand.getRingFinger().getRawPositionOfJointTip();
    //PVector middleTip = hand.getMiddleFinger().getRawPositionOfJointTip();
    //PVector pinkyTip = hand.getPinkyFinger().getRawPositionOfJointTip();

    //handleFinger(thumbTip, "thb");
    //handleFinger(indexTip, "idx");
    //handleFinger(middleTip, "mdl");
    //handleFinger(ringTip, "rng");
    //handleFinger(pinkyTip, "pky");
    
    if (handIsLeft){
      PVector thumbTip = hand.getThumb().getRawPositionOfJointTip();
      handleFinger(thumbTip, "left_thumb");
      PVector indexTip = hand.getIndexFinger().getRawPositionOfJointTip();
      handleFinger(indexTip, "left_index");
      PVector middleTip = hand.getMiddleFinger().getRawPositionOfJointTip();
      handleFinger(middleTip, "left_middle");
      PVector ringTip = hand.getRingFinger().getRawPositionOfJointTip();
      handleFinger(ringTip, "left_ring");
      PVector pinkyTip = hand.getPinkyFinger().getRawPositionOfJointTip();
      handleFinger(pinkyTip, "left_pinky");

    }
    if (handIsRight){
      PVector thumbTip = hand.getThumb().getRawPositionOfJointTip();
      handleFinger(thumbTip, "right_thumb");
      PVector indexTip = hand.getIndexFinger().getRawPositionOfJointTip();
      handleFinger(indexTip, "right_index");
      PVector middleTip = hand.getMiddleFinger().getRawPositionOfJointTip();
      handleFinger(middleTip, "right_middle");
      PVector ringTip = hand.getRingFinger().getRawPositionOfJointTip();
      handleFinger(ringTip, "right_ring");
      PVector pinkyTip = hand.getPinkyFinger().getRawPositionOfJointTip();
      handleFinger(pinkyTip, "right_pinky");
    }

  }
    // info
    String txt_fps = String.format(getClass().getName()+ "   [size %d/%d]   [frame %d]   [fps %6.2f]", width, height, frameCount, frameRate);
    surface.setTitle(txt_fps);
}
  


  public void activateCollisionDetection(float[] val){
    COLLISION_DETECTION = (val[0] > 0);
  }
  
void handleFinger(PVector pos, String hand) { // function to use leapMotion finger tips 
  // map finger tip position to 2D surface (no height)
  if (hand == "left_thumb"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#1000FF);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[0].moveTo(mouse, 0.3f);
    particlesystem.particles[0].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("left_thumb", x, y);
  }
  if (hand == "left_index"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[1].moveTo(mouse, 0.3f);
    particlesystem.particles[1].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("left_index", x, y);
  }
  
  if (hand == "left_middle"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[2].moveTo(mouse, 0.3f);
    particlesystem.particles[2].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("left_middle", x, y);
  }
  
  if (hand == "left_ring"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[3].moveTo(mouse, 0.3f);
    particlesystem.particles[3].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("left_ring", x, y);
  }
  
  if (hand == "left_pinky"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[4].moveTo(mouse, 0.3f);
    particlesystem.particles[4].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("left_pinky", x, y);
  }
  
  if (hand == "right_thumb"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#FFD900);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[5].moveTo(mouse, 0.3f);
    particlesystem.particles[5].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("right_thumb", x, y);
  }
 if (hand == "right_index"){
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#E81717);
    noStroke();
    ellipse(x, y, FINGER_DOT, FINGER_DOT);
    float[] mouse = {x, y};
    particlesystem.particles[6].moveTo(mouse, 0.3f);
    particlesystem.particles[6].enableCollisions(false);
  //physics.update(1);particlesystem.particles[0].enableCollisions(true);

    fill(0);
    text("right_index", x, y);
  }
 
 if (hand == "right_middle") {
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    float[] mouse = {x, y};
    particlesystem.particles[7].moveTo(mouse, 0.3f);
    particlesystem.particles[7].enableCollisions(false);
    
    fill(0);
    text("right_index", x, y);
 }
 
 if (hand == "right_ring") {
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    float[] mouse = {x, y};
    particlesystem.particles[8].moveTo(mouse, 0.3f);
    particlesystem.particles[8].enableCollisions(false);
    
    fill(0);
    text("right_ring", x, y);
 }
 
 if (hand == "right_pinky") {
    float x = map(pos.x, -INTERACTION_SPACE_WIDTH, INTERACTION_SPACE_WIDTH, 0, width);
    float y = map(pos.z, -INTERACTION_SPACE_DEPTH, INTERACTION_SPACE_DEPTH, 0, height);
    fill(#00E310);
    noStroke();
    float[] mouse = {x, y};
    particlesystem.particles[9].moveTo(mouse, 0.3f);
    particlesystem.particles[9].enableCollisions(false);
    
    fill(0);
    text("right_pinky", x, y);
 }
}
