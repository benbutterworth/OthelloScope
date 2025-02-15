"""
AbstractBoard

Supertype for a variety of Othello Boards.
"""
abstract type AbstractBoard end

"""
Bounded Board <: AbstractBoard

An Othello board with rigid play boundaries which moves do not wrap around.
"""
abstract type BoundedBoard <: AbstractBoard end
flanking_directions(::BoundedBoard) = Dict(
     :N=> (-1,0),
     :NE => (-1,1),
     :E => (0,1),
     :SE => (1,1),
     :S => (1,0),
     :SW => (1,-1),
     :W => (0,-1),
     :NW => (-1,-1)
)

"""
SquareBoard <: BoundedBoard

Square playing boards for Othello.
"""
abstract type SquareBoard <: BoundedBoard end
include("ClassicBoard.jl")

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

function Base.getindex(board::BoundedBoard, i::Int, j::Int)
    return state(board)[i,j]    
end
function Base.getindex(board::BoundedBoard, coord::CartesianIndex)
    return board[Tuple(coord)...]    
end
function Base.setindex!(board::BoundedBoard, value::Int, i::Int, j::Int)
    state(board)[i,j] = value
    return value
end

function Base.iterate(board::BoundedBoard, index=1)
    if index ≤ length(board)
        j = 1 + ((index-1)÷8)
        i = 1 + index - (1 + ((index-1)÷8)*8)
        return board[i, j], index+1
    else
        return nothing
    end
end

function Base.CartesianIndices(board::BoundedBoard)
	CartesianIndices(state(board))
end
