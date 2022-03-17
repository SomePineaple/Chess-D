module ui.window;

import bindbc.sdl;
import std.stdio;
import core.stdc.stdlib;
import engine.board;
import engine.pieces.piece;
import engine.pieces.moves.move;

class Window {
    private int width, height;
    private SDL_Window* window;
    private SDL_Renderer* renderer;
    private bool shouldWindowClose;
    private SDL_Rect sqRect;
    private SDL_Rect imgRect;
    private int selectedSquare;

    private SDL_Texture* brTexture;
    private SDL_Texture* bnTexture;
    private SDL_Texture* bbTexture;
    private SDL_Texture* bqTexture;
    private SDL_Texture* bkTexture;
    private SDL_Texture* bpTexture;

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
        imgRect.w = width / 8;
        imgRect.h = height / 8;
        selectedSquare = -1;
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

    void update(Board *board) {
        SDL_Event event;

        while (SDL_PollEvent(&event)) {
            switch (event.type) {
                case event.type.SDL_QUIT:
                    shouldWindowClose = true;
                    break;
                case event.type.SDL_MOUSEBUTTONDOWN:
                    int mousex;
                    int mousey;
                    SDL_GetMouseState(&mousex, &mousey);
                    int click = (((mousey / sqRect.h) * 8) + (mousex / sqRect.w));
                    if (click == selectedSquare) {
                        selectedSquare = -1;
                        writeln("De-selected square ", click);
                        break;
                    } else if (selectedSquare == -1) {
                        selectedSquare = click;
                        writeln("Selected square ", click);
                        break;
                    } else {
                        board.makeMove(63 - selectedSquare, 63 - click);
                        selectedSquare = -1;
                    }
                    break;
                default:
                    break;
            }
        }
    }

    void render(Board board) {
        SDL_RenderClear(renderer);

        renderBoard();
        renderValidMoves(board);
        renderPieces(board);

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

            if (i == selectedSquare)
                SDL_SetRenderDrawColor(renderer, 150, 50, 50, 255);
            else if (((row + col) % 2) == 1)
                SDL_SetRenderDrawColor(renderer, 100, 100, 100, 255);
            else
                SDL_SetRenderDrawColor(renderer, 200, 200, 200, 255);
            
            SDL_RenderFillRect(renderer, &sqRect);
        }
    }

    private void renderValidMoves(Board board) {
        if (selectedSquare == -1)
            return;
        
        Move[] validMoves = board.getPiece(63 - selectedSquare).getLegalMoves(board);

        foreach (move; validMoves) {
            int moveEndPos = 63 - move.getEndPos();
            int row = moveEndPos / 8;
            int col = moveEndPos % 8;

            sqRect.x = col * sqRect.w;
            sqRect.y = row * sqRect.h;

            SDL_SetRenderDrawColor(renderer, 50, 150, 100, 255);
            if ((row + col) % 2 == 1)
                SDL_SetRenderDrawColor(renderer, 50, 100, 150, 255);
            SDL_RenderFillRect(renderer, &sqRect);
        }
    }

    private void renderPieces(Board board) {
        piecesLoop: for (int i = 0; i < 64; i++) {
            auto piece = board.getPiece(i);
            SDL_Texture* tex;
            switch (piece.getAlliance()) {
                case Alliance.NOPIECE:
                    continue piecesLoop;
                case Alliance.WHITE:
                    switch (piece.getType()) {
                        case PieceType.PAWN:
                            tex = wpTexture;
                            break;
                        case PieceType.ROOK:
                            tex = wrTexture;
                            break;
                        case PieceType.KNIGHT:
                            tex = wnTexture;
                            break;
                        case PieceType.BISHOP:
                            tex = wbTexture;
                            break;
                        case PieceType.QUEEN:
                            tex = wqTexture;
                            break;
                        case PieceType.KING:
                            tex = wkTexture;
                            break;
                        default:
                            break;
                    }
                    break;
                case Alliance.BLACK:
                    switch (piece.getType()) {
                        case PieceType.PAWN:
                            tex = bpTexture;
                            break;
                        case PieceType.ROOK:
                            tex = brTexture;
                            break;
                        case PieceType.KNIGHT:
                            tex = bnTexture;
                            break;
                        case PieceType.BISHOP:
                            tex = bbTexture;
                            break;
                        case PieceType.QUEEN:
                            tex = bqTexture;
                            break;
                        case PieceType.KING:
                            tex = bkTexture;
                            break;
                        default:
                            break;
                    }
                    break;
                default:
                    break;
            }

            imgRect.x = (7 - (i % 8)) * imgRect.w;
            imgRect.y = (7 - (i / 8)) * imgRect.h;

            SDL_Rect srcRect;
            srcRect.w = imgRect.w;
            srcRect.h = imgRect.h;
            srcRect.x = 0;
            srcRect.y = 0;

            SDL_RenderCopy(renderer, tex, &srcRect, &imgRect);
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
