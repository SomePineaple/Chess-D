module ui.window;

import bindbc.sdl;

class Window {
    private int width, height;
    private SDL_Window* window;
    private SDL_Renderer* renderer;
    private bool shouldWindowClose;
    private SDL_Rect sqRect;

    this(int windowWidth, int windowHeight) {
        width = windowWidth;
        height = windowHeight;
        shouldWindowClose = false;
        sqRect.w = width / 8;
        sqRect.h = height / 8;
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

        renderBoard();

        SDL_RenderPresent(renderer);
    }

    bool shouldClose() {
        return shouldWindowClose;
    }

    void destroy() {
        SDL_DestroyRenderer(renderer);
        SDL_DestroyWindow(window);
    }

    private void renderBoard() {
        for (int i = 0; i < 64; i++) {
            int row = i / 8;
            int col = i % 8;

            sqRect.x = col * sqRect.w;
            sqRect.y = row * sqRect.h;

            if (((row + col) % 2) == 1)
                SDL_SetRenderDrawColor(renderer, 100, 100, 100, 255);
            else
                SDL_SetRenderDrawColor(renderer, 200, 200, 200, 255);
            
            SDL_RenderFillRect(renderer, &sqRect);
        }
    }
}
