# OthelloScope
*Generate and parse Othello/Reversi game records for analysis.*

This program recreates the state of an Othello board from a game record. 

These records will be used to train a machine learning model using user-defined metrics to predict the outcome of a game based on an intermediary board state (bootstrap sampling). These metrics will be ranked in order of importance to generate a heuristic winning strategy. More advanced othello boards with irregular shapes and higher dimensions will be investigated to determine if this strategy holds.

## Types of Board
Boards are split into several abstract types. Bounded Boards are typical othello boards that have defined edges. Topological boards connect edges to form closed surfaces to play on, such as a cylinder (where play wraps around 2 edges). Dimensional boards increace the dimensions of an othello board from a square (2D) to a cube (3D), to a tesseract (4D).
```
AbstractBoard
├───BoundedBoard
│   ├───SquareBoard
│   ├───IrregularBoard
│   └───LatticeBoard
├───TopologicalBoard
└───DimensionalBoard
```

## Credit
*Ben Butterworth 2024*