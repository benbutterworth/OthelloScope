export GameRecord, moves, gametype, players, coords

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
    function GameRecord(moves::String, boardtype::DataType, players)
        gamerecordformat = nothing
        try
            gamerecordformat = game_record_format(boardtype)
        catch e
            throw(ArgumentError("gametype is not recognised"))
        end
        if !occursin(gamerecordformat, moves)
            throw(ArgumentError("`moves` not in recognised format"))
        elseif !(typeof(players) <: Union{Tuple{String}, Vector{String}})
            throw(ArgumentError("unrecognised player format"))
        end
        new(moves, boardtype, Tuple(players))
    end
end

moves(gr::GameRecord) = gr.moves
gametype(gr::GameRecord) = gr.gametype
players(gr::GameRecord) = gr.players

"""
    coords(record::GameRecord)
Extract coordinates of pieces placed in a game of Othello in a GameRecord.
"""
function coords(record::GameRecord)
    coordinates = Tuple{Int,Int}[]
    mvs = moves(record)
    for i in 1:2:length(mvs)
        col = Int(mvs[i]) - 96  #convert letter to number
        row = parse(Int64, mvs[i+1])
        push!(coordinates, (row, col))
    end
    return coordinates
end

Base.length(record::GameRecord) = length(moves(record))÷2

function Base.getindex(record::GameRecord, i::Int)
    return coords(record)[i]    
end
function Base.setindex(value::Tuple{Int, Int}, record::GameRecord, i::Int)
    record[i] = value
    return value
end

function Base.iterate(record::GameRecord, index=1)
	if index ≤ length(record)
	    return record[index], index+1
	else
	    return nothing
	end
end
