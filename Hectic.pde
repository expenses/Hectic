Resources resources;
Player player  = new Player();
Keys keys = new Keys();
EntityList<Enemy> enemies = new EntityList<Enemy>();
EntityList bullets = new EntityList();
EntityList effects = new EntityList();
EntityList pickups = new EntityList();
Stage stage;

Boss boss = null;

// Layout:
// Resources: handles resource (image and font) loading
// Keys: keeps track of pressed keys, handles key presses and releases
// Drawing: contains drawing functions
// Player: player character movement and firing
// Enemies: enemy classes
// Bullets: bullet classes

// Processing doesn't support the `->` keyword so you have to use predicate classes for stuff :^\
import java.util.function.Predicate;

final int WIDTH = 480;
final int HEIGHT = 640;
final float SCALE = 2;
final float HALF_SCALE = SCALE / 2.0;

final boolean DEBUG = false;
boolean paused = false;
float deltaTime = 0;

void settings() {
    // Set the size and renderer to P2D (uses OpenGL)
    size(WIDTH, HEIGHT, P2D); 
}

void setup() {
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
    // Set up the stage
    stage  = stageOne();
}

void update() {
    deltaTime = 1.0 / frameRate;
    stage.step();
    player.step();
    pickups.step();
    bullets.step();
    enemies.step();
    effects.step();
}

void draw() {
    background(0);

    if (!paused) update();

    // Draw the main items
    stage.draw();
    player.draw();
    pickups.draw();
    bullets.draw();
    enemies.draw();
    effects.draw();
    
    drawUI();
}
