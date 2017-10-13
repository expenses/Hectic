// The different stages in the game

// The first stage
Stage stageOne() {
    Stage stage = new Stage(new Background(resources.nightSky, 0), new Background(resources.clouds, 30));

    // Add all the enemies

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

    for (float s = 25; s < 33; s += 0.25) {
        stage.add(s, new Bat(new Circular(200, 1000)));
    }

    for (float s = 35; s < 45; s += 0.25) {
        stage.add(s, new HellBat(new TargetPlayer(random(0, WIDTH), -50)));
    }

    stage.add(50, new BossOne());

    return stage;
}

Stage stageTwo() {
    Stage stage = new Stage(
        new Background(resources.graveyard, 30), new Background(resources.fog, 60), new Background(resources.darkness, 0)
    );

    /*for (float s = 5; s < 15; s += 0.5) {
        stage.add(s, new Spectre(new FiringMove(random(0, 1), 15, random(100, 200)), new AtPlayer(3, 0.5, 2, new BulletFactory(resources.darkBullet, random(100, 200)))));
    }*/

    for (float s = 5;  s < 30; s += 0.5) stage.add(s, new FlyingSkull(new TargetPlayer(random(0, WIDTH), -25)));
    for (float s = 10; s < 30; s += 0.5) stage.add(s, new FlyingSkull(new TargetPlayer(random(0, WIDTH), -25)));

    for (float s = 10; s < 30; s += 0.5) {
        stage.add(s, new FlyingSkull(new TargetPlayer(-25, random(0, HEIGHT/2))));
        stage.add(s, new FlyingSkull(new TargetPlayer(WIDTH + 25, random(0, HEIGHT/2))));
    }

    stage.add(35, new BossTwo());

    return stage;
}

class Stage {
    ArrayList<SpawnTime> spawnTimes = new ArrayList<SpawnTime>();
    Background[] backgrounds;
    float time = 0;

    Stage(Background... backgrounds) {
        this.backgrounds = backgrounds;
        state = State.Playing;
        submenu = Submenu.MainMenu;
        reset();
    }

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

        for (Background background: backgrounds) background.step();
    }

    void draw() {
        for (Background background: backgrounds) background.draw();
    }

    // Go back to the main menu if the stage is finished
    void finish() {
        stage = stageTwo();
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
        float drawY = backgroundY + HEIGHT - backgroundHeight;
        drawScale(image, 0, drawY);
        if (drawY > 0) drawScale(image, 0, drawY - backgroundHeight);
    }

    void step() {
        if (speed > 0) backgroundY = (backgroundY + speed / frameRate) % backgroundHeight;
    }
}
