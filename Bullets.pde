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
                            enemy.health -= bullet.damage; 
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
                return bullet.offScreen();
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
    int damage = 10;
    
    Bullet(float x, float y, float deltaX, float deltaY, PImage image) {
        this.x = x;
        this.y = y;
        this.deltaX = deltaX;
        this.deltaY = deltaY;
        this.image = image;
    }
  
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