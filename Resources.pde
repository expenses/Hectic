class Resources {
    final String images = "resources/images/";
    final String fonts = "resources/fonts/";

    // Load images
    PImage player             = loadImage(images + "player.png");
    PImage playerInvulnerable = loadImage(images + "playerInvulnerable.png");
    PImage playerBullet       = loadImage(images + "playerBullet.png");
    PImage portrait           = loadImage(images + "portrait.png");

    PImage orbBar = loadImage(images + "orbBar.png");
    PImage orbBarBackground = loadImage(images + "orbBarBackground.png");

    PImage bat            = loadImage(images + "bat.png");
    PImage gargoyle       = loadImage(images + "gargoyle.png");
    PImage gargoyleBullet = loadImage(images + "gargoyleBullet.png");

    PImage bossHealthBar = loadImage(images + "bossHealthBar.png");

    PImage bossOne       = loadImage(images + "bossOne.png");
    PImage bossOneBullet = loadImage(images + "bossOneBullet.png");
    
    PImage nightSky  = loadImage(images + "nightSky.png");
    PImage clouds    = loadImage(images + "clouds.png");

    PImage explosion = loadImage(images + "explosion.png");
    PImage orb       = loadImage(images + "orb.png");
    
    // Load the font
    PFont tinyUnicode = createFont(fonts + "TinyUnicode.ttf", 32, false);
    
    Resources() {
        // Set the font
        textFont(tinyUnicode);
    }
}
