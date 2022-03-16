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
            if (board.getPiece(pos + 8).getType() == PieceType.EMPTYSPACE) {
                legalMoves ~= new Move(pos, pos + 8, MoveType.NORMAL);

                if (pos < 16 && pos > 7 && board.getPiece(pos + 16).getType() == PieceType.EMPTYSPACE)
                    legalMoves ~= new Move(pos, pos + 16, MoveType.NORMAL);
            }
        } else {
            if (board.getPiece(pos - 8).getType() == PieceType.EMPTYSPACE) {
                legalMoves ~= new Move(pos, pos - 8, MoveType.NORMAL);

                if (pos < 56 && pos > 47 && board.getPiece(pos - 16).getType() == PieceType.EMPTYSPACE)
                    legalMoves ~= new Move(pos, pos - 16, MoveType.NORMAL);
            }
        }

        return legalMoves;
    }
}
