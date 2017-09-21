class Resources {
    // Load images
    PImage sword        = loadImage("resources/images/sword.png");
    PImage skull        = loadImage("resources/images/skull.png");
    PImage cross        = loadImage("resources/images/cross.png");
    PImage orb          = loadImage("resources/images/orb.png");
    PImage bat          = loadImage("resources/images/bat.png");
    PImage player       = loadImage("resources/images/player.png");
    PImage playerBullet = loadImage("resources/images/playerBullet.png");
    PImage background   = loadImage("resources/images/background.png");
    PImage portrait     = loadImage("resources/images/portrait.png");
    
    // Load the font
    PFont tinyUnicode = createFont("resources/fonts/TinyUnicode.ttf", 16, false);
    
    Resources() {
        // Set the font
        textFont(tinyUnicode);
    }
}