class BossMove {
    FiringPattern pattern;
    float cooldown;
    float cooldownTime;

    BossMove(FiringPattern pattern, float cooldown) {
        this.pattern = pattern;
        this.cooldown = cooldown;
        this.cooldownTime = cooldown;
    }

    void step(Boss boss) {
        cooldownTime -= deltaTime;

        if (cooldownTime < 0) {
            pattern.fire(boss);
            cooldownTime = cooldown;
        }
    }
}

abstract class Boss extends Enemy {
    final float SWITCH_TIME = 7.5;
    float time = 0;
    int maxHealth;
    int move = 0;
    BossMove[] moves;

    void die() {
        boss = null;
        stage.finish();
    }

    void step() {
        // Set the global boss reference
        boss = this;

        movement.step();
        time += deltaTime;

        moves[move].step(this);

        if (time > SWITCH_TIME) {
            time = time % SWITCH_TIME;
            move = (move + 1) % moves.length;
        }
    }
}

class BossOne extends Boss {
    BossOne() {
        this.movement = new FiringMove(0.5, 300, 100);

        this.moves = new BossMove[]{
            new BossMove(new AtPlayer(3, 1), 0.75),
            new BossMove(new Circle(6, 0, 0.2), 0.1),
        };

        this.image = resources.bossOne;
        this.maxHealth = 3000;
        this.health = this.maxHealth;
        this.hitboxWidth = 30;
        this.hitboxHeight = 40;
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
