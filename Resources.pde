class Resources {
    final String images = "resources/images/";
    final String fonts = "resources/fonts/";

    // Load images
    PImage bat            = loadImage(images + "bat.png");
    PImage player         = loadImage(images + "player.png");
    PImage playerBullet   = loadImage(images + "playerBullet.png");
    PImage background     = loadImage(images + "background.png");
    PImage portrait       = loadImage(images + "portrait.png");
    PImage clouds         = loadImage(images + "clouds.png");
    PImage explosion      = loadImage(images + "explosion.png");
    PImage gargoyle       = loadImage(images + "gargoyle.png");
    PImage gargoyleBullet = loadImage(images + "gargoyleBullet.png");
    
    // Load the font
    PFont tinyUnicode = createFont(fonts + "TinyUnicode.ttf", 16, false);
    
    Resources() {
        // Set the font
        textFont(tinyUnicode);
    }
}