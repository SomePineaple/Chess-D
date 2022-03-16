module engine.pieces.knight;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.board;

class Knight : Piece {
    this(Alliance a, int boardPosition) {
        super(PieceType.KNIGHT, a == Alliance.WHITE ? 'N' : 'n', a, boardPosition);
    }

    override Piece move(int newPos) {
        return new Knight(alliance, newPos);
    }

    override Move[] getLegalMoves(Board board) {
        return [];
    }
}
