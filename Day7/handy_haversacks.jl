#=
--- Day 7: Handy Haversacks ---

You land at the regional airport in time for your next flight. In fact, it looks like you'll even have time to grab some food: all flights are currently delayed due to issues in luggage processing.

Due to recent aviation regulations, many rules (your puzzle input) are being enforced about bags and their contents; bags must be color-coded and must contain specific quantities of other color-coded bags. Apparently, nobody responsible for these regulations considered how long they would take to enforce!

For example, consider the following rules:

light red bags contain 1 bright white bag, 2 muted yellow bags.
dark orange bags contain 3 bright white bags, 4 muted yellow bags.
bright white bags contain 1 shiny gold bag.
muted yellow bags contain 2 shiny gold bags, 9 faded blue bags.
shiny gold bags contain 1 dark olive bag, 2 vibrant plum bags.
dark olive bags contain 3 faded blue bags, 4 dotted black bags.
vibrant plum bags contain 5 faded blue bags, 6 dotted black bags.
faded blue bags contain no other bags.
dotted black bags contain no other bags.

These rules specify the required contents for 9 bag types. In this example, every faded blue bag is empty, every vibrant plum bag contains 11 bags (5 faded blue and 6 dotted black), and so on.

You have a shiny gold bag. If you wanted to carry it in at least one other bag, how many different bag colors would be valid for the outermost bag? (In other words: how many colors can, eventually, contain at least one shiny gold bag?)

In the above rules, the following options would be available to you:

    A bright white bag, which can hold your shiny gold bag directly.
    A muted yellow bag, which can hold your shiny gold bag directly, plus some other bags.
    A dark orange bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.
    A light red bag, which can hold bright white and muted yellow bags, either of which could then hold your shiny gold bag.

So, in this example, the number of bag colors that can eventually contain at least one shiny gold bag is 4.

How many bag colors can eventually contain at least one shiny gold bag? (The list of rules is quite long; make sure you get all of it.)
=#



"""
    Arry[ 
            bag_color => [(Int,bag_color), (Int,bag_color), ...], 
            bag_color => [(Int,bag_color), (Int,bag_color), ...], 
            bag_color => [(Int,bag_color), (Int,bag_color), ...] 
        ]
"""

function read_input()
    rules = []
    open("./input", "r") do f
        while ! eof(f)
            s::String = readline(f)
            bag_color_rule = split(s," bags contain ")[1]
            contained_bags = split(s," bags contain ")[2]
            
            
            list_contained = split(contained_bags,",")
            dict_value = []
            for contained in list_contained

                if contained[1] == ' '
                    contained = contained[2:end]
                end

                # gambi because muita mão
                qtd =  match(r"[\d]*",contained).match

                bag_quantity = tryparse(Int,qtd)
                if bag_quantity == nothing
                    break end

                bag_color = match(r"[^\d]*.?(?= bag)",contained).match[2:end]
                push!(dict_value,(bag_quantity,bag_color))
            end

            push!(rules, Dict(bag_color_rule => dict_value))
        end
    end
    return rules
end


bag_dict_list = read_input()
parent_bags = Set()

function find_parent_bags(bag_color)
    for rule in bag_dict_list
        for (bag, tuples) in rule   # rule has only one element, but i used a for loop in order to extract its key,value pair
            for t in tuples
                if bag_color == t[2]
                    push!(parent_bags, bag)
                    find_parent_bags(bag)
                    break
                end
            end
        end 
    end
end

find_parent_bags("shiny gold")
println("There are ", length(parent_bags), " bags that can eventually contain shiny gold bags.")

function check_if_rule_repeat()
    colors_set=Set()
    colors_list=[]
    for rule in bag_dict_list
        for (bag, tuple) in rule
            push!(colors_set, bag)
            push!(colors_list, bag)
        end
    end
    if length(colors_set) != length(colors_list)
        return true
    else
        return false
    end
end

println("Do rules reapeat? ", check_if_rule_repeat() ? "yes" : "no")
println("Number of rules: ", length(bag_dict_list))