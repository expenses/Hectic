// See http://docs.oracle.com/javase/6/docs/api/constant-values.html#java.awt.event.KeyEvent
final int P_KEY = 80;
final int X_KEY = 88;
final int Z_KEY = 90;

class Keys {
    boolean up = false;
    boolean down = false;
    boolean left = false;
    boolean right = false;
    boolean fire = false;
    boolean bomb = false;
    boolean slow = false;
}

public void keyPressed() {
    switch (keyCode) {
        case UP:
            keys.up = true;
            break;
        case DOWN:
            keys.down = true;
            break;
        case LEFT:
            keys.left = true;
            break;
        case RIGHT:
            keys.right = true;
            break;
        case Z_KEY:
            keys.fire = true;
            break;
        case X_KEY:
            keys.bomb = true;
            break;
        case SHIFT:
            keys.slow = true;
            break;
        case P_KEY:
            paused = !paused;
            break;
    }
}

public void keyReleased() {
    switch (keyCode) {
        case UP:
            keys.up = false;
            break;
        case DOWN:
            keys.down = false;
            break;
        case LEFT:
            keys.left = false;
            break;
        case RIGHT:
            keys.right = false;
            break;
        case X_KEY:
            keys.bomb = false;
            break;
        case Z_KEY:
            keys.fire = false;
            break;
        case SHIFT:
            keys.slow = false;
            break;
    }
}
