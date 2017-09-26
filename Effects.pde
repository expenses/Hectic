class Effects {
    ArrayList<Effect> array = new ArrayList<Effect>();

    void add(Effect effect) {
        array.add(effect);
    }

    void draw() {
        for (Effect effect: array) effect.draw();
    }

    void step() {
        array.removeIf(new Predicate<Effect>() {
            public boolean test(Effect effect) {
                return effect.step();
            }
        });
    }
}

class Effect {
    PImage image;
    float x;
    float y;
    float time = 0.1;

    Effect(PImage image, float x, float y) {
        this.image = image;
        this.x = x;
        this.y = y;
    }

    void draw() {
        drawImage(image, x, y);
    }

    boolean step() {
        time -= deltaTime;
        return time < 0;
    }
}