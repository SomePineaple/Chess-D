import std.stdio;
import core.stdc.stdlib;
import engine.board;
import bindbd.sdl;

void main() {
    auto board = new Board();
    board.printBoard();

    auto ret = loadSDL();
    if (ret != sdlSupport) {
        if (ret == SDLSupport.noLibary) {
            stderr.writeln("Could not find SDL library, please install it, and make sure its in your PATH");
        } else if (ret == SDLSupport.badLibrary) {
            stderr.writeln("Found a SDL library, but it won't work. Sorry. Try re-installing I guess.");
        }

        exit(EXIT_FAILURE);
    }
}
