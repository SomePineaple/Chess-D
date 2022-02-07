module engine.pieces.piece;

import std.stdio;
import engine.pieces.moves.move;
import engine.board;

enum Alliance { WHITE, BLACK, NOPIECE }

enum PieceType { PAWN, ROOK, KNIGHT, BISHOP, QUEEN, KING, EMPTYSPACE }

class Piece {
    protected PieceType type;
    protected char boardPiece;
    protected Alliance alliance;
    protected int pos;

    this(PieceType pieceType, char pieceBoardPiece, Alliance pieceAlliance, int boardPosition) {
        type = pieceType;
        boardPiece = pieceBoardPiece;
        alliance = pieceAlliance;
        pos = boardPosition;
    }

    abstract Piece move(int newPos);
    abstract Move[] getLegalMoves(Board board);

    PieceType getType() {
        return type;
    }

    Alliance getAlliance() {
        return alliance;
    }

    char getBoardPiece() {
        return boardPiece;
    }

    int getPosition() {
        return pos;
    }
}

class EmptySpace : Piece {
    this(int boardPosition) {
        super(PieceType.EMPTYSPACE, '-', Alliance.NOPIECE, boardPosition);
    }

    override Piece move(int newPos) {
        stderr.writeln("An attempt whas made to move an empty space. WHY");
        return new EmptySpace(newPos);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;
        return legalMoves;
    }
}
