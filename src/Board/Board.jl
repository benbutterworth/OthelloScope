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

# flanking directions & increments for most boards
const classicFlankingDirections = Dict(
    :N=> (-1,0),
    :NE => (-1,1),
    :E => (0,1),
    :SE => (1,1),
    :S => (1,0),
    :SW => (1,-1),
    :W => (0,-1),
    :NW => (-1,-1)
)

mutable struct ClassicBoard <: SquareBoard
    state::Matrix{Int8}
    flankingDirections::Dict{Symbol, Tuple{Int8, Int8}}
    # players::Tuple{Symbol, Symbol} # names & order of players? or should this be in gamerecord?
end

"""
    ClassicBoard

Your bog-standard, run-of-the-mill Othello Board. We're talking 2 dimensional, 
8x8 grid with cardinal direction flanking for 2 players.
"""
function ClassicBoard end

function ClassicBoard()
    # starting board, no moves.    
    state = zeros(Int8, 8, 8)
    for white in ((4,4), (5,5))
        state[white...] = -1
    end
    for black in ((4,5), (5,4))
        state[black...] = 1
    end
   return ClassicBoard(state, classicFlankingDirections)
end

function ClassicBoard(boardstate::Matrix)
    if size(boardstate) != (8,8)
        throw(ArgumentError("Wrong size: given state is incompatible with ClassicBoard"))
    elseif !all(piece -> piece ∈ -1:1, board)
        throw(ArgumentError("Piece identifiers not recognised"))
    end
    return ClassicBoard(boardstate, classicFlankingDirections)
end

function ClassicBoard(gamerecord)
    # start board in state
    return Missing
end

function show(io::IO, board::ClassicBoard)
    print_board(io, board.state)
end