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

    void step() {
        movement.step();
    }

    boolean dead() {
        return health <= 0;
    }

    void draw() {
        drawImage(image, movement.x, movement.y);
    }

    boolean offScreen() {
        return movement.x < -EDGE_PADDING || movement.x > width  + EDGE_PADDING ||
               movement.y < -EDGE_PADDING || movement.y > height + EDGE_PADDING;
    }

    boolean touching(float x, float y) {
        return x >= movement.x - image.width  && x <= movement.x + image.width &&
               y >= movement.y - image.height && y <= movement.y + image.height;
    }
}

class Bat extends Enemy {
    Bat(Movement movement) {
        this.movement = movement;
        this.image = resources.bat;
        this.health = 20;
    }
}

class Gargoyle extends Enemy {
    Gargoyle(Movement movement) {
        this.movement = movement;
        this.image = resources.gargoyle;
        this.health = 40;
    }

    void step() {
        movement.step();
        cooldown -= 1.0 / frameRate;

        if (cooldown < 0) {
            enemyBullets.add(new Bullet(movement.x, movement.y, 0, 100, resources.gargoyleBullet));
            cooldown = 1;
        }   
    }
}