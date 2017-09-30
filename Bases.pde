// An entity in the game world.
abstract class Entity {
    float x;
    float y;
    PImage image;

    void draw() {
        drawImage(image, x, y);
    }

    abstract boolean step();
}

// An entity with a hitbox
abstract class Hitboxed extends Entity {
    float hitboxWidth;
    float hitboxHeight;

    // The four cornets of the hitbox
    float left()   { return x - hitboxWidth / 2.0;  }
    float right()  { return x + hitboxWidth / 2.0;  }
    float top()    { return y - hitboxHeight / 2.0; }
    float bottom() { return y + hitboxHeight / 2.0; } 

    void draw() {
        drawImage(image, x, y);
        // If debug mode is on, draw the hitbox
        if (DEBUG) rect(x, y, hitboxWidth, hitboxHeight);
    }

    // Is the hitbox touching a point
    boolean touching(float x, float y) {
        return x >= left() && x <= right() && y >= top()  && y <= bottom();
    }

    // Is the hitbox intersecting another hitbox
    boolean touching(Hitboxed hitbox) {
        return !(
            left() > hitbox.right()  || right()  < hitbox.left() ||
            top()  > hitbox.bottom() || bottom() < hitbox.top()
        );
    }
}

class EntityList<E extends Entity> {
    ArrayList<E> array = new ArrayList<E>();

    void add(E entity) {
        array.add(entity);
    }

    void step() {
        array.removeIf(new Predicate<E>() {
            public boolean test(E entity) {
                return entity.step();
            }
        });
    }

    void draw() {
        for (E entity: array) entity.draw();
    }
}
