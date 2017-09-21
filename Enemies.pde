class Enemies {
    ArrayList<Enemy> array = new ArrayList<Enemy>();

    void step() {
        for (Enemy enemy: array) {
            enemy.step();
        }
    }

    void draw() {
        for (Enemy enemy: array) {
            enemy.draw();
        }
    }

    void add(Enemy enemy) {
        array.add(enemy);
    }
}

abstract class Enemy {
    PImage image;
    float x;
    float y;
    int health;

    abstract void step();

    void draw() {
        drawImage(image, x, y, 0);
    }
}

class Bat extends Enemy {
    float horizontal = 0;

    Bat(Resources resources, float x, float y) {
        this.x = x;
        this.y = y;
        this.image = resources.bat;
    }

    void step() {
        horizontal += 0.05;

        x += cos(horizontal);
        y += 0.75;
    }
}