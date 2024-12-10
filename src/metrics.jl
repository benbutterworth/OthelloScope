"""
    parity(grid::Matrix)

Return the proportion of total (black, white) pieces on a gameboard.
"""
function parity(grid::Matrix)
    totalPieces = sum(x->x!=0, grid)
    totalBlack = sum(x->x==1, grid)
    blackParity = totalBlack/totalPieces
    return blackParity, 1-blackParity
end

"""
    edgeDominance(grid::Matrix)

Return the proportion of edge and corner pieces controlled by (black/white).
"""
function edgeDominance(grid::Matrix)
    @assert size(grid) == (8,8)
    edgeCoords = vcat(
        [(1,i) for i ∈ 1:8], # top
        [(i, 1) for i ∈ 2:8], # left
        [(i, 8) for i ∈ 2:8], # right
        [(8, i) for i ∈ 2:7] # bottom
    )    
    edgePieces = [grid[coord...] for coord in edgeCoords]
    totalPieces = sum(x->x!=0, edgePieces)
    if totalPieces == 0
        return 0,0
    else
        totalBlack = sum(x->x==-1, edgePieces)
        blackParity = totalBlack/totalPieces
        return blackParity, 1-blackParity
    end
end

"""
    centrality(grid::Matrix)

Measure of how much control over the center area of played pieces (black/white) has. 
"""
function centrality(grid::Matrix)
   return (0,0) 
end

function get_slice_range(a::Int, b::Int; rows::Int=8, cols::Int=8)
    # Get a slice of all the surrounding pieces of a certain point
    rowRange = max(1, a-1):min(rows, a+1)
    colRange = max(1, b-1):min(cols, b+1)
    return rowRange, colRange
end

"""
    penetration(grid::matrix)

Return the proportion of each colour's pieces are surrounded by majory opponent's pieces (not including empty space).
"""
function penetration(grid::Matrix)
    boardstate= get_piece_coordinates(grid)
    output = Float64[]
    # do this metric for both black and white
    for colour in [:black, :white]
        pieceLocations = boardstate[colour]
        nPieces = length(pieceLocations)
        nSurrounded = 0
        for coord in pieceLocations
            slice = grid[get_slice_range(coord...)...]                
            parity = sum(slice) - ifelse(colour==:black, 1, -1)
            if parity<0 && colour==:black
                nSurrounded += 1
            elseif parity>0 && colour==:white    
                nSurrounded += 1
            end
        end
        push!(output, nSurrounded/nPieces)
    end
    return output
end

"""
    get_piece_coordinates(grid::Matrix)

Return a dictionary of the indices of black, white and empty pieces.
"""
function get_piece_coordinates(grid::Matrix)
    isEmpty(value) = value == 0
    isWhite(value) = value == -1
    isBlack(value) = value == 1
    
    coordinates = Dict(
        :empty => Tuple{Int, Int}[],
        :black => Tuple{Int, Int}[],
        :white => Tuple{Int, Int}[]
    )
    
    for boardPosition ∈ CartesianIndices(grid)
        piece = grid[boardPosition]
        if isEmpty(piece)
            sym = :empty
        elseif isBlack(piece)
            sym = :black
        elseif isWhite(piece)
            sym = :white
        else
            @error "Invalid piece symbol" 
        end
        push!(coordinates[sym], Tuple(boardPosition))
    end

    return coordinates
end