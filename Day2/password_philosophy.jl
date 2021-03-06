#=

    Reading input

=#
function read_input()

    pass=[]
    policy=[]
    letter=[]
    open("./input", "r") do f
        while ! eof(f)
            s::String = readline(f)
            entry = split(s," ")
            push!(pass,entry[3])
            push!(letter,entry[2][1])

            policy_split = split(entry[1],"-")
            policy_tuple = (parse(Int32,policy_split[1]), 
                            parse(Int32,policy_split[2]))
            push!(policy,policy_tuple)
        end
    end

    return pass, policy, letter
end

input = read_input()
pass = input[1]
policy = input[2]
letter = input[3]




#=

--- Day 2: Password Philosophy ---

Your flight departs in a few days from the coastal airport; the easiest way down to 
the coast from here is via toboggan.

The shopkeeper at the North Pole Toboggan Rental Shop is having a bad day. "Something's 
wrong with our computers; we can't log in!" You ask if you can take a look.

Their password database seems to be a little corrupted: some of the passwords wouldn't 
have been allowed by the Official Toboggan Corporate Policy that was in effect when they 
were chosen.

To try to debug the problem, they have created a list (your puzzle input) of passwords 
(according to the corrupted database) and the corporate policy when that password was set.

For example, suppose you have the following list:

1-3 a: abcde
1-3 b: cdefg
2-9 c: ccccccccc

Each line gives the password policy and then the password. The password policy indicates 
the lowest and highest number of times a given letter must appear for the password to be 
valid. For example, 1-3 a means that the password must contain a at least 1 time and at 
most 3 times.

In the above example, 2 passwords are valid. The middle password, cdefg, is not; it contains 
no instances of b, but needs at least 1. The first and third passwords are valid: they contain 
one a or nine c, both within the limits of their respective policies.

How many passwords are valid according to their policies?

=#


function is_valid(policy, letter, password)
    letter_count = count(==(letter), password)
    if letter_count<policy[1]
        return false 
    elseif letter_count>policy[2]
        return false
    else
        return true
    end
end

function count_valid_passwords(policy, letter, pass)
    count_valid = 0
    for i in 1:size(pass,1)
        if is_valid(policy[i], letter[i], pass[i])
            count_valid+=1
        end
    end
    return count_valid
end

println(size(policy,1),", ",size(letter,1), ", ", size(pass,1))
println("Valid passwords found: ", count_valid_passwords(policy, letter, pass))


#=
--- Part Two ---

While it appears you validated the passwords correctly, they don't seem to be 
what the Official Toboggan Corporate Authentication System is expecting.

The shopkeeper suddenly realizes that he just accidentally explained the password 
policy rules from his old job at the sled rental place down the street! The Official 
Toboggan Corporate Policy actually works a little differently.

Each policy actually describes two positions in the password, where 1 means the 
first character, 2 means the second character, and so on. (Be careful; Toboggan 
Corporate Policies have no concept of "index zero"!) Exactly one of these positions 
must contain the given letter. Other occurrences of the letter are irrelevant for 
the purposes of policy enforcement.

Given the same example list from above:

    1-3 a: abcde is valid: position 1 contains a and position 3 does not.
    1-3 b: cdefg is invalid: neither position 1 nor position 3 contains b.
    2-9 c: ccccccccc is invalid: both position 2 and position 9 contain c.

How many passwords are valid according to the new interpretation of the policies?
=#

function is_valid(policy, letter, password)
    in_fst_pos = (password[policy[1]] == letter)
    in_snd_pos = (password[policy[2]] == letter)

    if in_fst_pos
        if in_snd_pos
            return false
        else
            return true
        end
    elseif in_snd_pos
        return true
    else
        return false
    end
end

function count_valid_passwords(policy, letter, pass)
    count_valid = 0
    for i in 1:size(pass,1)
        if is_valid(policy[i], letter[i], pass[i])
            count_valid+=1
        end
    end
    return count_valid
end

println("Valid passwords found with second policy: ", count_valid_passwords(policy, letter, pass))