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

    bool inCheck(Board board) {
        bool inCheck = false;
        // Check for pawns
        if (alliance == Alliance.WHITE) {
            int endPos = pos + 7;
            Piece pieceOnEndPos = board.getPiece(endPos);
            if (pieceOnEndPos.getAlliance() == enemyAlliance && pieceOnEndPos.getType() == PieceType.PAWN &&
                    !Board.lowColCheck(pos))
                inCheck = true;
            endPos = pos + 9;
            pieceOnEndPos = board.getPiece(endPos);
            if (board.getPiece(endPos).getAlliance() == enemyAlliance && pieceOnEndPos.getType() == PieceType.PAWN &&
                    !Board.highColCheck(pos))
                inCheck = true;
        } else {
            Piece pieceOnEndPos = board.getPiece(pos - 7);
            if (pieceOnEndPos.getAlliance() == enemyAlliance && pieceOnEndPos.getType() == PieceType.PAWN &&
                    !Board.highColCheck(pos))
                inCheck = true;
            pieceOnEndPos = board.getPiece(pos - 9);
            if (pieceOnEndPos.getAlliance() == enemyAlliance && pieceOnEndPos.getType() == PieceType.PAWN &&
                    !Board.lowColCheck(pos))
                inCheck = true;
        }

        // Check for rooks and queens
        int[] moveDirections = [1, -1, 8, -8];
        foreach (direction; moveDirections) {
            bool mustStop = false;
            int currentPos = pos;
            while (!mustStop) {
                if ((direction == -1 && Board.lowColCheck(currentPos)) || 
                    (direction == 1 && Board.highColCheck(currentPos))) {
                    mustStop = true;
                    continue;
                }
                currentPos += direction;
                Piece pieceOnNewPos = board.getPiece(currentPos);
                if (pieceOnNewPos.getType() == PieceType.EMPTYSPACE)
                    continue;
                else if (pieceOnNewPos.getAlliance() != Alliance.NOPIECE) {
                    if (pieceOnNewPos.getAlliance() == alliance)
                        mustStop = true;
                    else {
                        if (pieceOnNewPos.getType() == PieceType.ROOK || pieceOnNewPos.getType() == PieceType.QUEEN)
                            inCheck = true;
                        mustStop = true;
                    }
                } else
                    mustStop = true;
            }
        }
        
        // Check for bishops and queens
        moveDirections = [7, -7, 9, -9];
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
                Piece pieceOnNewPos = board.getPiece(currentPos);
                if (pieceOnNewPos.getType() == PieceType.EMPTYSPACE)
                    continue;
                else if (pieceOnNewPos.getAlliance() != Alliance.NOPIECE) {
                    if (pieceOnNewPos.getAlliance() == alliance)
                        mustStop = true;
                    else if (pieceOnNewPos.getType() == PieceType.BISHOP || pieceOnNewPos.getType() == PieceType.QUEEN){
                        inCheck = true;
                        mustStop = true;
                    }
                } else
                    mustStop = true;
            }
        }

        moveDirections = [6, -6, 10, -10, 15, -15, 17, -17];
        foreach (direction; moveDirections) {
            if (((direction == 15 || direction == -17) && Board.lowColCheck(pos)) || 
                ((direction == -15 || direction == 17) && Board.highColCheck(pos)) ||
                ((direction == 6 || direction == -10) && Board.lowTwoColCheck(pos)) ||
                ((direction == -6 || direction == 10) && Board.highTwoColCheck(pos)))
                continue;
            auto pieceOnPos = board.getPiece(pos + direction);
            if (pieceOnPos.getAlliance() == enemyAlliance && pieceOnPos.getType() == PieceType.KNIGHT)
                inCheck = true;
        }

        return inCheck;
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
        if (!hasMoved) {
            if (board.getPiece(pos - 1).getType() == PieceType.EMPTYSPACE && 
                board.getPiece(pos - 2).getType() == PieceType.EMPTYSPACE) {
                
                Piece pieceOnCorner = board.getPiece(pos - 3);
                if (auto r = cast(Rook) pieceOnCorner)
                    if (!r.hasMoved()) {
                        legalMoves ~= new CastleMove(pos, pos - 3);
                }
            }
            
            bool pieceInWay = false;
            for (int i = 1; i <= 3; i++)
                pieceInWay = pieceInWay || board.getPiece(pos + i).getType() != PieceType.EMPTYSPACE;
            
            if (!pieceInWay) {
                Piece pieceOnCorner = board.getPiece(pos + 4);
                if (auto r = cast(Rook) pieceOnCorner) {
                    if (!r.hasMoved())
                        legalMoves ~= new CastleMove(pos, pos + 4);
                }
            }
        } 
        return legalMoves;
    }
}
