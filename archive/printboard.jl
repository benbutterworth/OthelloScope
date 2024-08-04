function int2piece(number::Integer)
    if number == 0
        return ' '
    elseif number == 1
        return '⚪'
    elseif number == -1
        return '⚫'
    else
        return Nothing
    end
end

"""
    printboard(board)
Print an Othello board to the terminal using Unicode emojis.

## Example
```julia
julia> board = setupboard(); 

julia> printboard(board)



    ⚪⚫
    ⚫⚪



```
"""
function printboard(board)
    @assert isValidBoard(board)

    for row in 1:8
        for col in 1:8
            print(int2piece(board[row, col]))
        end
        print('\n')
    end
    nothing
end