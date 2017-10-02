// The different stages in the game

final float CLOUD_DELTA = 30;
float cloudY = 0;

// The first stage
Stage stageOne() {
    Stage stage = new Stage();
    stage.background = resources.nightSky;
    stage.clouds = true;

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
    stage.add(23, new Gargoyle(new FiringMove(0.50, 10, 100), new AtPlayer(3, 1, 1)));
    stage.add(23, new Gargoyle(new FiringMove(0.25, 10, 100), new AtPlayer(3, 1, 1)));
    stage.add(23, new Gargoyle(new FiringMove(0.75, 10, 100), new AtPlayer(3, 1, 1)));

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
    Stage stage = new Stage();
    stage.background = resources.graveyard;
    stage.clouds = true;


    return stage;
}

class Stage {
    PImage background;
    boolean clouds;
    ArrayList<SpawnTime> spawnTimes = new ArrayList<SpawnTime>();
    float time = 0;
    float cloudHeight = resources.clouds.height * SCALE - HEIGHT;

    Stage() {
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

        // Move the clouds if they're active
        if (clouds) cloudY = (cloudY + CLOUD_DELTA / frameRate) % cloudHeight;
    }

    void draw() {
        drawScale(background, 0, 0);

        // Draw the clouds if they're active
        if (clouds) drawScale(resources.clouds, 0, cloudY - cloudHeight);
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
