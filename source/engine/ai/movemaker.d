module engine.ai.movemaker;

import engine.pieces.moves.move;
import engine.board;
import engine.ai.boardscorer;

interface IMoveMaker {
    Move pickMove(Board b);
}
