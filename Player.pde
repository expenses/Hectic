// The player!
class Player extends Hitboxed {
    final float SPEED = 250;
    final float COOLDOWN = 0.075;
    final int orbMax = 35;

    float cooldown = 0;
    float invulnerableTime = 0;
    int lives = 3;
    int orbs = 0;

    Player() {
        x = WIDTH  * 0.5;
        y = HEIGHT * 0.75;
        hitboxWidth = 10;
        hitboxHeight = 10;
    }

    void damage() {
        if (invulnerableTime < 0) {
            // Return to the main menu if the player is dead
            if (lives == 0) {
                mainMenu.active = true;
                return;
            }

            lives--;
            invulnerableTime = 5;
        }
    }

    // Collect an orb if it's not already at the max
    void collectOrb(int value) {
        orbs = min(orbMax, orbs + value);
    }

    void draw() {
        // If the unit is invulnerable use that image (flash if the invulnerable time is low)
        if (invulnerableTime > 0 && (invulnerableTime > 1 || invulnerableTime % 0.2 > 0.1)) {
            image = resources.playerInvulnerable;
        } else {
            image = resources.player;
        }

        super.draw();
    }

    boolean step() {
        float speed = (keys.slow ? SPEED / 2.0 : SPEED) / frameRate;

        if (keys.up && top() > 0) y -= speed;
        if (keys.down && bottom() < HEIGHT) y += speed;
        if (keys.left && left() > 0) x -= speed;
        if (keys.right && right() < WIDTH) x += speed;

        cooldown -= deltaTime;
        invulnerableTime -= deltaTime;

        if (keys.fire && cooldown < 0) {
            // Spawn 5 bullets
            bullets.add(new PlayerBullet(-0.2));
            bullets.add(new PlayerBullet(-0.1));
            bullets.add(new PlayerBullet(0));
            bullets.add(new PlayerBullet(0.1));
            bullets.add(new PlayerBullet(0.2));
            cooldown = COOLDOWN;
        }

        // Use a bomb if the orbs at at the max, doing a lot of damage to each enemy
        if (keys.bomb && orbs == orbMax) {
            orbs = 0;
            for (Enemy enemy: enemies.array) enemy.damage(1000);
        }

        return true;
    }
}
