module ui.window;

import bindbc.sdl;

class Window {
    private int width, height;
    private SDL_Window* window;
    private SDL_Renderer* renderer;

    this(int windowWidth, int windowHeight) {
        width = windowWidth;
        height = windowHeight;
    }

    void create() {
        window = SDL_CreateWindow(
            "Nathan's Epic Chess Game", 
            SDL_WINDOWPOS_UNDEFINED, SDL_WINDOWPOS_UNDEFINED, 
            width, height, 
            SDL_WINDOW_OPENGL
        );

        renderer = SDL_CreateRenderer(window, -1, SDL_RENDERER_ACCELERATED);

        SDL_ShowWindow(window);
    }

    void update() {

    }

    void render() {
        SDL_RenderClear(renderer);

        // Render board here

        SDL_RenderPresent(renderer);
    }
}
