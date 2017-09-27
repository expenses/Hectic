final float SCALE = 2;

// Draw an image at the right scale
void drawScale(PImage image, float x, float y) {
    image(image, x, y, image.width * SCALE, image.height * SCALE);
}

// Draw an image on its center
void drawImage(PImage image, float x, float y) {
    drawScale(image, x - image.width, y - image.height);
}

void drawUI() {
    scale(SCALE);
    // Draw the player's lives
    image(resources.portrait, 5, height / 2.0 - 26.0);
    text(player.lives, 25, height / 2.0 - 13.0);
    // Draw the player's orbs
    image(resources.orb, 40, height / 2.0 - 20.0);
    text(player.pickups, 50, height / 2.0 - 13.0);

    if (boss != null) {
        image(resources.bossHealthBar, 5, 5, map(boss.health, 0, boss.maxHealth, 0, width/2.0 - 10), 5);
    }

    // Draw debug info
    if (DEBUG) {
        text(String.format("FPS: %.1f", frameRate), 5, 10);
        text("Enemies: " + enemies.array.size(), 5, 20);
    }
}