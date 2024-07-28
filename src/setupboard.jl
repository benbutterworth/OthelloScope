"""
    setupboard()

"""
function setupboard()
    board::Matrix{Int8} = zeros(8, 8)
    board[4:5, 4:5] = [1 2; 2 1]
    board
end
