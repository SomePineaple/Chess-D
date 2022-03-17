module engine.pieces.pawn;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.pieces.moves.pawnupgrade;
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
            int endPos = pos + 8;
            if (board.getPiece(endPos).getType() == PieceType.EMPTYSPACE) {
                if (endPos > 55) {
                    legalMoves ~= new PawnUpgrade(pos, endPos, MoveType.NORMAL);
                } else {
                    legalMoves ~= new Move(pos, endPos, MoveType.NORMAL);
                    if (pos < 16 && pos > 7 && board.getPiece(pos + 16).getType() == PieceType.EMPTYSPACE)
                        legalMoves ~= new Move(pos, pos + 16, MoveType.NORMAL);
                }
           }

            endPos = pos + 7;
            if (board.getPiece(endPos).getAlliance() == enemyAlliance && !Board.lowColCheck(pos)) {
                if (endPos > 55)
                    legalMoves ~= new PawnUpgrade(pos, endPos, MoveType.ATTACK);
                else
                    legalMoves ~= new Move(pos, endPos, MoveType.ATTACK);
            }
            endPos = pos + 9;
            if (board.getPiece(endPos).getAlliance() == enemyAlliance && !Board.highColCheck(pos)) {
                if (endPos > 55)
                    legalMoves ~= new PawnUpgrade(pos, endPos, MoveType.ATTACK);
                else
                    legalMoves ~= new Move(pos, endPos, MoveType.ATTACK);
            }
        } else {
            if (board.getPiece(pos - 8).getType() == PieceType.EMPTYSPACE) {
                legalMoves ~= new Move(pos, pos - 8, MoveType.NORMAL);

                if (pos < 56 && pos > 47 && board.getPiece(pos - 16).getType() == PieceType.EMPTYSPACE)
                    legalMoves ~= new Move(pos, pos - 16, MoveType.NORMAL);
            }

            if (board.getPiece(pos - 7).getAlliance() == enemyAlliance && !Board.highColCheck(pos))
                legalMoves ~= new Move(pos, pos - 7, MoveType.ATTACK);
            if (board.getPiece(pos - 9).getAlliance() == enemyAlliance && !Board.lowColCheck(pos))
                legalMoves ~= new Move(pos, pos - 9, MoveType.ATTACK);
        }

        return legalMoves;
    }
}
