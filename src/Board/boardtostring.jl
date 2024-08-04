const lcol = "| "
const col = " | "
const rcol = " |"
const newln = "\n"


"""
    row_divider(colwidths, position::String)

"""
function row_divider(colwidths, position::String)
    @assert colwidths isa Union{Tuple, Vector}
    @assert eltype(colwidths) <: Integer

    # Determine appropriate characters for row
    if position == "top"
        leftedgechar = '┌'
        divchar = '┬'
        rightedgechar = '┐'
    elseif position == "middle"
        leftedgechar = '├'
        divchar = '┼'
        rightedgechar = '┤'
    elseif position == "bottom"
        leftedgechar = '└'
        divchar = '┴'
        rightedgechar = '┘'
    else
        @error "`position` not valid, must be either `top`, `middle` or `bottom`."
    end

    output::String = ""
    nlines = length(colwidths) - 1    

    output *= leftedgechar

    for i in 1:nlines
        colwidth = colwidths[i] + 2
        output *= ('─'^colwidth) * divchar
    end

    endcolwidth = colwidths[end]+2
    output *= ('─'^endcolwidth) * rightedgechar 
    output *= newln
end


"""
    row_contents(colwidths, textarray)

"""
function row_contents(colwidths, textarray)
    @assert colwidths isa Union{Tuple, Vector}
    @assert eltype(colwidths) <: Integer
    @assert textarray isa Vector{String}
    @assert length(colwidths) == length(textarray)

    nlines = length(colwidths) - 1
    output::String = ""
    output *= lcol

    for i in 1:nlines
        output *= rpad(textarray[i], colwidths[i]) * col
    end

    output *= rpad(textarray[end], colwidths[end])
    output *= rcol * newln
end

"""
    get_collumn_widths(tablecontents)
"""
function get_collumn_widths(tablecontents)
    @assert tablecontents isa Matrix #can't print 3d tables

    nrows, ncols = size(tablecontents)
    colwidths::Vector{Int64} = zeros(ncols)

    stringtablecontents = map(string, tablecontents)    

    maxwidth(stringlist) = maximum(map(length, stringlist))

    for col in 1:ncols
        colwidth = maxwidth(stringtablecontents[:,col])
        colwidths[col] = colwidth
    end

    colwidths
end

"""
    generate_table(tableinput::Matrix)
"""
function generate_table(tableinput::Matrix)
    stringtableinput = map(string, tableinput)
    colwidths = get_collumn_widths(stringtableinput)

    tableoutput::String = ""
    tableoutput *= row_divider(colwidths, "top")

    nrows, _ = size(tableinput)
    for row in 1:(nrows - 1)
        tableoutput *= row_contents(colwidths, stringtableinput[row,:])
        tableoutput *= row_divider(colwidths, "middle")
    end
    tableoutput *= row_contents(colwidths, stringtableinput[end, :])
    tableoutput *= row_divider(colwidths, "bottom")

    tableoutput
end
