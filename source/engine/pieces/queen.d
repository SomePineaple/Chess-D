module engine.pieces.queen;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.board;

class Queen : Piece {
    this(Alliance a, int boardPosition) {
        super(PieceType.QUEEN, a == Alliance.WHITE ? 'Q' : 'q', a, boardPosition, 9);
    }

    override Piece move(int newPos) {
        return new Queen(alliance, newPos);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;

        int[] moveDirections = [1, -1, 8, -8, 7, -7, 9, -9];
        foreach (direction; moveDirections) {
            bool mustStop = false;
            int currentPos = pos;
            while (!mustStop) {
                if (((direction == 7 || direction == -9 || direction == -1) && Board.lowColCheck(currentPos)) || 
                    ((direction == -7 || direction == 9 || direction == 1) && Board.highColCheck(currentPos))) {
                    mustStop = true;
                    continue;
                }
                currentPos += direction;
                Piece pieceOnNewPos = board.getPiece(currentPos);
                if (pieceOnNewPos.getType() == PieceType.EMPTYSPACE)
                    legalMoves ~= new Move(pos, currentPos, MoveType.NORMAL);
                else if (pieceOnNewPos.getAlliance() != Alliance.NOPIECE) {
                    if (pieceOnNewPos.getAlliance() == alliance)
                        mustStop = true;
                    else {
                        legalMoves ~= new Move(pos, currentPos, MoveType.ATTACK);
                        mustStop = true;
                    }
                } else {
                    mustStop = true;
                }
            }
        }

        return legalMoves;
    }
}
