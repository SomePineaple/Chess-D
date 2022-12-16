module engine.ai.basicminimax.basicminmax;

import engine.ai.boardscorer;
import engine.ai.movemaker;
import engine.ai.basicminimax.basicscorer;
import engine.pieces.moves.move;
import engine.board;
import std.algorithm.comparison;

class BasicMiniMax : IMoveMaker {
    IBoardScorer scorer;
    this() {
        scorer = new BasicScorer();
    }

    Move pickMove(Board b) {
        Move bestMove = null;
        int bestValue = b.isWhiteToMove() ? int.min : int.max;
        foreach (move; b.getMoves()) {
            if (b.isWhiteToMove()) {
                auto newBoard = new Board(b);
                move.makeMove(newBoard);
                int val = miniMax(newBoard, 6, false);
                if (val > bestValue) {
                    bestValue = val;
                    bestMove = move;
                }
            } else {
                auto newBoard = new Board(b);
                move.makeMove(newBoard);
                int val = miniMax(newBoard, 6, true);
                if (val < bestValue) {
                    bestValue = val;
                    bestMove = move;
                }
            }
        }

        return bestMove;
    }

    int miniMax(Board b, int depth, bool maximizing) {
        if (depth == 0 || b.checkMate())
            return scorer.scoreBoard(b);
        if (maximizing) {
            int val = int.min;
            foreach (move; b.getMoves()) {
                auto newBoard = new Board(b);
                move.makeMove(newBoard);
                val = max(val, miniMax(newBoard, depth - 1, false));
            }
            return val;
        } else {
            int val = int.max;
            foreach (move; b.getMoves()) {
                auto newBoard = new Board(b);
                move.makeMove(newBoard);
                val = min(val, miniMax(newBoard, depth - 1, true));
            }
            return val;
        }
    }
}
