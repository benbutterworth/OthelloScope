using CSV
using DataFrames

function get_transcript(path::String)
    io = open(path, "r")
    output = read(io, String)
    output
end

function separate_games(transcript::String)
	games = split(transcript, "\r\n\r\n")
	_ = pop!(games) #rm empty ""
	output = convert.(String, games)
	output
end

function parse_move_data(moveTranscript::Vector{String})
    pgnmoves = join(moveTranscript, " ")
    regexTurnNote = r"\d*\d\."
    moves = split(pgnmoves, regexTurnNote) |> join
	output = convert.(String,
	     replace(moves, " "=>"")
    )
    output
end

function strip_letters(property::String)
	strip(property, ['"', '[', ']'])
end

function parse_metadata(metaData::Vector{String})
    map(metaData) do property
        tmp = split(strip_letters(property))
        out = join(tmp[2:end]) |> String
        strip_letters(out) 
    end
end

function parse_game_data(gameTranscript::String)
    gameData = convert.(String,
        split(gameTranscript, "\r\n")
    )
    _ = pop!(gameData) # rm empty ""
	gameScore = pop!(gameData) # rm repeat score
	gameMetaData = parse_metadata(
	    first(gameData, 6)
	)
	gameMoveData = parse_move_data(
	    gameData[7:end]
	)
    (gameMetaData..., gameMoveData)
end

df = DataFrame(
    event=String[],
    date=String[],
    round=String[],
    black=String[],
    white=String[],
    result=String[],
    moves=String[]
)

for year in 2006:2024
    path = "./data/transcripts/liveothello$(year)"
    println("Fetching transcript for $(year)...")

    transcript = get_transcript(path*".pgn")

    games = separate_games(transcript)
    games = map(games) do game
        parse_game_data(game)
    end

    println("Adding data to .csv...")
    push!(df, games...)

    #export csv
    CSV.write(path*".csv", df)
    println("Successfully made $(path*".csv")")
end
