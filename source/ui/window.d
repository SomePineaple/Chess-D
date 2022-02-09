module ui.window;

import bindbc.sdl;

class Window {
    private int width, height;
    private SDL_Window* window;
    private SDL_Renderer* renderer;
    private bool shouldWindowClose;

    this(int windowWidth, int windowHeight) {
        width = windowWidth;
        height = windowHeight;
        shouldWindowClose = false;
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
        SDL_Event event;

        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case event.type.SDL_QUIT:
                    shouldWindowClose = true;
                    break;
                default:
                    break;
            }
        }
    }

    void render() {
        SDL_RenderClear(renderer);

        // Render board here

        SDL_RenderPresent(renderer);
    }

    bool shouldClose() {
        return shouldWindowClose;
    }
}
