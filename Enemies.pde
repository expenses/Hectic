abstract class Enemy extends Hitboxed {
    final float EDGE_PADDING = 100;

    Movement movement;
    float cooldown = 0;
    int health;

    boolean step() {
        movement.step(this);
        if (this.touching(player)) player.damage();

        return remove();
    }

    boolean remove() {
        if (health <= 0) {
            die();
            return true;
        }

        return offScreen();
    }

    void damage(int damage) {
        damage(x, y, damage);
    }

    void damage(float x, float y, int damage) {
        effects.add(new Explosion(x, y));
        health -= damage; 
    }

    void die() {
        if (random(1.0) > 0.6) {
            int value = random(1.0) > 0.9 ? 5 : 1;
            pickups.add(new Pickup(x, y, value));
        }
    }

    boolean offScreen() {
        return x < -EDGE_PADDING || x > width  + EDGE_PADDING ||
               y < -EDGE_PADDING || y > height + EDGE_PADDING;
    }

    abstract Bullet newBullet();
}

class Bat extends Enemy {
    Bat(Movement movement) {
        this.movement = movement;
        this.image = resources.bat;
        this.health = 40;
        this.hitboxWidth = 25;
        this.hitboxHeight = 20;
    }

    Bullet newBullet() {
        return null;
    }
}

class Gargoyle extends Enemy {
    FiringPattern firing;

    Gargoyle(Movement movement, FiringPattern firing) {
        this.movement = movement;
        this.firing = firing;
        this.image = resources.gargoyle;
        this.health = 150;
        this.hitboxWidth = 45;
        this.hitboxHeight = 20;
    }

    boolean step() {
        super.step();
        firing.fire(this);
        return remove();
    }

    Bullet newBullet() {
        return new GargoyleBullet();
    }
}
