import std.stdio;
import core.stdc.stdlib;
import engine.board;
import bindbc.sdl;
import ui.window;

bool loadLib() {
    auto ret = loadSDL();
    if(ret != sdlSupport) {
        string msg;
        if(ret == SDLSupport.noLibrary) {
            msg = "This application requires the SDL library.";
        } else {
            msg = "The version of the SDL library on your system is too low. Please upgrade.";
        }
        writeln(msg);
        return false;
    }
    auto imgRet = loadSDLImage();
    if (imgRet != sdlImageSupport) {
        string msg;
        if (imgRet == SDLImageSupport.noLibrary)
            msg = "This application requires the SDL Image library.";
        else
            msg = "The version of the SDL Image library on your system is too low. Please upgrade.";
        writeln(msg);
        return false;
    }
    return true;
}

int main() {
    version(linux) {
        bool sdlSupport = loadLib();
        if (!sdlSupport)
            return -1;
    }
    version (Windows) {
        loadSDL("libs/SDL2-2.0.20-win32-x64/SDL2.dll");
        loadSDLImage("libs/SDL2_image-2.0.5-win32-x64/SDL2_image.dll");
    }
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

    return 0;
}
