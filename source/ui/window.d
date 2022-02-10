module ui.window;

import bindbc.sdl;
import std.stdio;
import core.stdc.stdlib;

class Window {
    private int width, height;
    private SDL_Window* window;
    private SDL_Renderer* renderer;
    private bool shouldWindowClose;
    private SDL_Rect sqRect;

    private SDL_Texture *brTexture;
    private SDL_Texture *bnTexture;
    private SDL_Texture *bbTexture;
    private SDL_Texture *bqTexture;
    private SDL_Texture *bkTexture;
    private SDL_Texture *bpTexture;

    private SDL_Texture *wrTexture;
    private SDL_Texture *wnTexture;
    private SDL_Texture *wbTexture;
    private SDL_Texture *wqTexture;
    private SDL_Texture *wkTexture;
    private SDL_Texture *wpTexture;

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

        loadTextures();

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
        destroyTextures();
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

    private void loadTextures() {
        writeln("Attempting to load textures..");
        brTexture = IMG_LoadTexture(renderer, "res/BR.png");
        bnTexture = IMG_LoadTexture(renderer, "res/BN.png");
        bbTexture = IMG_LoadTexture(renderer, "res/BB.png");
        bqTexture = IMG_LoadTexture(renderer, "res/BQ.png");
        bkTexture = IMG_LoadTexture(renderer, "res/BK.png");
        bpTexture = IMG_LoadTexture(renderer, "res/BP.png");

        wrTexture = IMG_LoadTexture(renderer, "res/WR.png");
        wnTexture = IMG_LoadTexture(renderer, "res/WN.png");
        wbTexture = IMG_LoadTexture(renderer, "res/WB.png");
        wqTexture = IMG_LoadTexture(renderer, "res/WQ.png");
        wkTexture = IMG_LoadTexture(renderer, "res/WK.png");
        wpTexture = IMG_LoadTexture(renderer, "res/WP.png");
        writeln("Loaded Textures");

        if (!brTexture || !bnTexture || !bbTexture || !bqTexture || !bkTexture ||
            !bpTexture || !wrTexture || !wnTexture || !wbTexture || !wqTexture ||
            !wkTexture || !wpTexture) {

            stderr.writeln("Failed to load textures");
            exit(EXIT_FAILURE);
        }
    }

    private void destroyTextures() {
        SDL_DestroyTexture(brTexture);
        SDL_DestroyTexture(bnTexture);
        SDL_DestroyTexture(bbTexture);
        SDL_DestroyTexture(bqTexture);
        SDL_DestroyTexture(bkTexture);
        SDL_DestroyTexture(bpTexture);

        SDL_DestroyTexture(wrTexture);
        SDL_DestroyTexture(wnTexture);
        SDL_DestroyTexture(wbTexture);
        SDL_DestroyTexture(wqTexture);
        SDL_DestroyTexture(wkTexture);
        SDL_DestroyTexture(wpTexture);
    }
}
