module engine.pieces.king;

import engine.pieces.piece;
import engine.board;
import engine.pieces.moves.move;
import engine.pieces.moves.castle;
import engine.pieces.rook;



class King : Piece {
    private bool hasMoved;

    this(Alliance a, int boardPosition) {
        super(PieceType.KING, a == Alliance.WHITE ? 'K' : 'k', a, boardPosition);
        hasMoved = false;
    }

    this(Alliance a, int boardPosition, bool hasPieceMoved) {
        super(PieceType.KING, a == Alliance.WHITE ? 'K' : 'k', a, boardPosition);
        hasMoved = hasPieceMoved;
    }

    override Piece move(int newPos) {
        return new King(alliance, newPos, true);
    }

    override Move[] getLegalMoves(Board board) {
        Move[] legalMoves;

        // Regular moves
        int[] possibleMoves = [-1, 1, -8, 8, 7, -7, 9, -9];
        foreach (possibleMove; possibleMoves) {
            if (((possibleMove == -1 || possibleMove == 7 || possibleMove == -9) && Board.lowColCheck(pos)) || 
                ((possibleMove == 1 || possibleMove == 9 || possibleMove == -7) && Board.highColCheck(pos)))
                continue;
            Piece piece = board.getPiece(pos + possibleMove);
            if (piece.getType() == PieceType.EMPTYSPACE)
                legalMoves ~= new Move(pos, pos + possibleMove, MoveType.NORMAL);
            else if (piece.getAlliance() == enemyAlliance)
                legalMoves ~= new Move(pos, pos + possibleMove, MoveType.NORMAL);
        }

        // Castling moves
        if (alliance == Alliance.WHITE && !hasMoved) {
            if (board.getPiece(pos - 1).getType() == PieceType.EMPTYSPACE && 
                board.getPiece(pos - 2).getType() == PieceType.EMPTYSPACE) {
                
                Piece pieceOnCorner = board.getPiece(pos - 3);
                if (auto r = cast(Rook) pieceOnCorner) {
                    if (!r.hasMoved()) {
                        legalMoves ~= new CastleMove(pos, pos - 3);
                    }
                }
            }
        }

        return legalMoves;
    }
}
