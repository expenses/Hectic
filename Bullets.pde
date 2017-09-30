final int PLAYER_BULLET_DAMAGE = 10;

class Bullet extends Entity {
    float deltaX;
    float deltaY;

    float speed;
  
    boolean step() {
        x += deltaX / frameRate;
        y += deltaY / frameRate;
        return offScreen();
    }

    boolean offScreen() {
        return x < -image.width  || x > width  + image.width ||
               y < -image.height || y > height + image.height;
    }
}

class PlayerBullet extends Bullet {
    PlayerBullet(float rotation) {
        this.speed = 1000;
        this.x = player.x;
        this.y = player.y;
        this.deltaX = cos(rotation - HALF_PI) * this.speed;
        this.deltaY = sin(rotation - HALF_PI) * this.speed;
        this.image = resources.playerBullet;
    }

    boolean step() {
        if (super.step()) return true;

        for (Enemy enemy: enemies.array) {
            if (enemy.touching(x, y)) {
                enemy.damage(x, y, PLAYER_BULLET_DAMAGE);
                return true;
            }
        }

        return false;
    }
}

class EnemyBullet extends Bullet {
    boolean step() {
        if (super.step()) return true;

        if (player.touching(x, y)) {
            player.damage();
            return true;
        } else {
            return false;
        }
    }
}

class GargoyleBullet extends EnemyBullet {
    GargoyleBullet() {
        image = resources.gargoyleBullet;
        speed = 150;
    }
}
