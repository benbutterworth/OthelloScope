export record2coords
export GameRecord

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
        try
            gamerecordformat = game_record_format(boardtype)
        catch e
            ArgumentError("gametype is not recognised")
        end
        if !occursin(gamerecordformat, moves)
            ArgumentError("`moves` not in recognised format")
        end
        new(moves, boardtype, players)
    end
end

moves(gr::GameRecord) = gr.moves
gametype(gr::GameRecord) = gr.gametype
players(gr::GameRecord) = gr.players

"""
    extract_coordinates(record::GameRecord)
Extract coordinates of pieces placed in a game of Othello in a GameRecord.
"""
function extract_coordinates(record::GameRecord)
    coords = Tuple{Int,Int}[]
    moves = moves(record)
    for i in 1:2:length(moves)
        col = Int(moves[i]) - 96  #convert letter to number
        row = parse(Int64, moves[i+1])
        push!(coords, (row, col))
    end
    return coords
end