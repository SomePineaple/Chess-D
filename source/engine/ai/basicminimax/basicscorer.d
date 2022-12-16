module engine.ai.basicminimax.basicscorer;

import engine.ai.boardscorer;
import engine.board;
import engine.pieces.piece;
import engine.pieces.king;

class BasicScorer : IBoardScorer {
    const checkBonus = 5;

    int scoreBoard(Board b) {
        int score = 0;

        auto mate = b.checkMate();
        if (mate != Alliance.NOPIECE)
            return mate == Alliance.WHITE ? -10_000 : 10_000;

        foreach(p; b.getPieces()) {
            if (p.getAlliance() == Alliance.WHITE) {
                score += p.getValue();
            } else if (p.getAlliance() == Alliance.BLACK) {
                score -= p.getValue();
            }
            if (auto king = cast(King) p) {
                if (king.inCheck(b))
                    score += p.getAlliance() == Alliance.WHITE ? checkBonus : -checkBonus;
            }
        }

        return score;
    }
}
