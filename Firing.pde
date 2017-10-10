// Firing patterns (basically what happens when something is off-cooldown)
abstract class FiringPattern {
    float cooldown;
    float cooldownTime;
    BulletFactory factory;

    boolean canFire() {
        cooldown -= deltaTime;
        return cooldown < 0;
    }

    void setCooldown() {
        cooldown = cooldownTime;
    }

    // Get an enemy to fire
    abstract void fire(FiringEnemy firing);

    void reset() {
        cooldown = cooldownTime;
    }
}

// Fire a certain amount of bullets at the player with an even spread
class AtPlayer extends FiringPattern {
    int total;
    float spread;

    AtPlayer(int total, float spread, float cooldown, BulletFactory factory) {
        this.total = total;
        this.spread = spread;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
        this.factory = factory;
    }

    void fire(FiringEnemy firing) {
        if (!canFire()) return;

        // Get the rotation to the player
        float rotation = atan2(player.y - firing.y, player.x - firing.x);

        for (int i = 0; i < total; i++) {
            // Get the difference in rotation from the bullet to the player
            float rotationDifference = spread * ((total % 2 == 0 ? (total - 1) / 2.0: total / 2) - i) / total;

            // Make a bullet and set it off in the right direction
            Bullet bullet = factory.make();
            bullet.x = firing.x;
            bullet.y = firing.y;
            bullet.deltaX = cos(rotation + rotationDifference);
            bullet.deltaY = sin(rotation + rotationDifference);

            float length = mag(bullet.deltaX, bullet.deltaY);
            bullet.deltaX *= bullet.speed / length;
            bullet.deltaY *= bullet.speed / length;

            bullets.add(bullet);
        }

        setCooldown();
    }
}

// Fire bullets in several different even directions, turning the 'circle' by an amount every few ticks
class Circle extends FiringPattern {
    int sides;
    float initialRotation;
    float rotationPerFire;
    int rotationFrequency;
    int tick = 0;

    // Make a simple circle with sides, rotation and a cooldown (that has no initial rotation and rotates once per tick)
    Circle(int sides, float rotationPerFire, float cooldown, BulletFactory factory) {
        this.sides = sides;
        this.initialRotation = 0;
        this.rotationPerFire = rotationPerFire;
        this.rotationFrequency = 1;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
        this.factory = factory;
    }

    // Make a more complex circle with all the options
    Circle(int sides, float initialRotation, float rotationPerFire, int rotationFrequency, float cooldown, BulletFactory factory) {
        this.sides = sides;
        this.initialRotation = initialRotation;
        this.rotationPerFire = rotationPerFire;
        this.rotationFrequency = rotationFrequency;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
        this.factory = factory;
    }

    void fire(FiringEnemy firing) {
        if (!canFire()) return;

        // Fire on all the sides
        for (int side = 0; side < sides; side++) {
            Bullet bullet = factory.make();
            bullet.x = firing.x;
            bullet.y = firing.y;

            float rotation = ((float) side / (float) sides) * TWO_PI + initialRotation;
            bullet.deltaX = cos(rotation) * bullet.speed;
            bullet.deltaY = sin(rotation) * bullet.speed;

            bullets.add(bullet);
        }

        // If the firing ticks over, rotate the circle
        tick ++;
        if (tick % rotationFrequency == 0) initialRotation += rotationPerFire;

        setCooldown();
    }

    void reset() {
        super.reset();
        tick = 0;
    }
}

// Fire a certain number of bullets in an arc between two rotations
class Arc extends FiringPattern {
    float startingRotation;
    float spread;
    int total;
    int count = 0;
    int increase;

    Arc(float startingRotation, float spread, int total, float cooldown, int increase, BulletFactory factory) {
        this.startingRotation = startingRotation;
        this.spread = spread;
        this.total = total;
        this.increase = increase;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
        this.factory = factory;
    }

    void fire(FiringEnemy firing) {
        for (int i = 0; i < increase; i++) {
            // Return if all the bullets have been fired
            if (!canFire() || count == total) return;

            // Make the bullet and set it off right
            Bullet bullet = factory.make();
            bullet.x = firing.x;
            bullet.y = firing.y;
            float rotation = startingRotation + spread * ((float) count / (float) total);
            bullet.deltaX = cos(rotation) * bullet.speed;
            bullet.deltaY = sin(rotation) * bullet.speed;

            bullets.add(bullet);

            // Increase the count
            count ++;
        }

        setCooldown();
    }

    void reset() {
        super.reset();
        // Reset the count
        count = 0;
    }
}
