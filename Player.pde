class Player {
    final float SPEED = 4;
    final float BULLET_SPEED = 25;

    float x = width / 2.0;
    float y = 3.0 * height / 4.0;
    int lives = 3;

    void draw() {
        drawImage(resources.player, x, y, 0);
    }
           
    void step(Keys keys, Bullets bullets, Resources resources) {
        float speed = keys.slow ? SPEED / 2.0 : SPEED;

        if (keys.up) y -= speed;
        if (keys.down) y += speed;
        if (keys.left) x -= speed;
        if (keys.right) x += speed;

        if (keys.fire) bullets.add(new Bullet(x, y, 0, -BULLET_SPEED, resources.playerBullet));
    }
}