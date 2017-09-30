// Game enemies

abstract class Enemy extends Hitboxed {
    Movement movement;
    int health;

    boolean step() {
        // Move the enemy
        movement.step(this);
        // If it's touching the player, damage the player
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

    // Is the enmy offscreen? (Adds a bit of padding so that enemies can spawn offscreen)
    boolean offScreen() {
        return x < -image.width  - 50 || x > WIDTH  + image.width  + 50 ||
               y < -image.height - 50 || y > HEIGHT + image.height + 50;
    }
}

// An enemy that fires
abstract class FiringEnemy extends Enemy {
    FiringPattern firing;

    // The bullet that the enemy fires
    abstract Bullet newBullet();

    boolean step() {
        super.step();
        firing.fire(this);
        return remove();
    }
}

// A bat enemy
class Bat extends Enemy {
    Bat(Movement movement) {
        this.movement = movement;
        this.image = resources.bat;
        this.health = 40;
        this.hitboxWidth = 25;
        this.hitboxHeight = 20;
    }
}

// A gargoyle enemy that fires
class Gargoyle extends FiringEnemy {
    Gargoyle(Movement movement, FiringPattern firing) {
        this.movement = movement;
        this.firing = firing;
        this.image = resources.gargoyle;
        this.health = 150;
        this.hitboxWidth = 45;
        this.hitboxHeight = 20;
    }

    Bullet newBullet() {
        return new GargoyleBullet();
    }
}
