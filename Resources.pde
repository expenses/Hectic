class Resources {
    final String images = "resources/images/";
    final String fonts = "resources/fonts/";

    // Load images
    PImage player             = loadImage(images + "player.png");
    PImage playerInvulnerable = loadImage(images + "playerInvulnerable.png");

    PImage portrait         = loadImage(images + "ui/portrait.png");
    PImage orbBar           = loadImage(images + "ui/orbBar.png");
    PImage orbBarBackground = loadImage(images + "ui/orbBarBackground.png");
    PImage bossHealthBar    = loadImage(images + "ui/bossHealthBar.png");

    PImage bat      = loadImage(images + "enemies/bat.png");
    PImage gargoyle = loadImage(images + "enemies/gargoyle.png");
    PImage bossOne  = loadImage(images + "enemies/bossOne.png");

    PImage playerBullet   = loadImage(images + "bullets/playerBullet.png");
    PImage gargoyleBullet = loadImage(images + "bullets/gargoyleBullet.png");
    PImage bossOneBullet  = loadImage(images + "bullets/bossOneBullet.png");

    PImage nightSky = loadImage(images + "backgrounds/nightSky.png");
    PImage clouds   = loadImage(images + "backgrounds/clouds.png");

    PImage[] explosion = new PImage[]{
        loadImage(images + "explosion/1.png"),
        loadImage(images + "explosion/2.png"),
        loadImage(images + "explosion/3.png"),
        loadImage(images + "explosion/4.png"),
        loadImage(images + "explosion/5.png"),
        loadImage(images + "explosion/6.png")
    };

    PImage orb    = loadImage(images + "orb.png");
    PImage bigOrb = loadImage(images + "bigOrb.png");

    // Load the font
    PFont tinyUnicode = createFont(fonts + "TinyUnicode.ttf", 32, false);

    Resources() {
        // Set the font
        textFont(tinyUnicode);
    }
}
