export ClassicBoard, state

"""
    ClassicBoard
Your bog-standard, run-of-the-mill Othello Board. We're talking 2 dimensional, 
8x8 grid with cardinal direction flanking for 2 players.
"""
mutable struct ClassicBoard <: SquareBoard
    state::Matrix{Int8}
    function ClassicBoard(boardstate::Matrix)
        if size(boardstate) != (8,8)
            throw(ArgumentError("boardstate is not the correct size (8,8) for ClassicBoard"))
        elseif eltype(boardstate) != Int8
            try
            	map(x->convert(Int8, x), boardstate)
            catch e
                throw(ArgumentError("cannot convert boardstate elements to Int8"))
            end
            boardstate = map(x->convert(Int8, x), boardstate)
        elseif !all(piece -> piece ∈ -1:1, boardstate)
            throw(ArgumentError("boardstate does not contain recognised piece identifiers"))
        end
        return new(boardstate)
    end
end

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

state(board::ClassicBoard) = board.state
game_record_format(::Type{ClassicBoard}) = r"^([a-h][1-8])+$"

Base.size(::ClassicBoard) = (8,8)
Base.length(::ClassicBoard) = 64

function Base.show(io::IO, board::ClassicBoard)
    newstate = map(state(board)) do piece
        if piece == 0
            "-"
        elseif piece ==1
            "O"
        elseif piece == -1
            "X"
        end
    end 
    println(io, " ", join(collect(1:8)))
    for row in 1:8
        print(io, row)
        for col in 1:8
            print(io, newstate[row,col])
        end
        if row<8
            println(io)
        end
    end 
end
