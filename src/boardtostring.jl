const lcol = "| "
const col = " | "
const rcol = " |"
const newln = "\n"

"""
    print_table_top(colwidths::Vector{Int8})
Print the top line of a table with collumn widths `colwidths`.
"""
function print_table_top(io::IO, colwidths::Vector{Int8})
    nlines = length(colwidths) - 1
    print(io::IO, '┌')
    for i in 1:nlines
        print(io::IO, '─'^(colwidths[i] + 2))
        print(io::IO, '┬')
    end
    print(io::IO, '─'^(colwidths[end]+2))
    print(io::IO, '┐', newln)
end

"""
    print_table_divider(colwidths::Vector{Int8})
Print a divider line of a table with collumn widths `colwidths`.
"""
function print_table_divider(io::IO, colwidths::Vector{Int8})
    # tuple contains integers that repr. length of each column
    nlines = length(colwidths) - 1
    print(io::IO, '├')
    for i in 1:nlines
        print(io::IO, '─'^(colwidths[i] + 2))
        print(io::IO, '┼')
    end
    print(io::IO, '─'^(colwidths[end]+2))
    print(io::IO, '┤', newln)
end

"""
    print_row_contents(colwidths::Vector{Int8}, textarray)
Print the contents of an array `textarray` using `colwidths` to detemine spacing.
"""
function print_row_contents(io::IO, colwidths::Vector{Int8}, textarray)

    if length(colwidths) != length(textarray)
        @error "length of table does not match length of textarray."
    end

    nlines = length(colwidths) - 1

    print(io::IO, lcol)
    for i in 1:nlines
        print(io::IO, rpad(textarray[i], colwidths[i]), col)
    end
    print(io::IO, rpad(textarray[end], colwidths[end]))
    print(io::IO, rcol, newln)
end

"""
    print_table_bottom(colwidths::Vector{Int8})
Print the bottom line of a table with collumn widths `colwidths`.
"""
function print_table_bottom(io::IO, colwidths::Vector{Int8})
    nlines = length(colwidths) - 1
    print(io::IO, '└')
    for i in 1:nlines
        print(io::IO, '─'^(colwidths[i] + 2))
        print(io::IO, '┴')
    end
    print(io::IO, '─'^(colwidths[end]+2))
    print(io::IO, '┘', newln)
end

"""
    get_collumn_widths(array) -> Vector{Int8}
Return a list containing the width required to display the contents of an array. 
"""
function get_collumn_widths(array)
    # @assert array isa Array{T,2} where {T<:Union{Char, String}}

    maxwidth(stringlist) = maximum(map(length, stringlist))

    ncols = length(array[1]) # ? size(array)?
    colwidths::Vector{Int8} = zeros(ncols)

    for i in 1:ncols
        # define accessor function for this
        getcol(a) = a[i]
        col = map(getcol, array) # to isolate column
        col = map(string, map(getcol, array))
        colwidths[i] = maxwidth(col) # find max wdith within a column
    end

    return colwidths
end

"""
    print_ascii_table(mat::Matrix)
Print the contents of a matrix in a pretty ascii table to `stdout`.
"""
function print_ascii_table(io::IO, mat::Matrix)
    nrows, _ = size(mat)
    array = [Tuple(mat[i,:]) for i in 1:nrows]

    collumnwidths = get_collumn_widths(array)
    nrows = length(array)

    print_table_top(io, collumnwidths)

    for i in 1:(nrows-1)
        print_row_contents(io, collumnwidths, array[i])
        print_table_divider(io, collumnwidths)
    end

    print_row_contents(io, collumnwidths, array[end])
    print_table_bottom(io, collumnwidths)
end