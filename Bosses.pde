abstract class Boss extends Enemy {
    int maxHealth;

    void die() {
        boss = null;
    }
}

class BossOne extends Boss {
    final float COOLDOWN = 0.05;
    float cooldown = COOLDOWN;
    Circle firing;

    BossOne() {
        this.movement = new FiringMove(0.5, 300, 100);
        this.firing = new Circle(6);
        this.image = resources.bossOne;
        this.maxHealth = 3000;
        this.health = this.maxHealth;
        this.hitboxWidth = 30;
        this.hitboxHeight = 40;
    }

    void step() {
        boss = this;

        movement.step();
        cooldown -= deltaTime;

        if (cooldown < 0) {
            firing.initialRotation += 0.1;
            firing.fire(this);
            cooldown = COOLDOWN;
        }   
    }

    Bullet newBullet() {
        return new BossOneBullet();
    }
}

class BossOneBullet extends Bullet {
    BossOneBullet() {
        image = resources.bossOneBullet;
        speed = 200;
    }
}