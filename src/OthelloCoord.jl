export OthelloCoord
export othello_coord_to_matrix_index, matrix_index_to_othello_coord

"""
    isValidBoardReference(input) -> Bool
Return `true` if `input` can be parsed into a valid OthelloCoord, else `false`.
"""
function isValidBoardReference(input)
    if !(input isa String)
        return false
    end

    if length(input) != 2
        return false
    end

    col = first(input)
    row = last(input)

    try
        row = parse(Int, row)
    catch
        return false
    end

    if !(1 ≤ row ≤ 8)
        return false
    end

    if !(occursin(col, "abcdefgh"))
        return false
    end

    true
end

"""
    OthelloCoord()
A struct representing a position on an Othello board, using standard notation.
"""
struct OthelloCoord
    col::Char
    row::Integer

    function OthelloCoord(st::String)
        if !isValidBoardReference(st)
            msg = "Invalid OthelloCoord: must take form \"cI\" w. c∈'a':'h', I∈1:8 ."
            throw(ErrorException(msg))
        end
        row = parse(Int, last(st))
        col = first(st)
        new(col, row)
    end
end

"""
    matrix_index_to_othello_coord(row::Int, col::Int) -> OthelloCoord
Return the OthelloCoord of a matrix indexed `(row, col)`.
"""
function matrix_index_to_othello_coord(row::Int, col::Int)
    # convert matrix indexing to board coordinate
    isOnBoard = 1 ≤ row ≤ 8 || 1 ≤ col ≤ 8
    if !isOnBoard
        throw(BoundsError("Coordinate out of board bounds."))
    end
    coord = ('`' + col, row)
    OthelloCoord(coord...)
end

"""
    othello_coord_to_matrix_index(oc::OthelloCoord) -> Tuple{Int, Int}
Return the matrix indices of a OthelloCoord.
"""
function othello_coord_to_matrix_index(oc::OthelloCoord)
    row = oc.row
    col = Int(oc.col) - 96
    (row, col)
end

"""
    OthelloCoord(row::Int, col::Int)
Create an OthelloCoord based on matrix indices `(row, col)`.
"""
function OthelloCoord(row::Int, col::Int)
    matrix_index_to_othello_coord(row,col)
end
