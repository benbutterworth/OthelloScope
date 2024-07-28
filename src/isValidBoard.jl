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

    isInRange(n) = 0 ≤ n ≤ 2

    if !(all(isInRange, board))
        return false
    end

    return true
end