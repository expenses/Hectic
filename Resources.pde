// Holds all the game resources
class Resources {
    final String images = "resources/images/";
    final String fonts = "resources/fonts/";

    // The player character
    PImage player             = loadImage(images + "player.png");
    PImage playerInvulnerable = loadImage(images + "playerInvulnerable.png");

    // UI stuff
    PImage portrait         = loadImage(images + "ui/portrait.png");
    PImage orbBar           = loadImage(images + "ui/orbBar.png");
    PImage orbBarBackground = loadImage(images + "ui/orbBarBackground.png");
    PImage bossHealthBar    = loadImage(images + "ui/bossHealthBar.png");
    PImage pauseOverlay     = loadImage(images + "ui/pauseOverlay.png");

    // Enemies
    PImage bat      = loadImage(images + "enemies/bat.png");
    PImage hellBat  = loadImage(images + "enemies/hellBat.png");
    PImage gargoyle = loadImage(images + "enemies/gargoyle.png");
    PImage spectre  = loadImage(images + "enemies/spectre.png");
    PImage bossOne  = loadImage(images + "enemies/bossOne.png");
    PImage bossTwo  = loadImage(images + "enemies/bossTwo.png");

    // Bullets
    PImage playerBullet   = loadImage(images + "bullets/playerBullet.png");
    PImage rockBullet     = loadImage(images + "bullets/rockBullet.png");
    PImage colouredBullet = loadImage(images + "bullets/colouredBullet.png");
    PImage darkBullet     = loadImage(images + "bullets/darkBullet.png");

    // Backgrounds
    PImage nightSky  = loadImage(images + "backgrounds/nightSky.png");
    PImage clouds    = loadImage(images + "backgrounds/clouds.png");
    PImage fog       = loadImage(images + "backgrounds/fog.png");
    PImage darkness  = loadImage(images + "backgrounds/darkness.png");
    PImage graveyard = loadImage(images + "backgrounds/graveyard.png");

    // Explosions!
    PImage[] explosion = new PImage[]{
        loadImage(images + "explosion/1.png"),
        loadImage(images + "explosion/2.png"),
        loadImage(images + "explosion/3.png"),
        loadImage(images + "explosion/4.png"),
        loadImage(images + "explosion/5.png"),
        loadImage(images + "explosion/6.png")
    };

    // Orbs
    PImage orb    = loadImage(images + "orb.png");
    PImage bigOrb = loadImage(images + "bigOrb.png");

    // Load the font
    PFont tinyUnicode = createFont(fonts + "TinyUnicode.ttf", 32, false);
    PFont oldeEnglish = createFont(fonts + "OldeEnglish.ttf", 80, false);

    Resources() {
        // Set the font
        textFont(tinyUnicode);
    }
}
