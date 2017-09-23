class Player {
    final float SPEED = 200;
    final float BULLET_SPEED = 900;
    final float COOLDOWN = 0.075;

    float x = width  * 0.5;
    float y = height * 0.75;
    float cooldown = 0;

    int lives = 3;

    void draw() {
        drawImage(resources.player, x, y);
    }
           
    void step() {
        float speed = (keys.slow ? SPEED / 2.0 : SPEED) / frameRate;

        if (keys.up) y -= speed;
        if (keys.down) y += speed;
        if (keys.left) x -= speed;
        if (keys.right) x += speed;

        cooldown -= 1.0 / frameRate;

        if (keys.fire && cooldown < 0) {
            playerBullets.add(new Bullet(x, y, 0, -BULLET_SPEED, resources.playerBullet));
            cooldown = COOLDOWN;
        }
    }
}