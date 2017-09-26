final float SCALE = 2;

void drawScale(PImage image, float x, float y) {
    image(image, x, y, image.width * SCALE, image.height * SCALE);
}

void drawImage(PImage image, float x, float y) {
    drawScale(image, x - image.width, y - image.height);
}

void drawUI() {
    // Draw UI elements
    scale(SCALE);
    image(resources.portrait, 5, height / 2.0 - 26.0);
    text(player.lives, 25, height / 2.0 - 13.0);

    image(resources.orb, 40, height / 2.0 - 20.0);
    text(player.pickups, 50, height / 2.0 - 13.0);

    if (DEBUG) {
        text(String.format("FPS: %.1f", frameRate), 5, 10);
        text("Enemies: " + enemies.array.size(), 5, 20);
    }
}