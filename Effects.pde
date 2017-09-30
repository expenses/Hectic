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
        this.x = x;
        this.y = y;
    }

    void draw() {
        int index = (int) map(time, TOTAL_TIME, 0, 0, resources.explosion.length);
        image = resources.explosion[index];

        super.draw();
    }
}
