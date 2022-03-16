module engine.pieces.bishop;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.board;

class Bishop : Piece {
    this(Alliance a, int boardPosition) {
        super(PieceType.BISHOP, a == Alliance.WHITE ? 'B' : 'b', a, boardPosition);
    }

    override Piece move(int newPos) {
        return new Bishop(alliance, newPos);
    }

    override Move[] getLegalMoves(Board board) {
        return [];
    }
}
