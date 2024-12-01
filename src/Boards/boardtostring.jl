"""
    print_board(io::IO, board::Matrix)
"""
function print_board(io::IO, board::Matrix)
    newstate = map(board) do piece
        if piece == 0
            "-"
        elseif piece ==1
            "O"
        elseif piece == -1
            "X"
        end
    end 
    cols, rows = size(newstate)
    println(io, " ", join(collect(1:cols)))
    for row in 1:rows
        print(io, row)
        for col in 1:cols
            print(io, newstate[row,col])
        end
        println(io)
    end 
end