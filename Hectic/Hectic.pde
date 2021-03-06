// Create a bunch of stuff
Resources resources;
Player player  = new Player();
Keys keys = new Keys();
EntityList<Enemy> enemies = new EntityList<Enemy>();
EntityList<Bullet> bullets = new EntityList<Bullet>();
EntityList<PlayerBullet> playerBullets = new EntityList<PlayerBullet>();
EntityList effects = new EntityList();
EntityList pickups = new EntityList();
Boss boss = null;
Stage stage;
PausedMenu pausedMenu;
MainMenu mainMenu;
State state = State.MainMenu;
Submenu submenu = Submenu.MainMenu;

// Processing doesn't support the `->` keyword so you have to use predicate classes for stuff :^\
import java.util.function.Predicate;
// HashSets are useful
import java.util.HashSet;

// Final variables. Turn `DEBUG` on and off to see debug info and hitboxes
final int     WIDTH  = 480;
final int     HEIGHT = 640;
final float   SCALE  = 2;
final boolean DEBUG  = false;

// How much time has passed since the last frame
float deltaTime = 0;

// What the game is currently doing
enum State {
    MainMenu,
    Paused,
    Playing
}

// Which submenu of the main menu the game is in
enum Submenu {
    MainMenu,
    Controls,
    Credits,
    StageFailed,
    StageComplete,
    GameComplete
}

void settings() {
    // Set the size and renderer to P2D (uses OpenGL)
    size(WIDTH, HEIGHT, P2D);
}

void setup() {
    // Set the texture sampling to mode 2 (Nearest Neighbour)
    // NOTE: This works fine on my home computers and the CO242 ones,
    // but NOT on the CO219 ones, where it uses the default (driver problems perhaps?)
    ((PGraphicsOpenGL) g).textureSampling(2);
    // Set the framerate
    frameRate(60);

    // Settings for drawing hitboxes
    noFill();
    stroke(255, 0, 0);
    rectMode(CENTER);

    // Set the colour mode for colouring stuff
    colorMode(HSB, 360, 100, 100);

    // Load the resources
    resources = new Resources();
    // Set up the menus
    mainMenu = new MainMenu();
    pausedMenu = new PausedMenu();
}

void update() {
    // Set delta time
    deltaTime = 1.0 / frameRate;
    // Step all the stuff
    stage.step();
    player.step();
    pickups.step();
    playerBullets.step();
    bullets.step();
    enemies.step();
    effects.step();
}

void draw() {
    // Draw a background
    background(0);

    // If the main menu is open draw that
    if (state == State.MainMenu) {
        mainMenu.draw();
        return;
    }

    // If the game is playing, update it
    if (state == State.Playing) update();

    // Draw the main items
    stage.draw();
    player.draw();
    pickups.draw();
    playerBullets.draw();
    bullets.draw();
    enemies.draw();
    effects.draw();

    // Draw the user interface
    drawUI();

    if (state == State.Paused) pausedMenu.draw();
}

// Reset all the game fields
void reset() {
    player = new Player();
    keys = new Keys();
    enemies = new EntityList();
    bullets = new EntityList();
    playerBullets = new EntityList();
    effects = new EntityList();
    pickups = new EntityList();
    boss = null;
}
