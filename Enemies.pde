class Enemies {
    ArrayList<Enemy> array = new ArrayList<Enemy>();

    void step() {
        array.removeIf(new Predicate<Enemy>() {
            public boolean test(Enemy enemy) {
                return enemy.step();
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

abstract class Enemy extends Corners {
    final float EDGE_PADDING = 100;

    PImage image;
    Movement movement;
    float cooldown = 0;
    int health;

    float hitboxWidth;
    float hitboxHeight;

    boolean step() {
        movement.step();

        if (offScreen()) return true;

        if (dead()) {
            die();
            return true;
        }

        if (this.touchingRect(player)) player.damage();
        return false;
    }

    boolean dead() {
        return health <= 0;
    }

    void die() {
        if (random(1.0) > 0.9) pickups.add(new Pickup(movement.x, movement.y));
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

    abstract Bullet newBullet();
}

class Bat extends Enemy {
    Bat(Movement movement) {
        this.movement = movement;
        this.image = resources.bat;
        this.health = 30;
        this.hitboxWidth = 25;
        this.hitboxHeight = 20;
    }

    Bullet newBullet() {
        return null;
    }
}

class Gargoyle extends Enemy {
    final float COOLDOWN = 2;

    FiringPattern firing;

    Gargoyle(Movement movement, FiringPattern firing) {
        this.movement = movement;
        this.firing = firing;
        this.image = resources.gargoyle;
        this.health = 50;
        this.hitboxWidth = 45;
        this.hitboxHeight = 20;
        this.cooldown = COOLDOWN;
    }

    void step() {
        movement.step();
        cooldown -= deltaTime;

        if (cooldown < 0) {
            firing.fire(this);
            cooldown = COOLDOWN;
        }   
    }

    Bullet newBullet() {
        return new GargoyleBullet();
    }
}