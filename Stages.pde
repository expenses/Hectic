final float CLOUD_DELTA = 30;
float cloudY = 0;

import java.util.Collections;

Stage stageOne() {
    Stage stage = new Stage();
    stage.background = resources.nightSky;


    for (float s = 1.0; s < 6; s += 0.5) {
        stage.add(s, new Bat(new HorizontalCurve(100, 300, true)));
        stage.add(s, new Bat(new HorizontalCurve(150, 350, true)));
    }
    
    for (float s = 5.0; s < 6; s += 0.5) {
        stage.add(s, new Bat(new HorizontalCurve(200, 400, false)));
        stage.add(s, new Bat(new HorizontalCurve(250, 450, false)));
    } 
    
    // Add a triplet of gargoyles
    stage.add(25, new Gargoyle(new FiringMove(0.5, 5, 100)));
    stage.add(25, new Gargoyle(new FiringMove(0.25, 5, 100)));
    stage.add(25, new Gargoyle(new FiringMove(0.75, 5, 100)));

    return stage;
}

Stage stageTwo() {
    Stage stage = new Stage();
    stage.background = resources.hallway;

    return stage;
}

class Stage {
    ArrayList<SpawnTime> spawnTimes = new ArrayList<SpawnTime>();
    float time = 0;
    PImage background;

    void add(float time, Enemy enemy) {
        spawnTimes.add(new SpawnTime(time, enemy));
    }

    void step() {
        time += 1.0 / frameRate;

        spawnTimes.removeIf(new Predicate<SpawnTime>() {
            public boolean test(SpawnTime spawn) {
                if (spawn.time <= time) {
                    enemies.add(spawn.enemy);
                    return true;
                } else {
                    return false;
                }
            }
        });
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