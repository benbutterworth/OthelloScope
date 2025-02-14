using DataFrames 
using CSV
using DataFrames

function get_transcript(path::String)
    io = open(path, "r")
    output = read(io, String)
    output
end

function entry_to_list(recordEntry::SubString{String})
    splitEntry = split(recordEntry, " : ")
    moves = strip(splitEntry[2])
    # split based on position of "-" to account for variable name length.
    scoreregex = r" \d*\d-\d\d* " # XX:XX  X:XX  XX:X & spaces
    players = split(splitEntry[1], scoreregex)
    p1 = players[1]
    p2 = players[2]
    String.((p1, p2, moves))
end

function parse_transcript(transcript::String)
    datalist = split(transcript, "\r")
    data = Tuple[]
    for entry in datalist
        if length(entry) < 10
            continue
        end
        push!(data, entry_to_list(entry))
    end
    data
end

println("Confirm you are in data/ folder : ")
cont = readline()
if cont != "y"
    exit()
end

# Get all transcripts
transcripts = String[]
for year in 1977:1987
    path = "./transcripts/$(year)_players.txt"
    transcript = get_transcript(path)
    push!(transcripts, transcript)
end

allgames = Tuple[]
for transcript in transcripts
    games = parse_transcript(transcript)
    push!(allgames, games...)
end

print(length(allgames))
print(all(i->length(i) ==3, allgames))


df = DataFrame(Tuple(allgames))

# Save to csv file for future use
CSV.write("./earlytranscripts.csv", df)
