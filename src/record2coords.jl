export record2coords

const gamerecordformat::Regex = r"^([a-h][1-8])+$"

"""
    record2coords(gamerecord)
Convert a record of moves in an Othello game to a Vector of matrix coordinates.

## Example
```julia
julia> gamerecord = "d3c5e6f3d6"

julia> record2coords(gamerecord)
6-element Vector{Tuple{Int64, Int64}}:
 (3, 4)
 (5, 3)
 (6, 5)
 (3, 6)
 (6, 4)
 (6, 3)
```
"""
function record2coords(gamerecord)
    @assert gamerecord isa String
    @assert occursin(gamerecordformat, gamerecord)

    coordinates = Tuple{Int64,Int64}[]

    for i in 1:2:length(gamerecord)
        boardpos = gamerecord[i:i+1]

        col = Int(boardpos[1]) - 96
        row = parse(Int64, boardpos[2])

        push!(coordinates, (row, col))
    end

    return coordinates
end