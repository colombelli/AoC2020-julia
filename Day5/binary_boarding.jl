#=
--- Day 5: Binary Boarding ---

You board your plane only to discover a new problem: you dropped your boarding pass! You aren't sure which seat is yours, and all of the flight attendants are busy with the flood of people that suddenly made it through passport control.

You write a quick program to use your phone's camera to scan all of the nearby boarding passes (your puzzle input); perhaps you can find your seat through process of elimination.

Instead of zones or groups, this airline uses binary space partitioning to seat people. A seat might be specified like FBFBBFFRLR, where F means "front", B means "back", L means "left", and R means "right".

The first 7 characters will either be F or B; these specify exactly one of the 128 rows on the plane (numbered 0 through 127). Each letter tells you which half of a region the given seat is in. Start with the whole list of rows; the first letter indicates whether the seat is in the front (0 through 63) or the back (64 through 127). The next letter indicates which half of that region the seat is in, and so on until you're left with exactly one row.

For example, consider just the first seven characters of FBFBBFFRLR:

    Start by considering the whole range, rows 0 through 127.
    F means to take the lower half, keeping rows 0 through 63.
    B means to take the upper half, keeping rows 32 through 63.
    F means to take the lower half, keeping rows 32 through 47.
    B means to take the upper half, keeping rows 40 through 47.
    B keeps rows 44 through 47.
    F keeps rows 44 through 45.
    The final F keeps the lower of the two, row 44.

The last three characters will be either L or R; these specify exactly one of the 8 columns of seats on the plane (numbered 0 through 7). The same process as above proceeds again, this time with only three steps. L means to keep the lower half, while R means to keep the upper half.

For example, consider just the last 3 characters of FBFBBFFRLR:

    Start by considering the whole range, columns 0 through 7.
    R means to take the upper half, keeping columns 4 through 7.
    L means to take the lower half, keeping columns 4 through 5.
    The final R keeps the upper of the two, column 5.

So, decoding FBFBBFFRLR reveals that it is the seat at row 44, column 5.

Every seat also has a unique seat ID: multiply the row by 8, then add the column. In this example, the seat has ID 44 * 8 + 5 = 357.

Here are some other boarding passes:

    BFFFBBFRRR: row 70, column 7, seat ID 567.
    FFFBBBFRRR: row 14, column 7, seat ID 119.
    BBFFBBFRLL: row 102, column 4, seat ID 820.

As a sanity check, look through your list of boarding passes. What is the highest seat ID on a boarding pass?
=#


function read_input()::Array{String}

    input::Array{String} = []
    open("./input", "r") do f
        while ! eof(f)
            s::String = readline(f)
            push!(input,s)
        end
    end

    return input
end
seats = read_input()


function get_row(seat_row::String)::Int32
    range = 0:127
    for char in seat_row
        div_range = div(length(range),2)
        if char == 'F'
            range=range[1:div_range]
        else
            range=range[div_range+1:end]
        end
    end
    return range[1]
end


function get_column(seat_col::String)::Int32
    range = 0:7
    for char in seat_col
        div_range = div(length(range),2)
        if char == 'L'
            range=range[1:div_range]
        else
            range=range[div_range+1:end]
        end
    end
    return range[1]
end


function get_seat_id(seat::String)::Int32
    row = get_row(seat[1:7])
    column = get_column(seat[8:end])
    return row*8+column
end

function get_highest_id(seats::Array{String})::Int32

    highest = 0
    for seat in seats
        id = get_seat_id(seat)
        if id > highest
            highest = id end
    end
    return highest
end

highest = get_highest_id(seats)
println("Highest seat id found: ", highest)



#=
--- Part Two ---

Ding! The "fasten seat belt" signs have turned on. Time to find your seat.

It's a completely full flight, so your seat should be the only missing boarding pass in your list. However, there's a catch: some of the seats at the very front and back of the plane don't exist on this aircraft, so they'll be missing from your list as well.

Your seat wasn't at the very front or back, though; the seats with IDs +1 and -1 from yours will be in your list.

What is the ID of your seat?
=#



function build_integer_array(seats::Array{String})::Array{Int}

    seats_int::Array{Int} = []
    for seat in seats
        seat = replace(seat, "F"=>"0")
        seat = replace(seat, "B"=>"1")
        seat = replace(seat, "L"=>"0")
        seat = replace(seat, "R"=>"1")

        push!(seats_int, parse(Int,seat,base=2))
    end
    return sort(seats_int)
end



function find_remaining_seat(sorted_int_seats::Array{Int})::Int32

    following_seat::Int = sorted_int_seats[1]
    for seat in sorted_int_seats[2:end]
        following_seat += 1
        if following_seat != seat
            return following_seat
        end
    end
    return 0
end


sorted = build_integer_array(seats)
remaining_seat = find_remaining_seat(sorted)

bit_seat = bitstring(UInt16(remaining_seat))[end-9:end]
bit_seat_row = bit_seat[1:7]
bit_seat_col = bit_seat[8:end]

seat_row = replace(bit_seat_row, "0"=>"F")
seat_row = replace(seat_row, "1"=>"B")
seat_col = replace(bit_seat_col, "0"=>"L")
seat_col = replace(seat_col, "1"=>"R")

row = get_row(seat_row)
col = get_column(seat_col)

println("Your seat ID: ", row*8+col)


#LOL I just realized now that the Seat ID is the integer value for the binary seat 