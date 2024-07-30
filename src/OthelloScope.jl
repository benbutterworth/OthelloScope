module OthelloScope

include("isValidBoard.jl")
include("boardtostring.jl")
include("Board.jl")

# example record: Jacob vs Ben 4 July 2024 d3c5e6f3d6c6e3f5f4f7f6g5c4e2g3c2c3d2g4h3f2b5b4b3c1h4e7f1a4b6h6h5h2d1g6a3a5a6c7c8e8d7e1g8d8b1b8g7h7h8a7h1a2f8b2a8b7a1g2g1

#=
1 - GET A GAME GAME RECORD
    - check format is valid (regex?)
    - r"^([a-h][1-8])+$"
2 - CONVERT GAME RECORD INTO LIST OF COORDINATES
    - regex replace a-h w. numbers 1-8
    - split "a2b5d9" into pieces [(a,2), (b,5), (d,9)]
    - assert each coordinate references a place on the board
3 - SET UP THE GAME BOARD
    - Place pieces in center 4 spots
4 - PUT PIECES ON THE BOARD IN ORDER
    - check is a valid move i.e. surrounded by at least one piece
    - check is flanking other pieces.
    - 
5 - RETURN THE FINAL GRID

=#
end