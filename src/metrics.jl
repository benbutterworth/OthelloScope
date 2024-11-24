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

"""
    surroundedness(grid::matrix)

Return the proportion of each colour's pieces are surrounded by majory opponent's pieces (not including empty space).
"""
function surroundedness(grid::Matrix)
    pieceCoords= get_piece_coordinates(grid)
    isEdge(coord) = @. coord==1 || coord==8
    
    # do this metric for both black and white
    for colour in [:black, :white]
        colourCoords = pieceCoords[colour]
        totalColour = length(colourCoords)
        totalSurroundedBlack = 0
        totalSurroundedWhite = 0
        for coord in colourCoords
            if !isEdge(coord)
                slice = grid[
                    coord[1]-1:coord[1]+1,
                    coord[2]-1:coord[2]+1
                ]
                slice[2,2] = 0
                
                parity = sum(slice)
                
                if parity == 0
                    continue 
                elseif parity > 0
                    totalSurroundedBlack += 1
                elseif parity < 0
                    totalSurroundedWhite += 1
                end

                # now we need some big boy calculation

            else
                @info "You need to code for edge conditions!"
            end
        end
    end
    
   # find position of each black piece
   
   # slice the neighbourhood around them
   # perform sum to find majority surrounded
   # add to black posession or white posession 
   # weigh posession about
   # do same for white 
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