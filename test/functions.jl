facts("calls") do
    strs = ["f(x)"
            "f(x,y)"
            "f(g(x))"
            "f((x,y))"
            "f((x,y), z)"
            "f(z, (x,y), z)"
            "f{a}(x)"
            "f{a<:T}(x::T)"]
    for str in strs
        test_parse(str)
    end
end


facts("one liner functions") do
    strs = ["f(x) = x"
            "f(x) = g(x)"
            "f(g(x)) = x"
            "f(g(x)) = h(x)"]
    for str in strs
        test_parse(str)
    end
end

facts("function definitions") do
    strs =  ["function f end"
            "function f(x) x end"
            """function f(x)
                x
            end"""
            "f(x::Int)"
             "f(x::Vector{Int})"
             "f(x::Vector{Vector{Int}})"
             "f(x::Vector{Vector{Int}})"]
    for str in strs
        test_parse(str)
    end
end