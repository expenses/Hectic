abstract class Movement {
    float x;
    float y;
    float time = 0;
    final float SPEED = 150;

    abstract void step();
}

class Circular extends Movement {
    final float OFFSET = 20;

    Spline spline;

    Circular(float yStart, float force) {
        spline = new Spline(
            new PVector(-OFFSET, yStart - force),
            new PVector(-OFFSET, yStart),
            new PVector(width + OFFSET, yStart),
            new PVector(width + OFFSET, yStart - force)
        );
    }

    void step() {
        spline.step(SPEED / frameRate);
        x = spline.point.x;
        y = spline.point.y;
    }
}

// Move into the screen, stay there for a duration and then move out again
class FiringMove extends Movement {
    final float START_Y = -50;
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
    final float FORCE = 1500;

    Spline spline;

    HorizontalCurve(float yStart, float yEnd, boolean leftToRight) {
        if (leftToRight) {
            spline = new Spline(
                new PVector(-FORCE, yStart),
                new PVector(0, yStart),
                new PVector(width, yEnd),
                new PVector(width + FORCE, yEnd)
            );
        } else {
            spline = new Spline(
                new PVector(width + FORCE, yStart),
                new PVector(width, yStart),
                new PVector(0, yEnd),
                new PVector(-FORCE, yEnd)
            );
        }
    }

    void step() {
        spline.step(SPEED / frameRate);
        x = spline.point.x;
        y = spline.point.y;
    }
}

class VerticalCurve extends Movement {
    final float FORCE = 5000;

    Spline spline;

    VerticalCurve(float xStart, float xEnd) {
        spline = new Spline(
            new PVector(xStart, -FORCE),
            new PVector(xStart, 0),
            new PVector(xEnd, width),
            new PVector(xEnd, width + FORCE)
        );
    }

    void step() {
        spline.step(SPEED / frameRate);
        x = spline.point.x;
        y = spline.point.y;
    }
}

// Enter the screen throug the top and then exit through a side
class DiagonalCurve extends Movement {
    final float FORCE = 1000;

    Spline spline;

    DiagonalCurve(float startX, float endY, boolean leftToRight) {
        if (leftToRight) {
            spline = new Spline(
                new PVector(startX, -FORCE),
                new PVector(startX, 0),
                new PVector(width, endY),
                new PVector(width + FORCE, endY)
            );
        } else {
            spline = new Spline(
                new PVector(startX, -FORCE),
                new PVector(startX, 0),
                new PVector(0, endY),
                new PVector(-FORCE, endY)
            );
        }
    }

    void step() {
        spline.step(SPEED / frameRate);
        x = spline.point.x;
        y = spline.point.y;
    }
}

// Enter the screen from one side and then leave it through the same side
class SideCurve extends Movement {
    Spline spline;

    SideCurve(float yStart, float yEnd, float force, boolean leftToRight) {
        if (leftToRight) {
            spline = new Spline(
                new PVector(-force, yStart),
                new PVector(0, yStart),
                new PVector(0, yEnd),
                new PVector(-force, yEnd)
            );
        } else {
            spline = new Spline(
                new PVector(width + force, yStart),
                new PVector(width, yStart),
                new PVector(width, yEnd),
                new PVector(width + force, yEnd)
            );
        }
    }

    void step() {
        spline.step(SPEED / frameRate);
        x = spline.point.x;
        y = spline.point.y;
    }
}

class Spline {
    // The maximum increase to a t value to check.
    // Lowering this will make stepping faster but increases the chance that a point cant be found
    final float MAX_INCREASE = 1.0;
    // How precise the distance needs to be.
    // Increasing this will make stepping faster but more error-prone
    final float PRECISION = 0.1;
    
    PVector a;
    PVector b;
    PVector c;
    PVector d;
    float t = 0;
    
    PVector point;
    
    Spline(PVector a, PVector b, PVector c, PVector d) {
        this.a = a;
        this.b = b;
        this.c = c;
        this.d = d;
        
        this.point = b;
    }
    
    // Interpolate the curve to find a point
    PVector interpolate(float t) {
        return new PVector(curvePoint(a.x, b.x, c.x, d.x, t), curvePoint(a.y, b.y, c.y, d.y, t));
    }
    
    // Use binary search to find an appropriate t value so that the distance between the points ensures a constant speed
    // This works pretty well, but only for simple curves. 
    void step(float distance) {
        float minT = t;
        float maxT = t + MAX_INCREASE;
        
        while (true) {
            float testT = (minT + maxT) / 2.0;
            PVector testPoint = interpolate(testT);
            float testDist = testPoint.dist(point);
                        
            if (abs(testDist - distance) < PRECISION) {
                t = testT;
                point = testPoint;
                return;
            } else if (testDist < distance) {
                minT = testT;
            } else {
                maxT = testT;
            }
        }
    }
}