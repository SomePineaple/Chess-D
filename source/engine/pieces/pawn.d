module engine.pieces.pawn;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.board;

class Pawn : Piece {
    this(Alliance a, int boardPosition) {
        super(PieceType.PAWN, a == Alliance.WHITE ? 'P' : 'p', a, boardPosition);
    }

    override Piece move(int newPos) {
        return new Pawn(alliance, newPos);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;

        if (alliance == Alliance.WHITE) {
            
        }

        return legalMoves;
    }
}
