abstract class Movement {
    float x;
    float y;

    abstract void step();
}

class Circular extends Movement {
    final float OFFSET = 20;
    final float SPEED = 0.25;

    float time = 0;
    float force;
    float yStart;

    Circular(float yStart, float force) {
        this.yStart = yStart;
        this.force = force;
    }

    void step() {
        time += SPEED / frameRate;
        x = curvePoint(-OFFSET, -OFFSET, width + OFFSET, width + OFFSET, time);
        y = curvePoint(yStart - force, yStart, yStart, yStart - force, time);
    }
}

// Move into the screen, stay there for a duration and then move out again
class FiringMove extends Movement {
    final float START_Y = -50;
    final float SPEED = 100;
    float yEnd;
    float duration;
    float time = 0;

    FiringMove(float screenPercentage, float duration, float yEnd) {
        this.x = width * screenPercentage;
        this.y = START_Y;
        this.yEnd = yEnd;
        this.duration = duration;
    }

    void step() {
        float distance = SPEED / frameRate;

        if (time == 0.0 && y < yEnd) {
            y += distance;
        } else if (time < duration) {
            time += 1.0 / frameRate;
        } else {
            y -= distance;
        }
    }
}