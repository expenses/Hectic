// The player!
class Player extends Hitboxed {
    final float SPEED = 250;
    final float COOLDOWN = 0.075;
    final int orbMax = 35;

    float cooldown = 0;
    float invulnerableTime = 0;
    int lives = 2;
    int orbs = 0;

    Bomb bomb;

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
                state = State.MainMenu;
                submenu = Submenu.StageFailed;
                return;
            }

            lives--;
            invulnerableTime = 3;
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

        // Draw the bomb if applicable
        if (bomb != null) bomb.draw();
    }

    boolean step() {
        // Determine the speed
        float speed = (keys.slow ? SPEED / 2.0 : SPEED) / frameRate;

        // Move the player
        if (keys.up && top() > 0) y -= speed;
        if (keys.down && bottom() < HEIGHT) y += speed;
        if (keys.left && left() > 0) x -= speed;
        if (keys.right && right() < WIDTH) x += speed;

        // Decrease the cooldown and the invulnerable time
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
            bomb = new Bomb(x, y);
        }

        // Step the bomb and remove it if its finished
        if (bomb != null && !bomb.step()) bomb = null;

        return true;
    }
}

// The bomb the player creates
class Bomb extends Entity {
    final int DAMAGE = 500;
    final float SPEED = 500;

    float radius = 0;
    HashSet hit = new HashSet();

    Bomb(float x, float y) {
        this.x = x;
        this.y = y;
    }

    // Draw an ellipse
    void draw() {
        ellipse(x, y, radius * 2, radius * 2);
    }

    boolean step() {
        // Loop through unhit enemies
        for (Enemy enemy: enemies.array) if (!hit.contains(enemy) && distanceTo(enemy) < radius) {
            // Deal damage to the enemy 10 times (10x the explosions!)
            for (int i = 0; i < 10; i++) enemy.damage(DAMAGE / 10);
            // Add it to the hashset
            hit.add(enemy);
        }

        // Remove all the bullets in the radius of the bomb
        bullets.array.removeIf(new Predicate<Bullet>() {
            public boolean test(Bullet bullet) {
                return distanceTo(bullet) < radius;
            }
        });

        radius += SPEED / frameRate;
        return radius < mag(HEIGHT, WIDTH);
    }
}