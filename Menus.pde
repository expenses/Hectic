// A menu class
abstract class Menu {
    String[] items;
    PImage title;
    int selected = 0;
    boolean active = false;

    void draw() {
        // Draw the title image
        drawImage(title, WIDTH / 2.0, HEIGHT / 4.0);

        // Draw the menu items
        textAlign(CENTER);
        for (int i = 0; i < items.length; i++) {
            // Add a `>` if the item is selected
            String item = selected == i ? "> " + items[i] : items[i];
            text(item, WIDTH / 2.0, HEIGHT / 2.0 + i * 20);
        }
        textAlign(LEFT);
    }

    // Handle base key presses
    void handleKey() {
        switch (keyCode) {
            case UP:
                moveUp();
                break;
            case DOWN:
                moveDown();
                break;
        }

    }

    // Move the selection down and wrap around
    void moveDown() {
        selected = (selected + 1) % items.length;
    }

    // Move the selection up and wrap around
    void moveUp() {
        selected = selected == 0 ? items.length - 1 : selected - 1;
    }
}

// The main menu
class MainMenu extends Menu {
    MainMenu() {
        title = resources.title;
        items = new String[]{"Play Game", "Quit"};
        active = true;
    }

    void handleKey() {
        super.handleKey();

        // Quit if the escape key is pressed
        if (keyCode == ESC) {
            exit();
        } else if (keyCode == ENTER || keyCode == Z_KEY) {
            // Turn the menu off
            active = false;
            // Or quit
            if (selected == 1) exit();
        }
    }
}

class PausedMenu extends Menu {
    PausedMenu() {
        title = resources.paused;
        items = new String[]{"Continue", "Main menu"};
    }

    void handleKey() {
        super.handleKey();

        // Return to the game or go back to the main menu
        if (keyCode == ESC || keyCode == P_KEY) {
            active = false;
        } else if (keyCode == ENTER || keyCode == Z_KEY) {
            active = false;
            if (selected == 1) mainMenu.active = true;
        }
    }
}
