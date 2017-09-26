interface FiringPattern {
    void fire(Enemy firing);
}

class AtPlayer implements FiringPattern {
    void fire(Enemy firing) {
        Bullet bullet = firing.newBullet();
        bullet.x = firing.movement.x;
        bullet.y = firing.movement.y;

        bullet.deltaX = (player.x - bullet.x);
        bullet.deltaY = (player.y - bullet.y);
        float length = mag(bullet.deltaX, bullet.deltaY);
        bullet.deltaX *= bullet.speed / length;
        bullet.deltaY *= bullet.speed / length;

        enemyBullets.add(bullet);
    }
}

class Circle implements FiringPattern {
    int sides;

    Circle(int sides) {
        this.sides = sides;
    }

    void fire(Enemy firing) {
        for (int side = 0; side < sides; side++) {
            Bullet bullet = firing.newBullet();
            bullet.x = firing.movement.x;
            bullet.y = firing.movement.y;

            float rotation = ((float) side / (float) sides) * TWO_PI;
            bullet.deltaX = cos(rotation) * bullet.speed;
            bullet.deltaY = sin(rotation) * bullet.speed;

            enemyBullets.add(bullet);
        }
    }
}