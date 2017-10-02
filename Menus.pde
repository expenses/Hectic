// A menu class
class Menu {
    String[] items;
    String title;
    int selected = 0;

    Menu(String title, String... items) {
        this.title = title;
        this.items = items;
    }

    void draw() {
        textAlign(CENTER);

        // Draw the menu title
        textFont(resources.oldeEnglish);
        scale(2);
        text(title, WIDTH / 4.0, HEIGHT / 8.0 + 17);
        resetMatrix();
        textFont(resources.tinyUnicode);

        // Draw the menu items
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
    Menu stages = new Menu(
        "Stages",
        "Stage One",
        "Stage Two",
        "Back"
    );

    Menu controls = new Menu(
        "Controls",
        "Arrow Keys: Movement",
        "Z: Fire",
        "X: Special Attack",
        "Shift (held): Slowed movement",
        "Back"
    );
    
    Menu credits = new Menu(
        "Credits",
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

    MainMenu() {
        super("Hectic", "Play Game", "Controls", "Credits", "Quit");
        credits.selected = credits.items.length - 1;
        controls.selected = controls.items.length - 1;
    }

    void handleKey() {
        // If one of the submenus was open and enter/z/esc was pressed, leave it

        boolean esc = keyCode == ESC;
        boolean confirm = keyCode == ENTER || keyCode == Z_KEY;

        if (submenu != Submenu.MainMenu && submenu != Submenu.Stages && (esc || confirm)) {
            submenu = Submenu.MainMenu;
            return;
        }

        if (submenu == Submenu.Stages) {
            stages.handleKey();

            if (confirm) {
                switch(stages.selected) {
                    case 0:
                       stage = stageOne();
                       break;
                    case 1:
                        stage = stageTwo();
                        break;
                    case 2:
                        submenu = Submenu.MainMenu;
                        break;
                }
            }
            return;
        }

        if (submenu == Submenu.MainMenu) {
            super.handleKey();

            // Quit if the escape key is pressed
            if (esc) {
                exit();
            } else if (confirm) {
                switch (selected) {
                case 0:
                    submenu = Submenu.Stages;
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

    void draw() {
        background(0, 75, 50);

        switch(submenu) {
            case MainMenu:
                super.draw();
                break;
            case Stages:
                stages.draw();
                break;
            case Controls:
                controls.draw();
                break;
            case Credits:
                credits.draw();
                break;
        }
    }
}

class PausedMenu extends Menu {
    PausedMenu() {
        super("Paused", "Continue", "Main menu");
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
}
