// Game enemies

abstract class Enemy extends Hitboxed {
    Movement movement;
    int health;
    float speed;

    boolean step() {
        // Move the enemy
        movement.step(this);
        // If it's touching the player, damage the player
        if (this.touching(player)) player.damage();

        return remove();
    }

    // Determine if the enemy should be removed
    boolean remove() {
        if (health <= 0) {
            die();
            return true;
        }

        return offScreen();
    }

    // Damage the enemy
    void damage(int damage) {
        damage(x, y, damage);
    }

    // Damage the enemy at a particular location (to spawn an exlosion there)
    void damage(float x, float y, int damage) {
        effects.add(new Explosion(x, y));
        health -= damage;
    }

    // Kill the enemy and drop a pickup
    void die() {
        if (random(1.0) > 0.6) {
            int value = random(1.0) > 0.9 ? 5 : 1;
            pickups.add(new Pickup(x, y, value));
        }
    }

    // Is the enemy offscreen? (Adds a bit of padding so that enemies can spawn offscreen)
    boolean offScreen() {
        return x < -image.width  - 50 || x > WIDTH  + image.width  + 50 ||
               y < -image.height - 50 || y > HEIGHT + image.height + 50;
    }
}

// An enemy that fires
abstract class FiringEnemy extends Enemy {
    FiringPattern firing;

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
        this.speed = 150;
    }
}

// A bat that has more health
class HellBat extends Bat {
    HellBat(Movement movement) {
        super(movement);
        this.image = resources.hellBat;
        this.health = 120;
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
        this.speed = 150;
    }
}

// An annoying flying skull enemy
class FlyingSkull extends Enemy {
    FlyingSkull(Movement movement) {
        this.movement = movement;
        this.image = resources.flyingSkull;
        this.health = 40;
        this.speed = 200;
        this.hitboxHeight = 25;
        this.hitboxWidth = 25;
    }
}

// A spooky spectre
class Spectre extends FiringEnemy {
    Spectre(Movement movement, FiringPattern firing) {
        this.movement = movement;
        this.firing = firing;
        this.image = resources.spectre;
        this.health = 80;
        this.hitboxWidth = 30;
        this.hitboxHeight = 30;
        this.speed = 200;
    }
}
