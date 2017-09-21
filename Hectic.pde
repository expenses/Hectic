Bullets bullets;
Resources resources;
Player player;
Keys keys;
Enemies enemies;

final boolean DEBUG = true;
final float SCALE = 2;
boolean paused = false;

void setup() {
    // Set the size and renderer to P2D (uses OpenGL)
    size(480, 640, P2D);
    // Set the texture sampling to mode 2 (Nearest Neighbour)
    ((PGraphicsOpenGL) g).textureSampling(2);

    // Load the resources
    resources = new Resources();
    
    // Set up the classes
    player = new Player();
    keys = new Keys();
    enemies = new Enemies();
    bullets = new Bullets();
    
    // Add some example enemies
    enemies.add(new Bat(resources, 2.0 * width / 8.0, 0));
    enemies.add(new Bat(resources, 4.0 * width / 8.0, 0));
    enemies.add(new Bat(resources, 6.0 * width / 8.0, 0));
    enemies.add(new Bat(resources, 3.0 * width / 8.0, -50));
    enemies.add(new Bat(resources, 5.0 * width / 8.0, -50));
}

void drawImage(PImage image, float x, float y, float rotation) {
    // Translate, scale and rotate the matrix
    translate(x, y);
    scale(SCALE);
    if (rotation != 0) rotate(rotation);
    // Draw the image at its center
    image(image, -image.width / 2.0, -image.height / 2.0);
    // Reset the matrix
    resetMatrix();
}

void draw() {
    background(0);
    // Draw the background
    scale(SCALE);
    image(resources.background, 0, 0);
    resetMatrix();

    // Step the game items (if it's not paused)
    if (!paused) {
        player.step(keys, bullets, resources);
        bullets.step();
        enemies.step();
    }

    // Draw the main items
    player.draw();
    bullets.draw();
    enemies.draw();
    
    // Draw UI elements
    scale(SCALE);
    image(resources.portrait, 5, height / 2.0 - 26.0);
    text(player.lives, 25, height / 2.0 - 13.0);

    if (DEBUG) {
        text("FPS: " + frameRate, 5, 10);
        text("Bullets: " + bullets.array.size(), 5, 20);
    }
}