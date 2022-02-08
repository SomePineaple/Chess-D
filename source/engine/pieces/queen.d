module engine.pieces.queen;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.board;

class Queen : Piece {
    this(Alliance a, int boardPosition) {
        super(PieceType.QUEEN, a == Alliance.WHITE ? 'Q' : 'q', a, boardPosition);
    }

    override Piece move(int newPos) {
        return new Queen(alliance, newPos);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;

        return legalMoves;
    }
}
