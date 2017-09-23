class Stage {
    ArrayDeque<SpawnTime> spawnTimes = new ArrayDeque<SpawnTime>();
    float time = 0;

    Stage one() {
        reset();

        add(2.5, new Gargoyle(new Sine(0.5, -10)));

        for (float s = 5.0; s < 100; s += 0.05) {
            add(s, new Bat(new InOut(50, random(1000, 3000))));
            //add(s, new Bat(new Sine(0.25, -10)));
            //add(s, new Bat(new Sine(0.75, -10)));
        }

        return this;
    }

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

    void reset() {
        time = 0;
        spawnTimes.clear();
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