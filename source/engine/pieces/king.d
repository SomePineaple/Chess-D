module engine.pieces.king;

import engine.pieces.piece;
import engine.board;
import engine.pieces.moves.move;



class King : Piece {
    this(Alliance a, int boardPosition) {
        super(PieceType.KING, a == Alliance.WHITE ? 'K' : 'k', a, boardPosition);
    }

    override Piece move(int newPos) {
        return new King(alliance, newPos);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;

        int[] possibleMoves = [-1, 1, -8, 8, 7, -7, 9, -9];
        foreach (possibleMove; possibleMoves) {
            if (((possibleMove == -1 || possibleMove == 7 || possibleMove == -9) && Board.lowColCheck(pos)) || 
                ((possibleMove == 1 || possibleMove == 9 || possibleMove == -7) && Board.highColCheck(pos)))
                continue;
            Piece piece = board.getPiece(pos + possibleMove);
            if (piece.getType() == PieceType.EMPTYSPACE)
                legalMoves ~= new Move(pos, pos + possibleMove, MoveType.NORMAL);
            else if (piece.getAlliance() == (alliance == Alliance.WHITE ? Alliance.BLACK : Alliance.WHITE))
                legalMoves ~= new Move(pos, pos + possibleMove, MoveType.NORMAL);
        }
        return legalMoves;
    }
}
