class Player extends Corners {
    final float SPEED = 250;
    final float COOLDOWN = 0.075;
    final float HITBOX_WIDTH = 10;
    final float HITBOX_HEIGHT = 10;

    float x = width  * 0.5;
    float y = height * 0.75;
    float cooldown = 0;
    float invulnerableTime = 0;

    int lives = 3;
    int pickups = 0;

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

        if (keys.up && top() > 0) y -= speed;
        if (keys.down && bottom() < height) y += speed;
        if (keys.left && left() > 0) x -= speed;
        if (keys.right && right() < width) x += speed;

        cooldown -= deltaTime;
        invulnerableTime -= deltaTime;

        if (keys.fire && cooldown < 0) {
            playerBullets.add(new PlayerBullet(-5, -5));
            playerBullets.add(new PlayerBullet(+5, -5));
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
}