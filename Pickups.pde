// Orbs that fall down and are picked up by the player
class Pickup extends Hitboxed {
    float velocity = 0;
    int value;

    Pickup(float x, float y, int value) {
        this.x = x;
        this.y = y;
        this.value = value;
        // Use a different image depending on the value
        this.image = value >= 5 ? resources.bigOrb : resources.orb;
        this.hitboxWidth = 40;
        this.hitboxHeight = 40;
    }

    boolean step() {
        // Increase the velocity and y position
        velocity += 75 / frameRate;
        y += velocity / frameRate;

        // If the player is touching the orb, collect it
        if (player.touching(this)) {
            player.collectOrb(value);
            return true;
        }

        // Return if the orb is offscreen
        return y > HEIGHT + hitboxHeight;
    }
}
