// Boss enemies!

// A move that a boss performs.
class BossMove {
    // The list of firing patterns
    FiringPattern[] patterns;
    // The movement of the boss towards the specified position
    MoveTowards movement;
    // How long the move lasts
    float duration;
    // What the time is at
    float time = 0;

    BossMove(float x, float y, float duration, FiringPattern... patterns) {
        this.patterns = patterns;
        this.movement = new MoveTowards(x, y);
        this.duration = duration;
    }

    void step(Boss boss) {
        time += deltaTime;

        // If the boss isn't at the position, move it
        if (boss.x != movement.x || boss.y != movement.y) {
            movement.step(boss);
            return;
        }

        // Otherwise fire all the patterns
        for (FiringPattern pattern: patterns) pattern.fire(boss);
    }

    boolean finished() {
        return time > duration;
    }

    void reset() {
        time = 0;
        // Reset the patterns
        for (FiringPattern pattern: patterns) pattern.reset();
    }
}

abstract class Boss extends FiringEnemy {
    int maxHealth;
    int move = 0;
    BossMove[] moves;

    Boss(int health, PImage image) {
        this.health = health;
        this.maxHealth = health;
        this.image = image;
        this.speed = 200;
        this.x = WIDTH / 2.0;
        this.y = -50;
        this.hitboxWidth = 30;
        this.hitboxHeight = 40;
    }

    // Finish the stage if the boss is killed
    void die() {
        boss = null;
        stage.finish();
    }

    boolean step() {
        // Set the global boss reference
        boss = this;

        // Get the move
        BossMove bossMove = moves[move];

        // Step the move
        bossMove.step(this);

        // If the move is finished, switch to the next one
        if (bossMove.finished()) {
            bossMove.reset();
            move = (move + 1) % moves.length;
        }

        return remove();
    }
}

class BossOne extends Boss {
    BossOne() {
        super(3000, resources.bossOne);

        BulletFactory factory = new OrangeBulletFactory(200);

        this.moves = new BossMove[]{
            new BossMove(100, 100, 4, new Arc(0, 2, 20, 0.05, 1, factory), new Arc(2, -2, 20, 0.05, 1, factory)),
            new BossMove(150, 150, 6, new AtPlayer(3, 1, 0.75, factory), new Circle(4, 0.5, 0.1, factory)),
            new BossMove(WIDTH / 2.0, 100, 6, new Circle(6, 0.2, 0.1, factory)),
            new BossMove(400, 200, 2, new AtPlayer(5, 0.5, 0.25, factory)),
        };
    }
}

class BossTwo extends Boss {
    BossTwo() {
        super(4000, resources.bossTwo);

        BulletFactory purple = new PurpleBulletFactory(200);
        BulletFactory dark = new BulletFactory(resources.darkBullet, 200);

        this.moves = new BossMove[]{
            new BossMove(WIDTH/2, 150, 3, new Arc(HALF_PI, TWO_PI, 100, 0.015, 2, dark)),
            new BossMove(WIDTH/2 - 50, 160, 3, new Arc(HALF_PI, -TWO_PI, 100, 0.015, 2, dark)),
            new BossMove(WIDTH/2 + 50, 170, 5,
                new Arc(0 , 2 *  TWO_PI, 101, 0.03, 2, dark),
                new Arc(PI, 2 * -TWO_PI, 101, 0.03, 2, dark)
            ),
            //new BossMove(100, 100, 6, new Arc(HALF_PI, -TWO_PI, 100, 0.015, 2, purple), new AtPlayer(3, 0.1, 0.2, dark)),
            new BossMove(100, 100, 10, new Arc(HALF_PI, 10 * -TWO_PI, 777, 0.01, 1, purple))
        };
    }
}
