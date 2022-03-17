module engine.pieces.moves.pawnupgrade;

import engine.pieces.moves.move;
import engine.board;
import engine.pieces.piece;
import engine.pieces.queen;
import std.stdio;

class PawnUpgrade : Move {
    this(int startPos, int endPos, MoveType type) {
        super(startPos, endPos, type);
    }

    override void makeMove(Board board) {
        Alliance movedPawnAlliance = board.getPiece(startPos).getAlliance();
        board.setPiece(new EmptySpace(startPos));
        board.setPiece(new Queen(movedPawnAlliance, endPos));
    }
}
