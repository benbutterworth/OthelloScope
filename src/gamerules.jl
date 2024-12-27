# 1. Check that the position is unoccupied, position is in bounds
# 2. Check occupying this position is a legal move
# 3. Identify which pieces are flipped by this move
# 4. Return altered board state after the move
    
"""
    vecdiv(space::Tuple{Int, Int}, increment::Tuple{Int, Int})
Pseudo-division by a vector. How many `increment` can you add together before
a component of the sum is larger than a component of `space`. 
"""
function vecdiv(space::Tuple{Int, Int}, increment::Tuple{Int, Int})
    @assert increment != (0,0)
    if increment[1] == 0 
        return space[2] ÷ increment[2] 
    elseif increment[2] == 0
        return space[1] ÷ increment[1] 
    end
    return minimum(space .÷ increment)
end

"""
   get_flanking_targets(board::BoundedBoard, pos::Tuple{Int,Int})

"""
function get_flanking_targets(board::BoundedBoard, pos::Tuple{Int,Int})
   possibleFlankingPositions = Dict{Symbol, Vector{Tuple{Int, Int}} }()
   (n,m) = size(board)
   # find all possible positions that must be checked for flanking pieces
   for (direction, increment) in flanking_directions(board)
      if any(i->i<0, increment) 
         t = (n,m) .÷ (ifelse(increment[1]>0, 1, n), ifelse(increment[2]>0, 1, m)) 
         nMoves = t .- pos 
      else
         nMoves = (n,m) .- pos 
      end
      # №  moves before hitting board boundary. If 0, move onto next direction
      nIncrements = vecdiv(nMoves, increment)
      if nIncrements ≤ 1
         continue 
      end
      # collect all positions before hit boundary
      positionsInRange = Tuple{Int, Int}[]
      for i in 1:nIncrements
         newpos = pos .+ (i .* increment)
         # ensure not a boundary or hole ##FUTURE##
         if board[newpos...] == 8
            continue
         end
         push!(positionsInRange, newpos)
      end
      # add all pieces in range to possibleFlankingPositions
      possibleFlankingPositions[direction] = positionsInRange
   end
   return possibleFlankingPositions
end

function flip_pieces!(board::AbstractBoard, position::Tuple{Int, Int})
   board[position...] *= -1
end

function flip_pieces!(board::AbstractBoard, positions::Vector{Tuple{Int, Int}})
   for pos in positions
      flip_pieces!(board, pos)
   end
end

function flip_pieces!(board::AbstractBoard, positions::CartesianIndices)
   for pos in positions
      flip_pieces!(board, Tuple(pos))
   end
end

function identify_flipped_pieces(board::AbstractBoard, position::Tuple{Int, Int}, colour::Int)
   othercolour = -1*colour
   flankingTargets = get_flanking_targets(board, position)
   flippedPieces = Tuple{Int, Int}[]
   for (direction, positions) in flankingTargets
      # ensure at least one piece can be flanked, otherwise move onto next direction
      if board[first(positions)...] == colour
         continue
      end
      # ensure piece can be flanked
      pieces = [board[c...] for c in positions]
      if all(piece->piece!=colour, pieces)
          continue
      end
      # make a list of coordinates that need to be flipped.
      flankedPieces = Tuple{Int, Int}[]
      for (i,piece) in enumerate(pieces)
         if piece == othercolour
            push!(flankedPieces, positions[i])
         elseif piece == 0 # can't flank through empty board
            break
         elseif piece == 8 # can't flank through blocking spaces
            break
         elseif piece == colour
            push!(flippedPieces, flankedPieces...)
            break #stop looking further
         end
      end
   end
   return flippedPieces
end

# this function is gonna be so damn inefficient but fuck it, it'll work
function find_legal_moves(board::AbstractBoard, colour::Int)
   legal_moves = Tuple{Int, Int}[]
   for pos in CartesianIndices(board)
      tpos = Tuple(pos)
      if board[tpos...] != 0
         continue
      end
      flippedPieces = identify_flipped_pieces(board, tpos, colour)
      if length(flippedPieces)!=0
         push!(legal_moves, tpos)
      end
   end
   legal_moves
end

function play!(board::AbstractBoard, position::Tuple{Int, Int}, colour::Int)
   # check it's a legal move
   if !(position ∈ find_legal_moves(board, colour))
      @error "Piece cannot be played at $position as it is an illegal move."
   end
   # find what flanks it
   board[position...] = colour
   flip_pieces!(board, identify_flipped_pieces(board, position, colour))
   board
end

function play(gamerecord::GameRecord)
   board = ClassicBoard()
   colour = 1 #starts black
   for move in coords(gamerecord)
      if length(identify_flipped_pieces(board, move, colour)) == 0
         colour *= -1
      end
      play!(board, move, colour)
      colour *= -1
   end
   board
end
