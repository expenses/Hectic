class Bullets {
    ArrayList<Bullet> array = new ArrayList<Bullet>();

    void add(Bullet bullet) {
        array.add(bullet);
    }

    void draw() {
        for (Bullet bullet: array) {
            bullet.draw();
        }
    }

    void step() {
        for (int i = 0; i < array.size(); i++) {
            Bullet bullet = array.get(i);
            bullet.step();

            // Remove the off-screen bullets
            if (bullet.offScreen()) {
                array.remove(i);
                i--;
            }
        }
    }
}

class Bullet {
    float x;
    float y;
    float deltaX;
    float deltaY;
    PImage image;
    int damage;
    
    Bullet(float x, float y, float deltaX, float deltaY, PImage image) {
        this.x = x;
        this.y = y;
        this.deltaX = deltaX;
        this.deltaY = deltaY;
        this.image = image;
    }
  
    void step() {
        x += deltaX;
        y += deltaY;
    }
  
    void draw() {
        drawImage(image, x, y, atan2(deltaY, deltaX));
    }

    boolean offScreen() {
        return x < -image.width  || x > width  + image.width ||
               y < -image.height || y > height + image.height;
    }
}