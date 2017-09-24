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
                bullet.step();

                if (bullet.offScreen()) {
                    return true;
                } else {
                    for (Enemy enemy: enemies.array) {
                        if (enemy.touching(bullet.x, bullet.y)) {
                            effects.add(new Effect(resources.explosion, bullet.x, bullet.y));
                            enemy.health -= PLAYER_BULLET_DAMAGE; 
                            return true;
                        }
                    }
                }

                return false;
            }
        });
    }

    void stepCollidePlayer() {
        array.removeIf(new Predicate<Bullet>() {
            public boolean test(Bullet bullet) {
                bullet.step();
                
                if (bullet.offScreen()) {
                    return true;
                } else if (player.touching(bullet.x, bullet.y)) {
                    player.damage();
                    return true;
                }

                return false;
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
  
    void step() {
        x += deltaX / frameRate;
        y += deltaY / frameRate;
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
    final float SPEED = 1000;

    PlayerBullet() {
        this.x = player.x;
        this.y = player.y;
        this.deltaY = -SPEED;
        this.image = resources.playerBullet;
    }
}

class GargoyleBullet extends Bullet {
    final float SPEED = 150;

    GargoyleBullet(float x, float y) {
        this.x = x;
        this.y = y;
        this.image = resources.gargoyleBullet;

        this.deltaX = (player.x - x);
        this.deltaY = (player.y - y);
        float length = mag(this.deltaX, this.deltaY);
        this.deltaX *= SPEED / length;
        this.deltaY *= SPEED / length;
    }
}