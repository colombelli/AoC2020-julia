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



