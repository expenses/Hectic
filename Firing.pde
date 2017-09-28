interface FiringPattern {
    void fire(Enemy firing);
}

class AtPlayer implements FiringPattern {
    int total;
    float spread;

    AtPlayer(int total, float spread) {
        this.total = total;
        this.spread = spread;
    }

    void fire(Enemy firing) {
        for (int i = 0; i < total; i++) {
            float rotationDifference = spread * ((total % 2 == 0 ? (total - 1) / 2.0: total / 2) - i) / total;

            Bullet bullet = firing.newBullet();
            bullet.x = firing.movement.x;
            bullet.y = firing.movement.y;

            float rotation = atan2(player.y - bullet.y, player.x - bullet.x) + rotationDifference;

            bullet.deltaX = cos(rotation);
            bullet.deltaY = sin(rotation);
            float length = mag(bullet.deltaX, bullet.deltaY);
            bullet.deltaX *= bullet.speed / length;
            bullet.deltaY *= bullet.speed / length;

            enemyBullets.add(bullet);
        }
    }
}

class Circle implements FiringPattern {
    int sides;
    float initialRotation = 0;
    float rotationPerFire = 0;

    Circle(int sides, float initialRotation, float rotationPerFire) {
        this.sides = sides;
        this.initialRotation = initialRotation;
        this.rotationPerFire = rotationPerFire;
    }

    void fire(Enemy firing) {
        for (int side = 0; side < sides; side++) {
            Bullet bullet = firing.newBullet();
            bullet.x = firing.movement.x;
            bullet.y = firing.movement.y;

            float rotation = ((float) side / (float) sides) * TWO_PI + initialRotation;
            bullet.deltaX = cos(rotation) * bullet.speed;
            bullet.deltaY = sin(rotation) * bullet.speed;

            enemyBullets.add(bullet);
        }

        initialRotation += rotationPerFire;
    }
}
