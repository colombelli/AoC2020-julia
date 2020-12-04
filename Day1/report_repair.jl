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

PART 1

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

    while(j<=last(columns_idx))
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

    if i<last(rows_idx)
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



#=

PART 2

The Elves in accounting are thankful for your help; one of them even offers you 
a starfish coin they had left over from a past vacation. They offer you a second 
one if you can find three numbers in your expense report that meet the same criteria.

Using the above example again, the three entries that sum to 2020 are 979, 366, and 
675. Multiplying them together produces the answer, 241861950.

In your expense report, what is the product of the three entries that sum to 2020?

=# 


# -1: sum is smaller than the expected sum
# 0: sum is the expected sum
# 1: sum is larger than the expected sum
function check_sum(a::Int32, b::Int32, c::Int32)::Int8
    s::Int32 = a+b+c
    if s > EXPECTED_SUM
        return 1
    elseif s < EXPECTED_SUM
        return -1
    else
        println("Found solution: ", a, " and ", b)
        return 0
    end
end


function search_sum(input)
# Dont know how to optimize significantly.. it's gonna be O(n^3)
    for i in 1:size(input,1)
        for j in 1:size(input,1)
            if j == i
                continue 
            end
            for k in 1:size(input,1)
                if k == i || k == j
                    continue 
                end
                
                result = check_sum(input[i], input[j], input[k])
                if result == 0
                    println("Success in the 3 number sum search: ", input[i], ", ", input[j], " and ", input[k])
                    return input[i] * input[j] * input[k]
                end
            end
        end
    end
    return -1
end

result = search_sum(input)
if result == -1
    println("3 digits sum not found in given array!")
else
    println("Result: ", result)
end