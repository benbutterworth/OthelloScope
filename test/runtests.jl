using Test
using OthelloScope

@testset "ValidBoardReferences" begin
    pos_coords = [i for i in "0123456789abcdefghijklmnopqrstuvwxyz"]
    allcords = []
    for row in pos_coords
        for col in pos_coords
            push!(allcords, "$row$col")
        end
    end
    valid_coords = ["$i$j" for i in 'a':'h' for j in 1:8]
    @test filter(OthelloViewer.isValidBoardReference, allcords) == valid_coords
end
