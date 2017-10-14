// The different stages in the game

// The first stage
Stage stageOne() {
    Stage stage = new Stage(1, new Background(resources.nightSky, 0), new Background(resources.clouds, 30));

    // Add all the enemies

    // Add waves of bats

    for (float s = 1; s < 6; s += 0.25) {
        stage.add(s, new Bat(new HorizontalCurve(100, 300, true)));
        stage.add(s, new Bat(new HorizontalCurve(150, 350, true)));
    }

    for (float s = 3; s < 10; s += 0.25) {
        stage.add(s, new Bat(new HorizontalCurve(200, 400, false)));
        stage.add(s, new Bat(new HorizontalCurve(250, 450, false)));
    }

    for (float s = 12; s < 17; s += 0.25) {
        stage.add(s, new Bat(new VerticalCurve(0.25, 0.5)));
        stage.add(s, new Bat(new VerticalCurve(0.5, 0.75)));
        stage.add(s, new Bat(new VerticalCurve(0.75, 0.25)));
    }

    for (float s = 15; s < 20; s += 0.5) {
        stage.add(s, new Bat(new HorizontalCurve(400, 600, true)));
    }

    // Add a triplet of gargoyles
    BulletFactory rockBullets = new BulletFactory(resources.rockBullet, 150);
    stage.add(23, new Gargoyle(new FiringMove(0.50, 10, 100), new AtPlayer(3, 1, 1, rockBullets)));
    stage.add(23, new Gargoyle(new FiringMove(0.25, 10, 100), new AtPlayer(3, 1, 1, rockBullets)));
    stage.add(23, new Gargoyle(new FiringMove(0.75, 10, 100), new AtPlayer(3, 1, 1, rockBullets)));

    // Supporting bats with the gargoyles

    for (float s = 25; s < 33; s += 0.25) {
        stage.add(s, new Bat(new Circular(200, 1000)));
    }

    // Annoyingly strong hellbats

    for (float s = 35; s < 45; s += 0.25) {
        stage.add(s, new HellBat(new TargetPlayer(random(0, WIDTH), -50)));
    }

    // Finally the boss!

    stage.add(50, new BossOne());

    return stage;
}

Stage stageTwo() {
    Stage stage = new Stage(
        2, 
        new Background(resources.graveyard, 30), new Background(resources.fog, 60), new Background(resources.darkness, 0)
    );

    // Add a bunch of spectres

    BulletFactory darkBullets = new BulletFactory(resources.darkBullet, 200);
    for (float s = 5; s < 20; s += 0.5) {
        stage.add(s, new Spectre(new HorizontalCurve(random(0, HEIGHT/2), random(0, HEIGHT/2), true), new AtPlayer(1, 0, 1, darkBullets)));
    }

    // Lots of flying skulls on all sides! AAahh!!

    for (float s = 25; s < 45; s += 0.5) {
        stage.add(s, new FlyingSkull(new TargetPlayer(random(0, WIDTH), -25)));

        if (s >= 30) {
            stage.add(s, new FlyingSkull(new TargetPlayer(random(0, WIDTH), -25)));
            stage.add(s, new FlyingSkull(new TargetPlayer(-25, random(0, HEIGHT/2))));
            stage.add(s, new FlyingSkull(new TargetPlayer(WIDTH + 25, random(0, HEIGHT/2))));
        }
    }

    // And the boss again

    stage.add(50, new BossTwo());

    return stage;
}

class Stage {
    ArrayList<SpawnTime> spawnTimes = new ArrayList<SpawnTime>();
    Background[] backgrounds;
    float time = 0;
    int number;

    Stage(int number, Background... backgrounds) {
        this.number = number;
        // Add in the backgrounds
        this.backgrounds = backgrounds;
        state = State.Playing;
        submenu = Submenu.MainMenu;
        reset();
    }

    // Make adding enemies simpler
    void add(float time, Enemy enemy) {
        spawnTimes.add(new SpawnTime(time, enemy));
    }

    void step() {
        time += deltaTime;

        spawnTimes.removeIf(new Predicate<SpawnTime>() {
            public boolean test(SpawnTime spawn) {
                // Spawn in enemies if the time is right
                if (spawn.time <= time) {
                    enemies.add(spawn.enemy);
                    return true;
                } else {
                    return false;
                }
            }
        });

        // Move the backgrounds
        for (Background background: backgrounds) background.step();
    }

    // Draw the backgrounds
    void draw() {
        for (Background background: backgrounds) background.draw();
    }

    // Go back to the main menu if the stage is finished
    void finish() {
        state = State.MainMenu;
        submenu = number < 2 ? Submenu.StageComplete : Submenu.GameComplete;
    }
}

// A simple tuple for when an enemy spawns
class SpawnTime {
    float time;
    Enemy enemy;

    SpawnTime(float time, Enemy enemy) {
        this.time = time;
        this.enemy = enemy;
    }
}

// A (potentially-parallaxing) background for a stage
class Background {
    PImage image;
    float backgroundY = 0;
    float backgroundHeight;
    float speed;

    Background(PImage image, float speed) {
        this.image = image;
        this.speed = speed;
        this.backgroundHeight = image.height * SCALE;
    }

    void draw() {
        // Calculate the y position
        float drawY = backgroundY + HEIGHT - backgroundHeight;
        drawScale(image, 0, drawY);
        // If the edge of the background is on screen, draw it again, offset (should be seamless)
        if (drawY > 0) drawScale(image, 0, drawY - backgroundHeight);
    }

    void step() {
        // Move the background
        if (speed > 0) backgroundY = (backgroundY + speed / frameRate) % backgroundHeight;
    }
}
