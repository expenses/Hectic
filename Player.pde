class Player {
    final float SPEED = 200;
    final float COOLDOWN = 0.075;
    final float HITBOX_WIDTH = 10;
    final float HITBOX_HEIGHT = 10;

    float x = width  * 0.5;
    float y = height * 0.75;
    float cooldown = 0;
    int lives = 3;
    float invulnerableTime = 0;

    void damage() {
        if (invulnerableTime < 0) {
            invulnerableTime = 5;
            lives--;
        }
    }

    void draw() {
        if (invulnerableTime > 0 && (invulnerableTime > 1 || invulnerableTime % 0.2 > 0.1)) {
            drawImage(resources.playerInvulnerable, x, y);
        } else {
            drawImage(resources.player, x, y);
        }
        
        if (DEBUG) rect(x, y, HITBOX_WIDTH, HITBOX_HEIGHT);
    }
           
    void step() {
        float speed = (keys.slow ? SPEED / 2.0 : SPEED) / frameRate;

        if (keys.up) y -= speed;
        if (keys.down) y += speed;
        if (keys.left) x -= speed;
        if (keys.right) x += speed;

        float dt = 1.0 / frameRate;

        cooldown -= dt;
        invulnerableTime -= dt;

        if (keys.fire && cooldown < 0) {
            playerBullets.add(new PlayerBullet());
            cooldown = COOLDOWN;
        }
    }

    float left() {
        return x - HITBOX_WIDTH / 2.0;
    }

    float right() {
        return x + HITBOX_WIDTH / 2.0;
    }

    float top() {
        return y - HITBOX_HEIGHT / 2.0;
    }

    float bottom() {
        return y + HITBOX_HEIGHT / 2.0;
    }

    boolean touching(float x, float y) {
        return x >= left() && x <= right() && y >= top()  && y <= bottom();
    }

    boolean touchingEnemy(Enemy enemy) {
        return !(
            enemy.left() > right() || enemy.right() < left() ||
            enemy.top() > bottom() || enemy.bottom() < top()
        );
    }
}