final float SCALE = 2;
final float CLOUD_DELTA = 30;
float cloudY = 0;

void drawScale(PImage image, float x, float y) {
    image(image, x, y, image.width * SCALE, image.height * SCALE);
}

void drawImage(PImage image, float x, float y) {
    drawScale(image, x - image.width, y - image.height);
}

void drawBackground() {
    float cloudHeight = resources.clouds.height * SCALE - height;
    drawScale(resources.background, 0, 0);
    drawScale(resources.clouds, 0, cloudY - cloudHeight);
    resetMatrix();

    if (!paused) cloudY = (cloudY + CLOUD_DELTA / frameRate) % cloudHeight;
}

void drawUI() {
    // Draw UI elements
    scale(SCALE);
    image(resources.portrait, 5, height / 2.0 - 26.0);
    text(player.lives, 25, height / 2.0 - 13.0);

    if (DEBUG) {
        text(String.format("FPS: %.1f", frameRate), 5, 10);
        text("Enemies: " + enemies.array.size(), 5, 20);
    }
}