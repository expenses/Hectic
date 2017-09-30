class Pickup extends Hitboxed {
    float velocity = 0;
    int value;

    Pickup(float x, float y, int value) {
        this.x = x;
        this.y = y;
        this.value = value;
        this.image = value >= 5 ? resources.bigOrb : resources.orb;
        this.hitboxWidth = 30;
        this.hitboxHeight = 30;
    }

    boolean step() {
        velocity += 75 / frameRate;
        y += velocity / frameRate;

        if (player.touching(this)) {
            player.collectOrb(value);
            return true;
        }

        return y > HEIGHT;
    }
}
