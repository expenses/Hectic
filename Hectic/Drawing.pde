// Drawing helper functions

// Draw an image at the right scale
void drawScale(PImage image, float x, float y) {
    image(image, x, y, image.width * SCALE, image.height * SCALE);
}

// Draw an image on its center
void drawImage(PImage image, float x, float y) {
    drawScale(image, x - image.width, y - image.height);
}

// Draw a title for something
void drawTitle(String string, float x, float y) {
    textAlign(CENTER);
    textFont(resources.oldeEnglish);
    scale(2);
    // Draw each line of text on the center
    for (String line: string.split("\n")) {
        text(line, x / 2, y / 2);
        y += 120;
    }
    resetMatrix();
    textFont(resources.tinyUnicode);
    textAlign(LEFT);
}

void drawUI() {
    final float ORB_BAR_X = 70;
    final float ORB_BAR_Y = HEIGHT - 35;
    final float ORB_BAR_MAX_WIDTH = WIDTH / 4.0;

    // Draw the player's lives
    drawImage(resources.portrait, 30, HEIGHT - 30);
    text(player.lives, 50, HEIGHT - 25);

    // Draw the orb bar
    image(resources.orbBarBackground, ORB_BAR_X, ORB_BAR_Y, ORB_BAR_MAX_WIDTH, 10);
    image(resources.orbBar, ORB_BAR_X, ORB_BAR_Y, map(player.orbs, 0, player.orbMax, 0, ORB_BAR_MAX_WIDTH), 10);

    // Draw the boss healthbar
    if (boss != null) {
        image(resources.bossHealthBar, 10, 10, map(boss.health, 0, boss.maxHealth, 0, WIDTH - 20), 10);
    }

    // Draw debug info
    if (DEBUG) {
        text(String.format("FPS: %.1f", frameRate),        WIDTH - 80, HEIGHT - 5);
        textAlign(RIGHT);
        text(String.format("Bullets: %s", bullets.array.size() + playerBullets.array.size()), WIDTH - 5, HEIGHT - 20);
        text(String.format("Enemies: %s", enemies.array.size()), WIDTH - 5, HEIGHT - 35);
        text(String.format("Pickups: %s", pickups.array.size()), WIDTH - 5, HEIGHT - 50);
        textAlign(LEFT);
    }
}
