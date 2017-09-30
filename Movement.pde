abstract class Movement {
    float time = 0;
    final float SPEED = 150;

    abstract void step(Enemy enemy);
}

// Move into the screen, stay there for a duration and then move out again
class FiringMove extends Movement {
    final float START_Y = -50;
    float yEnd;
    float duration;
    float x;
    float y;

    FiringMove(float screenPercentage, float duration, float yEnd) {
        this.x = WIDTH * screenPercentage;
        this.y = START_Y;
        this.yEnd = yEnd;
        this.duration = duration;
    }

    void step(Enemy enemy) {
        float distance = SPEED / frameRate;

        if (time == 0.0 && y < yEnd) {
            y += distance;
        } else if (time < duration) {
            time += deltaTime;
        } else {
            y -= distance;
        }

        enemy.x = x;
        enemy.y = y;
    }
}

class MoveTowards extends Movement {
    float x;
    float y;
    float speed;

    MoveTowards(float x, float y, float speed) {
        this.x = x;
        this.y = y;
        this.speed = speed;
    }

    void step(Enemy enemy) {
        float distance = mag(x - enemy.x, y - enemy.y);
        float travel = speed / frameRate;

        if (distance < travel) {
            enemy.x = x;
            enemy.y = y;
        } else {
            enemy.x += ((x - enemy.x) / distance) * travel;
            enemy.y += ((y - enemy.y) / distance) * travel;
        }
    }
}

class TargetPlayer extends Movement {
    PVector target = null;

    void step(Enemy enemy){}
}

class Circular extends Movement {
    final float OFFSET = 20;

    Spline spline;

    Circular(float yStart, float force) {
        spline = new Spline(
            new PVector(-OFFSET, yStart - force),
            new PVector(-OFFSET, yStart),
            new PVector(WIDTH + OFFSET, yStart),
            new PVector(WIDTH + OFFSET, yStart - force)
        );
    }

    void step(Enemy enemy) {
        spline.step(SPEED / frameRate);
        enemy.x = spline.point.x;
        enemy.y = spline.point.y;
    }
}

// Enter the screen from left/right at one y position, and exit the other side at a different y position
class HorizontalCurve extends Movement {
    final float FORCE = 1500;
    final float OFFSET = 20;

    Spline spline;

    HorizontalCurve(float yStart, float yEnd, boolean leftToRight) {
        if (leftToRight) {
            spline = new Spline(
                new PVector(-FORCE - OFFSET, yStart),
                new PVector(-OFFSET, yStart),
                new PVector(WIDTH + OFFSET, yEnd),
                new PVector(WIDTH + FORCE + OFFSET, yEnd)
            );
        } else {
            spline = new Spline(
                new PVector(WIDTH + FORCE + OFFSET, yStart),
                new PVector(WIDTH + OFFSET, yStart),
                new PVector(-OFFSET, yEnd),
                new PVector(-FORCE - OFFSET, yEnd)
            );
        }
    }

    void step(Enemy enemy) {
        spline.step(SPEED / frameRate);
        enemy.x = spline.point.x;
        enemy.y = spline.point.y;
    }
}

class VerticalCurve extends Movement {
    final float FORCE = 2000;

    Spline spline;

    VerticalCurve(float xStart, float xEnd) {
        xStart *= WIDTH;
        xEnd *= WIDTH;

        spline = new Spline(
            new PVector(xStart, -FORCE),
            new PVector(xStart, 0),
            new PVector(xEnd, WIDTH),
            new PVector(xEnd, WIDTH + FORCE)
        );
    }

    void step(Enemy enemy) {
        spline.step(SPEED / frameRate);
        enemy.x = spline.point.x;
        enemy.y = spline.point.y;
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
                new PVector(WIDTH, endY),
                new PVector(WIDTH + FORCE, endY)
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

    void step(Enemy enemy) {
        spline.step(SPEED / frameRate);
        enemy.x = spline.point.x;
        enemy.y = spline.point.y;
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
                new PVector(WIDTH + force, yStart),
                new PVector(WIDTH, yStart),
                new PVector(WIDTH, yEnd),
                new PVector(WIDTH + force, yEnd)
            );
        }
    }

    void step(Enemy enemy) {
        spline.step(SPEED / frameRate);
        enemy.x = spline.point.x;
        enemy.y = spline.point.y;
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
