export record2coords

gameRecordFormats = Dict{DataType, Regex}(
    ClassicBoard => r"^([a-h][1-8])+$"
)

"""
    GameRecord(moves, boardtype, players)
A game record describing the sequence of moves made in a game of Othello. 

    moves::String
        Move coordinates in standard Othello notation a1b2c3...

    boardtype::DataType
        What type of Othello game was played

    players::Vector{String}
        The names of the players in turn order
"""
struct GameRecord 
    moves::String
    gametype::DataType
    players::Tuple{String, String}
    function GameRecord(moves::String, boardtype::DataType, players::Vector{String})
        if !(boardtype isa Union{[T for T ∈ keys(gameRecordFormats)]...})
            ArgumentError("gametype is not recognised")
        end
        gamerecordformat = gameRecordFormats[boardtype]
        if !occursin(gamerecordformat, moves)
            ArgumentError("`moves` not in recognised format")
        end
        new(moves, players)
    end
end

"""
    extract_coordinates(record::GameRecord)
Extract coordinates of pieces placed in a game of Othello in a GameRecord.
"""
function extract_coordinates(record::GameRecord)
    coords = Tuple{Int,Int}[]
    stringrecord = record.moves
    for i in 1:2:length(stringrecord)
        col = Int(stringrecord[i]) - 96  #convert letter to number
        row = parse(Int64, stringrecord[i+1])
        push!(coords, (row, col))
    end
    return coords
end