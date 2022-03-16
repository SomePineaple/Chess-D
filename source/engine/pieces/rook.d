module engine.pieces.rook;

import engine.pieces.piece;
import engine.pieces.moves.move;
import engine.board;
import std.stdio;

class Rook : Piece {
    private bool moved;

    this(Alliance a, int boardPosition) {
        super(PieceType.ROOK, a == Alliance.WHITE ? 'R' : 'r', a, boardPosition);
        moved = false;
    }

    this(Alliance a, int boardPosition, bool hasMoved) {
        this(a, boardPosition);
        moved = hasMoved;
    }

    override Piece move(int newPos) {
        return new Rook(alliance, newPos, newPos == pos ? false : true);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;

        int[] moveDirections = [1, -1, 8, -8];
        foreach (direction; moveDirections) {
            bool mustStop = false;
            int currentPos = pos;
            while (!mustStop) {
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

                if ((direction == -1 && Board.lowColCheck(currentPos)) || 
                    (direction == 1 && Board.highColCheck(currentPos)))
                    mustStop = true;
            }
        }

        return legalMoves;
    }
}
