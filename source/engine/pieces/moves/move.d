module engine.pieces.moves.move;

import engine.board;
import engine.pieces.piece;

enum MoveType { NORMAL, ATTACK }

class Move {
    private int startPos, endPos;
    private MoveType type;

    this(int moveStartPos, int moveEndPos, MoveType moveType) {
        startPos = moveStartPos;
        endPos = moveEndPos;
        type = moveType;
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

    override bool opEquals(Object other) {
        if (typeid(other) == typeid(this)) {
            Move otherMove = cast(Move) other;
            
            if (startPos == otherMove.getStartPos() && endPos == otherMove.getEndPos()) {
                return true;
            }
        }

        return false;
    }
}
