#=

    Reading input

=#
function read_input()::Array{Int32}

    input::Array{Int32} = []
    open("./input", "r") do f
        while ! eof(f)
            s::String = readline(f)
            push!(input,tryparse(Int32,s))
        end
    end

    return input
end
input = read_input()



#=
Before you leave, the Elves in accounting just need you to fix your 
expense report (your puzzle input); apparently, something isn't quite adding up.
Specifically, they need you to find the two entries that sum to 2020 and then 
multiply those two numbers together.

For example, suppose your expense report contained the following:
1721
979
366
299
675
1456

In this list, the two entries that sum to 2020 are 1721 and 299. Multiplying them 
together produces 1721 * 299 = 514579, so the correct answer is 514579.

Of course, your expense report is much larger. Find the two entries that sum to 2020; 
what do you get if you multiply them together?
=#

EXPECTED_SUM = 2020

function separate_evens_from_odds(input::Array{Int32})::Tuple{Array{Int32}, Array{Int32}}

    evens::Array{Int32} = []
    odds::Array{Int32} = []
    for i in input
        if mod(i,2) == 1
            push!(odds,i)
        else
            push!(evens,i)
        end
    end
    return (evens, odds)
end




# -1: sum is smaller than the expected sum
# 0: sum is the expected sum
# 1: sum is larger than the expected sum
function check_sum(a::Int32, b::Int32)::Int8
    s::Int32 = a+b
    if s > EXPECTED_SUM
        return 1
    elseif s < EXPECTED_SUM
        return -1
    else
        println("Found solution: ", a, " and ", b)
        return 0
    end
end

# -1: result is impossible for given array
function matrix_search(array::Array{Int32})

    array_size::Int32 = size(array,1)
    if array_size < 2
        return -1
    end
    
    array_split::Int32 = div(array_size,2)
    columns_idx::UnitRange{Int32} = 1:array_split
    rows_idx::UnitRange{Int32} = array_split+1:array_size
    i::Int32 = 1
    j::Int32 = 1            

    result = check_sum(array[rows_idx[i]], array[columns_idx[j]])
    
    if result > 0
        return matrix_search(array[columns_idx])
    elseif result < 0
        return downward_flow(array,i+1,j+1,columns_idx,rows_idx)
    else
        return array[rows_idx[i]] * array[columns_idx[j]]
    end
end


# -1: result is impossible for given array
function downward_flow(array,i,j,columns_idx,rows_idx)

    while((i<=last(rows_idx)) && (j<=last(columns_idx)))
        result = check_sum(array[rows_idx[i]], array[columns_idx[j]])
        if result == 0
            return array[rows_idx[i]] * array[columns_idx[j]]
        elseif result < 0
            i+=1
            j+=1
        else
            
            # Do the search in the line
            jj = j-1
            while jj >= 1
                result = check_sum(array[rows_idx[i]], array[columns_idx[jj]])
                if result == 0
                    return array[rows_idx[i]] * array[columns_idx[jj]]
                end
                jj-=1
            end

            # Do the search in the up line
            i-=1
            jj = last(columns_idx) 
            while jj > j
                result = check_sum(array[rows_idx[i]], array[columns_idx[jj]])
                if result == 0
                    return array[rows_idx[i]] * array[columns_idx[jj]]
                end
                jj-=1
            end
            result = matrix_search(array[rows_idx])
            if result == -1
                return matrix_search(array[columns_idx]) end
        end
    end

    if j<last(columns_idx)
    # Check right up diagonal
        result = check_sum(array[rows_idx[i-1]], array[columns_idx[j+1]])
        if result == 0
            return array[rows_idx[i]] * array[columns_idx[j]] end
    # Check right
        result = check_sum(array[rows_idx[i]], array[columns_idx[j+1]])
        if result == 0
            return array[rows_idx[i]] * array[columns_idx[j]] end


    elseif i<last(rows_idx)
    # Walks horizontally through the whole last line of the matrix
        i = size(rows_idx,1)
        j = 1
        while j<=last(columns_idx)
            result = check_sum(array[rows_idx[i]], array[columns_idx[j]])
            if result < 0
                return matrix_search(array[rows_idx]) # Make the matrix search with highest values
            elseif result == 0
                return array[rows_idx[i]] * array[columns_idx[j]]
            end
            j+=1
        end
    end

    return matrix_search(array[rows_idx]) # Make the matrix search with highest values
end


evens, odds = separate_evens_from_odds(input)
result = matrix_search(sort(evens))
if result == -1
    println("\n\nSum not found in evens. Trying with odds...")
    result = matrix_search(sort(odds))
    if result == -1
        println("Impossible solution for given array!")
    end
else
    println(result)
end
