// Bullets in the game

final int PLAYER_BULLET_DAMAGE = 10;

// A bullet in the game
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
        return x < -image.width  || x > WIDTH  + image.width ||
               y < -image.height || y > HEIGHT + image.height;
    }
}

// The bullets that the player fires
class PlayerBullet extends Bullet {
    PlayerBullet(float rotation) {
        this.speed = 1000;
        this.x = player.x;
        this.y = player.y;
        this.deltaX = cos(rotation - HALF_PI) * this.speed;
        this.deltaY = sin(rotation - HALF_PI) * this.speed;
        this.image = resources.playerBullet;
    }

    // Bullets stop if they collide with enemies
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
    // Enemy bullets stop if they collide with the player
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

// The bullets that gargoyles fire
class GargoyleBullet extends EnemyBullet {
    GargoyleBullet() {
        image = resources.gargoyleBullet;
        speed = 150;
    }
}
