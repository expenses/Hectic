// Visual effects on the screen

abstract class Effect extends Entity {
    final float TOTAL_TIME = 0.5;
    float time = TOTAL_TIME;

    boolean step() {
        time -= deltaTime;
        return time < 0;
    }
}

class Explosion extends Effect {
    Explosion(float x, float y) {
        // Add a bit of randomness to the position
        this.x = x + random(-5, 5);
        this.y = y + random(-5, 5);
    }

    void draw() {
        // Get the explosion image to use
        int index = (int) map(time, TOTAL_TIME, 0, 0, resources.explosion.length);
        image = resources.explosion[index];

        super.draw();
    }
}
