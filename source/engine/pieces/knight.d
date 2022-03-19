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
        Move[] validMoves;

        int[] moveDirections = [6, -6, 10, -10, 15, -15, 17, -17];
        foreach (direction; moveDirections) {
            if (((direction == 15 || direction == -17) && Board.lowColCheck(pos)) || 
                ((direction == -15 || direction == 17) && Board.highColCheck(pos)) ||
                ((direction == 6 || direction == -10) && Board.lowTwoColCheck(pos)) ||
                ((direction == -6 || direction == 10) && Board.highTwoColCheck(pos)))
                continue;
            int endPos = pos + direction;
            auto pieceOnEndPos = board.getPiece(endPos);
            if (pieceOnEndPos.getType() == PieceType.EMPTYSPACE)
                validMoves ~= new Move(pos, endPos, MoveType.NORMAL);
            else if (pieceOnEndPos.getAlliance() == enemyAlliance)
                validMoves ~= new Move(pos, endPos, MoveType.ATTACK);
        }

        return validMoves;
    }
}
