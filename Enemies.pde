class Enemies {
    ArrayList<Enemy> array = new ArrayList<Enemy>();

    void step() {
        array.removeIf(new Predicate<Enemy>() {
            public boolean test(Enemy enemy) {
                enemy.step();
                return enemy.offScreen() || enemy.dead();
            }
        });
    }

    void draw() {
        for (Enemy enemy: array) enemy.draw();
    }

    void add(Enemy enemy) {
        array.add(enemy);
    }
}

class Enemy {
    final float EDGE_PADDING = 100;

    PImage image;
    Movement movement;
    float cooldown = 0;
    int health;

    float hitboxWidth;
    float hitboxHeight;

    void step() {
        movement.step();
        if (player.touchingEnemy(this)) player.damage();
    }

    boolean dead() {
        return health <= 0;
    }

    void draw() {
        drawImage(image, movement.x, movement.y);
        if (DEBUG) rect(movement.x, movement.y, hitboxWidth, hitboxHeight);
    }

    float left() {
        return movement.x - hitboxWidth / 2.0;
    }

    float right() {
        return movement.x + hitboxWidth / 2.0;
    }

    float top() {
        return movement.y - hitboxHeight / 2.0;
    }

    float bottom() {
        return movement.y + hitboxHeight / 2.0;
    }

    boolean offScreen() {
        return movement.x < -EDGE_PADDING || movement.x > width  + EDGE_PADDING ||
               movement.y < -EDGE_PADDING || movement.y > height + EDGE_PADDING;
    }

    boolean touching(float x, float y) {
        return x >= left() && x <= right() && y >= top() && y <= bottom();
    }
}

class Bat extends Enemy {
    Bat(Movement movement) {
        this.movement = movement;
        this.image = resources.bat;
        this.health = 20;
        this.hitboxWidth = 25;
        this.hitboxHeight = 20;
    }
}

class Gargoyle extends Enemy {
    final float COOLDOWN = 2;

    Gargoyle(Movement movement) {
        this.movement = movement;
        this.image = resources.gargoyle;
        this.health = 40;
        this.hitboxWidth = 45;
        this.hitboxHeight = 20;
        this.cooldown = COOLDOWN;
    }

    void step() {
        movement.step();
        cooldown -= 1.0 / frameRate;

        if (cooldown < 0) {
            enemyBullets.add(new GargoyleBullet(movement.x, movement.y));
            cooldown = COOLDOWN;
        }   
    }
}