

ControlP5 cp5;

public void createGUI(){
  cp5 = new ControlP5(this);
  
  int sx, sy, px, py, oy;
  
  sx = 100; sy = 14; oy = (int)(sy*1.5f);
  
  ////////////////////////////////////////////////////////////////////////////
  // GUI - PARTICLES
  ////////////////////////////////////////////////////////////////////////////
  Group group_particles = cp5.addGroup("Particles");
  {
    
    group_particles.setHeight(20).setSize(gui_w, 200)
    .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_particles.getCaptionLabel().align(CENTER, CENTER);
    
    sx = 100; px = 10; py = 10;oy = (int)(sy*1.4f);
    
    cp5.addButton("reset particles").setGroup(group_particles).setWidth(160).setPosition(10, 10).plugTo(particlesystem, "initParticles");

    cp5.addSlider("Particle count").setGroup(group_particles).setSize(sx, sy).setPosition(px, py+=oy+10)
        .setRange(10, 10000).setValue(particlesystem.PARTICLE_COUNT).plugTo(particlesystem, "setParticleCount");
    
    cp5.addSlider("Fill Factor").setGroup(group_particles).setSize(sx, sy).setPosition(px, py+=oy)
    .setRange(0.2f, 1.5f).setValue(particlesystem.PARTICLE_SCREEN_FILL_FACTOR).plugTo(particlesystem, "setFillFactor");
    
    cp5.addSlider("VELOCITY").setGroup(group_particles).setSize(sx, sy).setPosition(px, py+=oy+10)
        .setRange(0.85f, 1.0f).setValue(particlesystem.particle_param.DAMP_VELOCITY).plugTo(particlesystem.particle_param, "DAMP_VELOCITY");
    
    cp5.addSlider("GRAVITY").setGroup(group_particles).setSize(sx, sy).setPosition(px, py+=oy)
        .setRange(0, 10f).setValue(particlesystem.MULT_GRAVITY).plugTo(particlesystem, "MULT_GRAVITY");

    
    cp5.addSlider("SPRINGINESS").setGroup(group_particles).setSize(sx, sy).setPosition(px, py+=oy)
        .setRange(0, 1f).setValue(particlesystem.particle_param.DAMP_COLLISION).plugTo(particlesystem.particle_param, "DAMP_COLLISION");
    
    cp5.addCheckBox("activateCollisionDetection").setGroup(group_particles).setSize(40, 18).setPosition(px, py+=(int)(oy*1.5f))
        .setItemsPerRow(1).setSpacingColumn(3).setSpacingRow(3)
        .addItem("collision detection", 0)
        .activate(COLLISION_DETECTION ? 0 : 2);
        }
  
  
  ////////////////////////////////////////////////////////////////////////////
  // GUI - DISPLAY
  ////////////////////////////////////////////////////////////////////////////
  Group group_display = cp5.addGroup("display");
  {
    group_display.setHeight(20).setSize(gui_w, 25)
    .setBackgroundColor(color(16, 180)).setColorBackground(color(16, 180));
    group_display.getCaptionLabel().align(CENTER, CENTER);
    
    px = 10; py = 15;
    
    cp5.addSlider("BACKGROUND").setGroup(group_display).setSize(sx,sy).setPosition(px, py)
        .setRange(0, 255).setValue(BACKGROUND_COLOR).plugTo(this, "BACKGROUND_COLOR");
  }
  
  
  ////////////////////////////////////////////////////////////////////////////
  // GUI - ACCORDION
  ////////////////////////////////////////////////////////////////////////////
  cp5.addAccordion("acc").setPosition(gui_x, gui_y).setWidth(gui_w).setSize(gui_w, height)
    .setCollapseMode(Accordion.MULTI)
    .addItem(group_particles)
    .addItem(group_display)
    .open(0);
}
