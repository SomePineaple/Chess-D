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
import std.algorithm;

class Board {
    private Piece[64] pieces;
    private bool whiteToMove;
    private Move[] legalMoves;

    this() {
        resetBoard();
    }

    this(Board other) {
        resetBoard();
        pieces = other.getPieces();
        updateValidMoves();
    }

    static bool lowTwoColCheck(int pos) {
        int col = pos % 8;
        return col == 0 || col == 1;
    }

    static bool highTwoColCheck(int pos) {
        int col = pos % 8;
        return col == 6 || col == 7;
    }

    static bool lowColCheck(int pos) {
        return pos % 8 == 0;
    }

    static bool highColCheck(int pos) {
        return pos % 8 == 7;
    }

    Alliance checkMate() {
        if (legalMoves.length == 0)
            return whiteToMove ? Alliance.WHITE : Alliance.BLACK;
        return Alliance.NOPIECE;
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

    bool makeMove(int startPos, int endPos) {
        Move mv = new Move(
            startPos, endPos, 
            pieces[endPos].getType() == PieceType.EMPTYSPACE ? MoveType.NORMAL : MoveType.ATTACK
        );

        bool madeMove = false;
        foreach (move; legalMoves) {
            if (move == mv) {
                move.makeMove(this);
                madeMove = true;
                break;
            }
        }

        if (!madeMove)
            return false;

        whiteToMove = !whiteToMove;
        updateValidMoves();
        return true;
    }

    void changeTurn() {
        whiteToMove = !whiteToMove;
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

    Move[] getMoves() {
        return legalMoves;
    }

    bool isWhiteToMove() {
        return whiteToMove;
    }

    private void updateValidMoves() {
        legalMoves = [];

        foreach (piece; pieces) {
            if ((whiteToMove && piece.getAlliance() == Alliance.WHITE) ||
                (!whiteToMove && piece.getAlliance() == Alliance.BLACK))
               legalMoves ~= piece.getLegalMoves(this);
        }
    }

    private void resetBoard() {
        for (int i = 0; i < 64; i++)
            pieces[i] = new EmptySpace(i);

        pieces[0] = new Rook(Alliance.WHITE, 0);
        pieces[1] = new Knight(Alliance.WHITE, 1);
        pieces[2] = new Bishop(Alliance.WHITE, 2);
        pieces[3] = new King(Alliance.WHITE, 3);
        pieces[4] = new Queen(Alliance.WHITE, 4);
        pieces[5] = new Bishop(Alliance.WHITE, 5);
        pieces[6] = new Knight(Alliance.WHITE, 6);
        pieces[7] = new Rook(Alliance.WHITE, 7);

        for (int i = 8; i < 16; i++)
            pieces[i] = new Pawn(Alliance.WHITE, i);

        for (int i = 48; i < 56; i++)
            pieces[i] = new Pawn(Alliance.BLACK, i);

        pieces[56] = new Rook(Alliance.BLACK, 56);
        pieces[57] = new Knight(Alliance.BLACK, 57);
        pieces[58] = new Bishop(Alliance.BLACK, 58);
        pieces[59] = new King(Alliance.BLACK, 59);
        pieces[60] = new Queen(Alliance.BLACK, 60);
        pieces[61] = new Bishop(Alliance.BLACK, 61);
        pieces[62] = new Knight(Alliance.BLACK, 62);
        pieces[63] = new Rook(Alliance.BLACK, 63);
        whiteToMove = true;
        updateValidMoves();
    }
}
