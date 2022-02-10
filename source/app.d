import std.stdio;
import core.stdc.stdlib;
import engine.board;
import bindbc.sdl;
import ui.window;

void main() {
    auto board = new Board();
    board.printBoard();

    auto ret = loadSDL();
    if (ret != sdlSupport) {
        if (ret == SDLSupport.noLibrary) {
            stderr.writeln("Could not find SDL library, please install it, and make sure its in your PATH");
        } else if (ret == SDLSupport.badLibrary) {
            stderr.writeln("Found a SDL library, but it won't work. Sorry. Try re-installing I guess.");
        }

        exit(EXIT_FAILURE);
    }

    auto window = new Window(800, 800);

    window.create();

    while (!window.shouldClose()) {
        window.update();
        window.render();
    }

    window.destroy();
    SDL_Quit();
}
