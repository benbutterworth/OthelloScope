using Test
using OthelloScope

const examplerecord = "d3c5e6f3d6c6e3f5f4f7f6g5c4e2g3c2c3d2g4h3f2b5b4b3c1h4e7f1a4b6h6h5h2d1g6a3a5a6c7c8e8d7e1g8d8b1b8g7h7h8a7h1a2f8b2a8b7a1g2g1"

@testset "isValidBoard" begin
    obj1 = ""
    obj2 = fill(' ', 8, 8)
    obj3 = fill(0, 8, 8)
    obj4::Matrix{Int8} = fill(3, 8, 9)
    obj4::Matrix{Int8} = rand(0:2, 8, 8)

    @test !isValidBoard(obj1) # Not Matrix
    @test !isValidBoard(obj2) # Not parametric Matrix{Int8}
    @test !isValidBoard(obj3) # Not parametric Matrix{Int8}
    @test !isValidBoard(obj4) # Not (8, 8)
    @test isValidBoard(obj5)  # ✓
end

@testset "record2coords" begin
    obj1 = 0
    obj2 = "d3 c5 e6"
    obj3 = "d3ce6"
    obj4 = "d9c5e6"
    obj5 = "d3 c5 e6"

    @test_throws AssertionError record2coords(obj1)
    @test_throws AssertionError record2coords(obj2)
    @test_throws AssertionError record2coords(obj3)
    @test_throws AssertionError record2coords(obj4)
    @test record2coords(obj5) == [(3, 4), (5, 3), (6, 5)]
end

