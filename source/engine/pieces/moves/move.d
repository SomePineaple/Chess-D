module engine.pieces.moves.move;

import engine.board;
import engine.pieces.piece;

enum MoveType { NORMAL, ATTACK }

class Move {
    private int startPos, endPos;

    this(int moveStartPos, int moveEndPos) {
        startPos = moveStartPos;
        endPos = moveEndPos;
    }

    void makeMove(Board board) {
        Piece nextPiece = board.getPiece(startPos).move(endPos);
        board.setPiece(new EmptySpace(startPos));
        board.setPiece(nextPiece);
    }

    int getStartPos() {
        return startPos;
    }

    int getEndPos() {
        return endPos;
    }
}
