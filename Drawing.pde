final float SCALE = 2;
final float HALF_SCALE = SCALE / 2.0;

// Draw an image at the right scale
void drawScale(PImage image, float x, float y) {
    image(image, x, y, image.width * SCALE, image.height * SCALE);
}

// Draw an image on its center
void drawImage(PImage image, float x, float y) {
    drawScale(image, x - image.width, y - image.height);
}

void drawUI() {
    // Draw the player's lives and orbs
    drawScale(resources.portrait, 10, height - resources.portrait.height * HALF_SCALE - 30);
    text(player.lives, 50, height - 25);
    //drawScale(resources.orb, 70, height - resources.orb.height * HALF_SCALE - 30);
    //text(player.orbs, 100, height - 25);

    float orbBarX = 70;
    float orbBarY = height - 35;
    float maxWidth = width / 4.0;

    image(resources.orbBarBackground, orbBarX, orbBarY, maxWidth, 10);
    image(resources.orbBar, orbBarX, orbBarY, map(player.orbs, 0, player.orbMax, 0, maxWidth), 10);

    // Draw the boss healthbar
    if (boss != null) {
        image(resources.bossHealthBar, 10, 10, map(boss.health, 0, boss.maxHealth, 0, width - 20), 10);
    }

    // Draw debug info
    if (DEBUG) {
        text(String.format("FPS: %.1f", frameRate), width - 80, height - 5);
    }
}
