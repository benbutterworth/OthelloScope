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
function Base.setindex(value, board::BoundedBoard, i::Int, j::Int)
    board[i,j] = value
    return value
end