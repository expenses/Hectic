class Pickups {
    ArrayList<Pickup> array = new ArrayList<Pickup>();

    void add(Pickup pickup) {
        array.add(pickup);
    }

    void draw() {
        for (Pickup pickup: array) pickup.draw();
    }

    void step() {
        array.removeIf(new Predicate<Pickup>() {
            public boolean test(Pickup pickup) {
                return pickup.step();
            }
        });
    }
}

class Pickup extends Corners {
    final float HITBOX_SIZE = 30;

    float x;
    float y;
    float velocity = 0;
    PImage image;

    Pickup(float x, float y) {
        this.x = x;
        this.y = y;
        this.image = resources.orb;
    }

    float left() {
        return x - HITBOX_SIZE / 2.0;
    }

    float right() {
        return x + HITBOX_SIZE / 2.0;
    }

    float top() {
        return y - HITBOX_SIZE / 2.0;
    }

    float bottom() {
        return y + HITBOX_SIZE / 2.0;
    }

    void draw() {
        drawImage(image, x, y);
        if (DEBUG) rect(x, y, HITBOX_SIZE, HITBOX_SIZE);
    }

    boolean step() {
        velocity += 75 / frameRate;
        y += velocity / frameRate;

        if (player.touchingRect(this)) {
            player.pickups ++;
            return true;
        }

        return y > height;
    }
}

