final int PLAYER_BULLET_DAMAGE = 10;

class Bullets {
    ArrayList<Bullet> array = new ArrayList<Bullet>();

    void add(Bullet bullet) {
        array.add(bullet);
    }

    void draw() {
        for (Bullet bullet: array) bullet.draw();
    }

    void stepCollideEnemies() {
        array.removeIf(new Predicate<Bullet>() {
            public boolean test(Bullet bullet) {
                return bullet.stepCollideEnemies();
            }
        });
    }

    void stepCollidePlayer() {
        array.removeIf(new Predicate<Bullet>() {
            public boolean test(Bullet bullet) {
                return bullet.stepCollidePlayer();
            }
        });
    }
}

class Bullet {
    float x;
    float y;
    float deltaX;
    float deltaY;
    PImage image;

    float speed;
  
    boolean step() {
        x += deltaX / frameRate;
        y += deltaY / frameRate;
        return offScreen();
    }

    boolean stepCollideEnemies() {
        if (step()) return true;

        for (Enemy enemy: enemies.array) {
            if (enemy.touching(x, y)) {
                damage(enemy);
                return true;
            }
        }

        return false;
    }

    boolean stepCollidePlayer() {
        if (step()) return true;

        if (player.touching(x, y)) {
            player.damage();
            return true;
        } else {
            return false;
        }
    }

    void damage(Enemy enemy) {
        effects.add(new Effect(resources.explosion, x, y));
        enemy.health -= PLAYER_BULLET_DAMAGE; 
    }
  
    void draw() {
        drawImage(image, x, y);
    }

    boolean offScreen() {
        return x < -image.width  || x > width  + image.width ||
               y < -image.height || y > height + image.height;
    }
}

class PlayerBullet extends Bullet {
    PlayerBullet(float x, float y) {
        this.speed = 1000;
        this.x = player.x + x;
        this.y = player.y + y;
        this.deltaY = -this.speed;
        this.image = resources.playerBullet;
    }
}

class GargoyleBullet extends Bullet {
    GargoyleBullet() {
        image = resources.gargoyleBullet;
        speed = 150;
    }
}