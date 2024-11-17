export Board

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
    Board <: BoundedBoard
Struct representing the state of an Othello board.
"""
struct Board <: BoundedBoard
    state::Matrix{Int8} # 1 = Black, 0 = empty, -1 = White
    pieces::Tuple{Char,Char,Char} #character repr. of Black, White, Empty.
end

function setupboard()
    board::Matrix{Int8} = zeros(8, 8)
    board[4:5, 4:5] = [-1 1; 1 -1]
    board
end

"""
    isValidBoard(board)
Return `true` only if `board` can be interpreted as an Othello board.
"""
function isValidBoard(board)
    if !(board isa Matrix{Int8})
        return false
    end

    if size(board) != (8, 8)
        return false
    end

    isInRange(n) = -1 ≤ n ≤ 2

    if !(all(isInRange, board))
        return false
    end

    return true
end

function Board(pieces=('⚫', '⚪', ' '))
    emptyboard = setupboard()
    Board(emptyboard, pieces)
end

function Board(board::Matrix{Int8}, pieces=('⚫', '⚪', ' '))
    if !isValidBoard(board)
        @error "Not a board."
    end

    Board(board, pieces)
end

import Base: show
function show(io::IO, board::Board)
    boardaschars = map(board) do piece
        if piece == 0
            return board.pieces[3]
        elseif piece == 1
            return board.pieces[1]
        elseif piece == -1
            return board.pieces[2]
        else
            return Nothing
        end
    end
    if any(isnothing, boardaschars)
        @error "not a valid piece!"
    end
    output = OthelloScope.generate_table(boardaschars)
    print(io, output)
end