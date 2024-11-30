export Board
import Base: show

abstract type AbstractBoard end

"""
Bounded Board <: AbstractBoard

An Othello board with rigid play boundaries which moves do not wrap around.
"""
abstract type BoundedBoard <: AbstractBoard end

"""
SquareBoard <: BoundedBoard

Square playing boards for Othello.
"""
abstract type SquareBoard <: BoundedBoard end

"""
IrregularBoard <: BoundedBoard

Non-square playing boards for Othello that may contain holes.
"""
abstract type IrregularBoard <: BoundedBoard end

"""
LatticeBoard <: BoundedBoard

Othello boards with non-cartestian indexing systems
"""
abstract type LatticeBoard <: BoundedBoard end

"""
TopologicalBoard <: AbstractBoard

Othello boards without rigid boundaries that lets play happen on arbitrarily connected 3D Surfaces (e.g. surface of a cube, surface of a cylinder, torous.) 
"""
abstract type TopologicalBoard <: AbstractBoard end

"""
DimensionalBoard <: AbstractBoard

Othello boards in more than 2 dimensions.
"""
abstract type DimensionalBoard <: AbstractBoard end

"""
    ClassicBoard
Your bog-standard, run-of-the-mill Othello Board. We're talking 2 dimensional, 
8x8 grid with cardinal direction flanking for 2 players.
"""
mutable struct ClassicBoard <: SquareBoard
    state::Matrix{Int8}
end

function Base.getindex(board::AbstractBoard, i::Int, j::Int)
    return state(board)[i,j]    
end
function Base.getindex(value, board::AbstractBoard, i::Int, j::Int)
    state(board)[i,j] = value
    return value
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

function show(io::IO, board::ClassicBoard)
    print_board(io, board.state)
end