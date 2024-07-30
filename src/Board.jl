
abstract type AbstractBoard end

"""
    Board <: AbstractBoard
Struct representing the state of an Othello board.
"""
struct Board <: AbstractBoard
    state::Matrix{Int8} # 1 = Black, 0 = empty, -1 = White
    pieces::Tuple{Char,Char,Char} #character repr. of Black, White, Empty.

    function Board(board::Matrix{Int8}, pieces=('⚫', '⚪', ' '))
        if !isValidBoard(board)
            @error "Not a board."
        end

        new(board, pieces)
    end
end

function setupboard()
    board::Matrix{Int8} = zeros(8, 8)
    board[4:5, 4:5] = [-1 1; 1 -1]
    board
end

function Board()
    emptyboard = setupboard()
    Board(emptyboard)
end

using Base: show

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
    
    OthelloScope.print_ascii_table(io::IO, boardaschars)
end