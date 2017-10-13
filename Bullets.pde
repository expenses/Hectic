// Bullets in the game

final int PLAYER_BULLET_DAMAGE = 10;

// A bullet in the game
class Bullet extends Entity {
    float deltaX;
    float deltaY;

    float speed;

    Bullet(PImage image, float speed, float x, float y) {
        this.image = image;
        this.speed = speed;
        this.x = x;
        this.y = y;
    }

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
        super(resources.playerBullet, 1000, player.x, player.y);
        this.deltaX = cos(rotation - HALF_PI) * this.speed;
        this.deltaY = sin(rotation - HALF_PI) * this.speed;
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
    EnemyBullet(PImage image, float speed, float x, float y) {
        super(image, speed, x, y);
    }

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

class ColouredBullet extends EnemyBullet {
    color colour;

    ColouredBullet(PImage image, float speed, float x, float y, color colour) {
        super(image, speed, x, y);
        this.colour = colour;
    }

    void draw() {
        // Tint the bullet with the colour
        tint(colour);
        super.draw();
        noTint();
    }
}

// A factory that creates bullets of a specific type
// Used so that different boss firing patterns / types of the same enemy can fire different bullets
class BulletFactory {
    PImage image;
    float speed;

    BulletFactory(PImage image, float speed) {
        this.image = image;
        this.speed = speed;
    }

    EnemyBullet make(float x, float y) {
        return new EnemyBullet(image, speed, x, y);
    }
}

class PurpleBulletFactory extends BulletFactory {
    PurpleBulletFactory(float speed) {
        super(resources.colouredBullet, speed);
    }

    EnemyBullet make(float x, float y) {
        return new ColouredBullet(image, speed, x, y, color(270, 80, random(50, 100)));
    }
}

class OrangeBulletFactory extends BulletFactory {
    OrangeBulletFactory(float speed) {
        super(resources.colouredBullet, speed);
    }

    EnemyBullet make(float x, float y) {
        return new ColouredBullet(image, speed, x, y, color(random(15, 45), 100, 100));
    }
}
