// A move that a boss performs. Firing patterns have an associated cooldown
class BossMove {
    FiringPattern[] patterns;
    MoveTowards movement;
    float duration;
    float time = 0;

    BossMove(float x, float y, float duration, FiringPattern... patterns) {
        this.patterns = patterns;
        this.movement = new MoveTowards(x, y, 200);
        this.duration = duration;
    }

    void step(Boss boss) {
        time += deltaTime;

        if (boss.x != movement.x || boss.y != movement.y) {
            movement.step(boss);
            return;
        }

        for(FiringPattern pattern: patterns) pattern.fire(boss);
    }

    boolean finished() {
        return time > duration;
    }

    void reset() {
        time = 0;
        for (FiringPattern pattern: patterns) pattern.reset();
    }
}

abstract class Boss extends Enemy {
    int maxHealth;
    int move = 0;
    BossMove[] moves;

    void die() {
        boss = null;
        stage.finish();
    }

    boolean step() {
        // Set the global boss reference
        boss = this;

        BossMove bossMove = moves[move];

        bossMove.step(this);

        if (bossMove.finished()) {
            bossMove.reset();
            move = (move + 1) % moves.length;
        }

        return remove();
    }
}

class BossOne extends Boss {
    BossOne() {
        this.x = WIDTH / 2.0;
        this.y = -50;

        this.moves = new BossMove[]{
            new BossMove(100, 100, 4, new Arc(0, 2, 20, 0.05), new Arc(2, -2, 20, 0.05)),
            new BossMove(150, 150, 6, new AtPlayer(3, 1, 0.75), new Circle(4, 0.5, 0.1)),
            new BossMove(WIDTH / 2.0, 100, 6, new Circle(6, 0.2, 0.1)),
            new BossMove(400, 200, 2, new AtPlayer(5, 0.5, 0.25)),
        };

        this.image = resources.bossOne;
        this.maxHealth = 3000;
        this.health = this.maxHealth;
        this.hitboxWidth = 30;
        this.hitboxHeight = 40;
    }

    Bullet newBullet() {
        return new BossOneBullet(200);
    }
}

class BossOneBullet extends EnemyBullet {
    color colour;

    BossOneBullet(float speed) {
        this.image = resources.bossOneBullet;
        this.speed = speed;
        this.colour = color(255, 128 + random(-1, 1) * 40, 0);
    }

    void draw() {
        tint(colour);
        super.draw();
        noTint();
    }
}
