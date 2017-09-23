abstract class Movement {
    float x;
    float y;

    abstract void step();
}

class Sine extends Movement {
    float time = 0;

    Sine(float percentage, float y) {
        this.x = width * percentage;
        this.y = y;
    }

    void step() {
        time += 2.5 / frameRate;
        x += 100.0 * cos(time) / frameRate;
        y += 75.0  / frameRate;
    }
}

class InOut extends Movement {
    final float OFFSET = 20;
    final float SPEED = 0.25;

    float time = 0;
    float force;
    float yStart;

    InOut(float yStart, float force) {
        this.yStart = yStart;
        this.force = force;
    }

    void step() {
        time += SPEED / frameRate;
        x = curvePoint(-OFFSET, -OFFSET, width + OFFSET, width + OFFSET, time);
        y = curvePoint(yStart - force, yStart, yStart, yStart - force, time);
    }
}