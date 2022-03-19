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
        Move[] legalMoves;

        int[] moveDirections = [7, -7, 9, -9];
        foreach (direction; moveDirections) {
            bool mustStop = false;
            int currentPos = pos;
            while (!mustStop) {
                if (((direction == 7 || direction == -9) && Board.lowColCheck(currentPos)) || 
                    ((direction == -7 || direction == 9) && Board.highColCheck(currentPos))) {
                    mustStop = true;
                    continue;
                }
                currentPos += direction;
                auto pieceOnNewPos = board.getPiece(currentPos);
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
