import std.stdio;
import core.stdc.stdlib;
import engine.board;
import bindbc.sdl;
import ui.window;

void main() {
    auto board = new Board();
    board.printBoard();

    if (SDL_Init(SDL_INIT_VIDEO | SDL_INIT_EVENTS)) {
        stderr.writeln("Failed to initialize SDL2: ", SDL_GetError());
        exit(EXIT_FAILURE);
    }

    if (IMG_Init(IMG_INIT_PNG) == 0) {
        stderr.writeln("Failed to initialize SDL2_Image: ", IMG_GetError());
        exit(EXIT_FAILURE);
    }

    auto window = new Window(800, 800);

    window.create();

    while (!window.shouldClose()) {
        window.update(&board);
        window.render(board);
    }

    window.destroy();
    SDL_Quit();
}
