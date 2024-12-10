"""
    ClassicBoard
Your bog-standard, run-of-the-mill Othello Board. We're talking 2 dimensional, 
8x8 grid with cardinal direction flanking for 2 players.
"""
mutable struct ClassicBoard <: SquareBoard
    state::Matrix{Int8}
end

size(::ClassicBoard) = (8,8)
state(board::ClassicBoard) = board.state
flankingDirections(::ClassicBoard) = Dict(
    :N=> (-1,0),
    :NE => (-1,1),
    :E => (0,1),
    :SE => (1,1),
    :S => (1,0),
    :SW => (1,-1),
    :W => (0,-1),
    :NW => (-1,-1)
)
game_record_format(::ClassicBoard) = r"^([a-h][1-8])+$"

function ClassicBoard()
    # initialise starting board w/o played moves.    
    state = zeros(Int8, 8, 8)
    for white in ((4,4), (5,5))
        state[white...] = -1
    end
    for black in ((4,5), (5,4))
        state[black...] = 1
    end
   return ClassicBoard(state)
end

function ClassicBoard(boardstate::Matrix)
    # Initialise board from a matrix of piece positions
    if size(boardstate) != (8,8)
        throw(ArgumentError("Wrong size: given state is incompatible with ClassicBoard"))
    elseif !all(piece -> piece ∈ -1:1, board)
        throw(ArgumentError("Piece identifiers not recognised"))
    end
    return ClassicBoard(boardstate)
end

function ClassicBoard(gamerecord::GameRecord)
    # Initialise board from a game record of its moves.
    return Missing
end

function Base.show(io::IO, board::ClassicBoard)
    print_board(io, board.state)
end