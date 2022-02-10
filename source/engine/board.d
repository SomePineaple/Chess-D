module engine.board;

import engine.pieces.piece;
import engine.pieces.pawn;
import engine.pieces.moves.move;
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
            pieces[i] = new Pawn(Alliance.WHITE, i);
        }

        whiteToMove = true;
        updateValidMoves();
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
        Move mv = new Move(
            startPos, endPos, 
            pieces[endPos].getType() == PieceType.EMPTYSPACE ? MoveType.NORMAL : MoveType.ATTACK
        );

        foreach (Move move; legalMoves) {
            if (move == mv) {
                move.makeMove(this);
                break;
            }
        }

        updateValidMoves();
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

    private void updateValidMoves() {
        legalMoves = [];

        foreach (Piece piece; pieces) {
            legalMoves ~= piece.getLegalMoves(this);
        }
    }
}
