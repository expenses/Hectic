abstract class Movement {
    float x;
    float y;
    float time = 0;

    abstract void step();
}

class Circular extends Movement {
    final float OFFSET = 20;
    final float SPEED = 0.25;

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

// Enter the screen from left/right at one y position, and exit the other side at a different y position
class HorizontalCurve extends Movement {
    final float SPEED = 0.35;
    final float FORCE = 1500;

    float yStart;
    float yEnd;
    boolean leftToRight;

    HorizontalCurve(float yStart, float yEnd, boolean leftToRight) {
        this.yStart = yStart;
        this.yEnd = yEnd;
        this.leftToRight = leftToRight;
    }

    void step() {
        time += SPEED / frameRate;
        if (leftToRight) {
            x = curvePoint(-FORCE, 0, width, width + FORCE, time);
        } else {
            x = curvePoint(width + FORCE, width, 0, -FORCE, time);
        }
        y = curvePoint(yStart, yStart, yEnd, yEnd, time);
    }
}

class VerticalCurve extends Movement {
    final float SPEED = 0.35;
    final float FORCE = 5000;

    float xStart;
    float xEnd;

    VerticalCurve(float xStart, float xEnd) {
        this.xStart = xStart;
        this.xEnd = xEnd;
    }

    void step() {
        time += SPEED / frameRate;
        x = curvePoint(xStart, xStart, xEnd, xEnd, time);
        y = curvePoint(-FORCE, 0, width, width + FORCE, time);
    }
}

// Enter the screen throug the top and then exit through a side
class DiagonalCurve extends Movement {
    final float SPEED = 0.4;
    final float FORCE = 1000;

    float startX;
    float endY;
    boolean leftToRight;

    DiagonalCurve(float startX, float endY, boolean leftToRight) {
        this.startX = startX;
        this.endY = endY;
        this.leftToRight = leftToRight;
    }

    void step() {
        time += SPEED / frameRate;

        if (leftToRight) {
            x = curvePoint(startX, startX, width, width + FORCE, time);
        } else {
            x = curvePoint(startX, startX, 0, -FORCE, time);
        }
        y = curvePoint(-FORCE, 0, endY, endY, time);
    }
}

// Enter the screen from one side and then leave it through the same side
class SideCurve extends Movement {
    final float SPEED = 0.4;

    float yStart;
    float yEnd;
    float force;
    boolean leftToRight;

    SideCurve(float yStart, float yEnd, float force, boolean leftToRight) {
        this.yStart = yStart;
        this.yEnd = yEnd;
        this.force = force;
        this.leftToRight = leftToRight;
    }

    void step() {
        time += SPEED / frameRate;

        if (leftToRight) {
            x = curvePoint(-force, 0, 0, -force, time);
        } else {
            x = curvePoint(width + force, width, width, width + force, time);
        }
        y = curvePoint(yStart, yStart, yEnd, yEnd, time);
    }
}