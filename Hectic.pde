Bullets playerBullets;
Bullets enemyBullets;
Resources resources;
Player player;
Keys keys;
Enemies enemies;
Effects effects;
Pickups pickups;
Stage stage;

// Layout:
// Resources: handles resource (image and font) loading
// Keys: keeps track of pressed keys, handles key presses and releases
// Drawing: contains drawing functions
// Player: player character movement and firing
// Enemies: enemy classes
// Bullets: bullet classes

// Processing doesn't support the `->` keyword so you have to use predicate classes for stuff :^\
import java.util.function.Predicate;

final boolean DEBUG = false;
boolean paused = false;
float deltaTime = 0;

void setup() {
    // Set the size and renderer to P2D (uses OpenGL)
    size(480, 640, P2D);
    // Set the texture sampling to mode 2 (Nearest Neighbour)
    ((PGraphicsOpenGL) g).textureSampling(2);
    // Set the framerate
    frameRate(60);

    // Settings for drawing hitboxes
    noFill();
    stroke(255, 0, 0);
    rectMode(CENTER);

    // Load the resources
    resources = new Resources();

    // Set up the classes
    player = new Player();
    keys = new Keys();
    enemies = new Enemies();
    playerBullets = new Bullets();
    enemyBullets = new Bullets();
    effects = new Effects();
    pickups = new Pickups();
    stage = stageOne();
}

void update() {
    deltaTime = 1.0 / frameRate;
    stage.step();
    player.step();
    pickups.step();
    playerBullets.stepCollideEnemies();
    enemyBullets.stepCollidePlayer();
    enemies.step();
    effects.step();
}

void draw() {
    background(0);

    if (!paused) update();

    // Draw the main items
    stage.draw();
    playerBullets.draw();
    player.draw();
    pickups.draw();
    enemyBullets.draw();
    enemies.draw();
    effects.draw();
    
    drawUI();
}