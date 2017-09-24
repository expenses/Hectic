final float CLOUD_DELTA = 30;
float cloudY = 0;

Stage stageOne() {
    Stage stage = new Stage();
    stage.background = resources.nightSky;

    stage.add(2.5, new Gargoyle(new FiringMove(0.5, 5, 100)));
    stage.add(2.5, new Gargoyle(new FiringMove(0.25, 5, 100)));
    stage.add(2.5, new Gargoyle(new FiringMove(0.75, 5, 100)));

    //for (float s = 5.0; s < 100; s += 0.05) {
        //stage.add(s, new Bat(new Circular(50, random(1000, 3000))));
        //stage.add(s, new Bat(new FiringMove(random(0, width), 2.5, random(100, 200))));
    //}

    return stage;
}

Stage stageTwo() {
    Stage stage = new Stage();
    stage.background = resources.hallway;

    return stage;
}

class Stage {
    ArrayDeque<SpawnTime> spawnTimes = new ArrayDeque<SpawnTime>();
    float time = 0;
    PImage background;

    void add(float time, Enemy enemy) {
        spawnTimes.add(new SpawnTime(time, enemy));
    }

    void step() {
        time += 1.0 / frameRate;

        while (!spawnTimes.isEmpty()) {
            SpawnTime first = spawnTimes.getFirst();
            if (first.time <= time) {
                enemies.add(spawnTimes.removeFirst().enemy);
            } else {
                break;
            }
        }
    }

    void draw() {
        float cloudHeight = resources.clouds.height * SCALE - height;
        drawScale(background, 0, 0);
        drawScale(resources.clouds, 0, cloudY - cloudHeight);
        resetMatrix();

        if (!paused) cloudY = (cloudY + CLOUD_DELTA / frameRate) % cloudHeight;
    }
}

class SpawnTime {
    float time;
    Enemy enemy;

    SpawnTime(float time, Enemy enemy) {
        this.time = time;
        this.enemy = enemy;
    }
}