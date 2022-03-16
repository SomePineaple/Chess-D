module engine.board;

import engine.pieces.piece;
import engine.pieces.pawn;
import engine.pieces.rook;
import engine.pieces.knight;
import engine.pieces.bishop;
import engine.pieces.queen;
import engine.pieces.king;
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

        pieces[0] = new Rook(Alliance.WHITE, 0);
        pieces[1] = new Knight(Alliance.WHITE, 1);
        pieces[2] = new Bishop(Alliance.WHITE, 2);
        pieces[3] = new Queen(Alliance.WHITE, 3);
        pieces[4] = new King(Alliance.WHITE, 4);
        pieces[5] = new Bishop(Alliance.WHITE, 5);
        pieces[6] = new Knight(Alliance.WHITE, 6);
        pieces[7] = new Rook(Alliance.WHITE, 7);
        for (int i = 8; i < 16; i++) {
            pieces[i] = new Pawn(Alliance.WHITE, i);
        }

        whiteToMove = true;
        updateValidMoves();
    }

    static bool lowColCheck(int pos) {
        return pos % 8 == 0;
    }

    static bool highColCheck(int pos) {
        return pos % 8 == 7;
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
        if (pos > 63 || pos < 0)
            return new OffBoardSpace(pos);

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
