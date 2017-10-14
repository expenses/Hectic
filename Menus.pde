// A menu class
class Menu {
    String[] items;
    String title;
    int selected = 0;
    float yOffset;

    // Create a new menu with a list of items
    Menu(String title, float yOffset, String... items) {
        this.title = title;
        this.yOffset = yOffset;
        this.items = items;
        this.selected = items.length - 1;
    }

    void draw() {
        textAlign(CENTER);

        // Draw the menu title
        textFont(resources.oldeEnglish);
        scale(2);

        // Draw each line of text on the center
        String[] split = title.split("\n");
        float y = HEIGHT / 8.0 + 15;
        
        for (String line: split) {
            text(line, WIDTH / 4.0, y);
            y += 60;
        }

        resetMatrix();
        textFont(resources.tinyUnicode);

        // Draw the menu items
        for (int i = 0; i < items.length; i++) {
            // Add a `>` if the item is selected
            String item = selected == i ? "> " + items[i] : items[i];
            text(item, WIDTH / 2.0, HEIGHT / 2.0 + i * 20 + yOffset);
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
    // All the submenus

    Menu controls = new Menu(
        "Controls", 0,
        "Arrow keys to move",
        "Z (held) to fire",
        "X to perform a special attack if the orb bar is full",
        "Shift (held) to move slower to dodge more easily",
        "Back"
    );

    Menu credits = new Menu(
        "Credits", 0,
        "TinyUnicode font:",
        "https://www.dafont.com/tinyunicode.font",
        "",
        "Olde English font:",
        "https://www.dafont.com/olde-english.font",
        "",
        "Everything else:",
        "Me!",
        "",
        "Back"
    );

    Menu stageFailed = new Menu(
        "Stage\nFailed", 100,
        "Back to main menu"
    );

    Menu stageComplete = new Menu(
        "Stage\nComplete", 100,
        "Next Stage",
        "Back to main menu"
    );

    Menu gameComplete = new Menu(
        "Game\nComplete", 100,
        "Back to main menu"
    );

    MainMenu() {
        super("Hectic", 0, "Play Game", "Controls", "Credits", "Quit");
        selected = 0;
        stageComplete.selected = 0;
    }

    void handleKey() {
        // If one of the submenus was open and enter/z/esc was pressed, leave it

        boolean esc = keyCode == ESC;
        boolean confirm = keyCode == ENTER || keyCode == Z_KEY;

        if (submenu != Submenu.MainMenu && submenu != Submenu.StageComplete && (esc || confirm)) {
            submenu = Submenu.MainMenu;
            return;
        }

        // Change stage or go back to the main menu
        if (submenu == Submenu.StageComplete) {
            stageComplete.handleKey();

            if (confirm) {
                switch(stageComplete.selected) {
                    case 0:
                        stage = stageTwo();
                        break;
                    case 1:
                        submenu = Submenu.MainMenu;
                        break;
                }
            }
            
            return;
        }

        // Enter a submenu
        if (submenu == Submenu.MainMenu) {
            super.handleKey();

            // Quit if the escape key is pressed
            if (esc) {
                exit();
            } else if (confirm) {
                switch (selected) {
                case 0:
                    stage = stageOne();
                    break;
                case 1:
                    // Open the controls submenu
                    submenu = Submenu.Controls;
                    break;
                case 2:
                    // Open the credits submenu
                    submenu = Submenu.Credits;
                    break;
                case 3:
                    exit();
                    break;
                }
            }
        }
    }

    // Draw the main menu
    void draw() {
        background(0, 75, 50);

        switch(submenu) {
            case MainMenu:
                super.draw();
                break;
            case Controls:
                controls.draw();
                break;
            case Credits:
                credits.draw();
                break;
            case StageFailed:
                stageFailed.draw();
                break;
            case StageComplete:
                stageComplete.draw();
                break;
            case GameComplete:
                gameComplete.draw();
                break;
        }
    }
}

// The menu for when the game is paused
class PausedMenu extends Menu {
    PausedMenu() {
        super("Paused", 0, "Continue", "Main menu");
        this.selected = 0;
    }

    void handleKey() {
        super.handleKey();

        // Return to the game or go back to the main menu
        if (keyCode == ESC || keyCode == P_KEY) {
            state = State.Playing;
        } else if (keyCode == ENTER || keyCode == Z_KEY) {
            state = selected == 0 ? State.Playing : State.MainMenu;
        }
    }

    void draw() {
        // Draw a transparent overlay
        image(resources.pauseOverlay, 0, 0, WIDTH, HEIGHT);
        super.draw();
    }
}
