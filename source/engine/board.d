module engine.board;

import engine.pieces.piece;
import engine.pieces.pawn;
import std.stdio;

class Board {
    private Piece[64] pieces;
    private bool whiteToMove;
    private Move[] legalMoves;

    this() {
        for (int i = 0; i < 64; i++) {
            pieces[i] = new EmptySpace(i);
        }

        for (int i = 8; i < 16; i++) {
            pieces[i] = new Pawn(Alliance.BLACK, i);
        }

        whiteToMove = true;
    }

    void printBoard() {
        for (int i = 0; i < 64; i++) {

            write(pieces[i].getBoardPiece());
            write(' ');

            if ((i % 8) == 7) {
                writeln();
            }
        }
    }

    void makeMove(int startPos, int endPos) {
        foreach (Move move; legalMoves) {
            
        }
    }

    Piece getPiece(int pos) {
        return pieces[pos];
    }

    void setPiece(Piece newPiece) {
        pieces[newPiece.getPosition] = newPiece;
    }

    Piece[] getPieces() {
        return pieces;
    }
}
