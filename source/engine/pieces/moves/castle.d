module engine.pieces.moves.castle;

import engine.pieces.moves.move;
import engine.board;
import engine.pieces.piece;

class CastleMove : Move {
    this(int startPos, int endPos) {
        super(startPos, endPos, MoveType.CASTLE);
    }

    override void makeMove(Board board) {
        Piece pieceOnStart = board.getPiece(startPos);
        Piece pieceOnEnd = board.getPiece(endPos);
        
        board.setPiece(new EmptySpace(startPos));
        board.setPiece(new EmptySpace(endPos));
        board.setPiece(pieceOnStart.move(startPos + (startPos > endPos ? -2 : 2)));
        board.setPiece(pieceOnEnd.move(startPos + (startPos > endPos ? -1 : 1)));
    }
}
