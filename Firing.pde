abstract class FiringPattern {
    float cooldown;
    float cooldownTime;

    boolean canFire() {
        cooldown -= deltaTime;
        return cooldown < 0;
    }

    void setCooldown() {
        cooldown = cooldownTime;
    }

    abstract void fire(Enemy firing);

    void reset() {
        cooldown = cooldownTime;
    }
}

class AtPlayer extends FiringPattern {
    int total;
    float spread;

    AtPlayer(int total, float spread, float cooldown) {
        this.total = total;
        this.spread = spread;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
    }

    void fire(Enemy firing) {
        if (!canFire()) return;

        for (int i = 0; i < total; i++) {
            float rotationDifference = spread * ((total % 2 == 0 ? (total - 1) / 2.0: total / 2) - i) / total;

            Bullet bullet = firing.newBullet();
            bullet.x = firing.x;
            bullet.y = firing.y;

            float rotation = atan2(player.y - bullet.y, player.x - bullet.x) + rotationDifference;

            bullet.deltaX = cos(rotation);
            bullet.deltaY = sin(rotation);
            float length = mag(bullet.deltaX, bullet.deltaY);
            bullet.deltaX *= bullet.speed / length;
            bullet.deltaY *= bullet.speed / length;

            bullets.add(bullet);
        }

        setCooldown();
    }
}

class Circle extends FiringPattern {
    int sides;
    float initialRotation;
    float rotationPerFire;
    int rotationFrequency;
    int tick = 0;

    Circle(int sides, float rotationPerFire, float cooldown) {
        this.sides = sides;
        this.initialRotation = 0;
        this.rotationPerFire = rotationPerFire;
        this.rotationFrequency = 1;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
    }

    Circle(int sides, float initialRotation, float rotationPerFire, int rotationFrequency, float cooldown) {
        this.sides = sides;
        this.initialRotation = initialRotation;
        this.rotationPerFire = rotationPerFire;
        this.rotationFrequency = rotationFrequency;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
    }

    void fire(Enemy firing) {
        if (!canFire()) return;

        for (int side = 0; side < sides; side++) {
            Bullet bullet = firing.newBullet();
            bullet.x = firing.x;
            bullet.y = firing.y;

            float rotation = ((float) side / (float) sides) * TWO_PI + initialRotation;
            bullet.deltaX = cos(rotation) * bullet.speed;
            bullet.deltaY = sin(rotation) * bullet.speed;

            bullets.add(bullet);
        }

        tick ++;

        if (tick % rotationFrequency == 0) initialRotation += rotationPerFire;

        setCooldown();
    }

    void reset() {
        super.reset();
        tick = 0;
    }
}

class Arc extends FiringPattern {
    float startingRotation;
    float spread;

    int count = 0;
    int total;

    Arc(float startingRotation, float spread, int total, float cooldown) {
        this.startingRotation = startingRotation;
        this.spread = spread;
        this.total = total;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
    }

    void fire(Enemy firing) {
        if (!canFire() || count == total) return;

        Bullet bullet = firing.newBullet();
        bullet.x = firing.x;
        bullet.y = firing.y;
        float rotation = startingRotation + spread * ((float) count / (float) total);
        bullet.deltaX = cos(rotation) * bullet.speed;
        bullet.deltaY = sin(rotation) * bullet.speed;

        bullets.add(bullet);
        rotation += spread;
        count ++;
        setCooldown();
    }

    void reset() {
        super.reset();
        count = 0;
    }
}
