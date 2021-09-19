using Dates
using Lazy
using PartialFunctions

"""
- Julia Types | <https://docs.julialang.org/en/v1/manual/types/>
- Lazy Macro | <https://github.com/MikeInnes/Lazy.jl#macros>
- latex_symbols.jl | <https://github.com/JuliaLang/julia/blob/37e239ce7fb04c16598e969350c53ab75a93afaf/stdlib/REPL/src/latex_symbols.jl#L528
- PartialFunctions | <https://juliahub.com/ui/Packages/PartialFunctions/dX5Z0/1.0.4>
"""

hello(who::String) = "Hello, $who"

minmax(x, y) = (y < x) ? (y, x) : (x, y)

gap((min, max)) = max - min

test = () -> gap(minmax(10, 2))

# function Date(y::Int64, m::Int64 = 1, d::Int64 = 1)
#     err = validargs(Date, y, m, d) # `validargs` is not defined.
#     err === nothing || throw(err)
#     return Date(UTD(totaldays(y, m, d)))
# end

b = "outer b val"
function looksOuter(x, a = b, b = 1)
    # When `a` is not given, the variable `a` doesn't refer to `b` but `b` from outer scope sintead.
    """ looksOuter(1) # outer b val"""
    println("ok")
end

mapped(l::Vector{Int64}) =
# do a,b would create a two-argument anonymous function
    map(l) do x
        cat(x)
    end

mapped2(l::Vector{Int64}) = @>> l begin
    map(cat)
end

mapped3(l::Vector{Int64}) = cat.(l)

cat(x::Int64) =
    if x < 0 && iseven(x)
        0
    elseif x == 0
        1
    else
        x
    end

cat2(x::Int64) = begin
    x < 0 && iseven(x) && return 0
    x == 0 && return 1
    return x
end

fact(n::Int) = begin
    n >= 0 || error("n must be non-negative")
    n == 0 && return 1
    n * fact(n - 1)
end

# function composition
fc(f::Int64, s::Int64) = (sqrt ∘ +)(f, s)

# piping
pp(f::Int64, s::Int64) = [f, s] |> sum |> sqrt

pp2() = 1:10 |> sum |> sqrt

curry(f, a...) = (b...) -> f(a..., b...) # same as `Base.Fix1`

inp = [1.0:5.0;]

add_one() = 1:10 .|> (x -> x + 1)
add_one2() = 10 .* 1 .+ inp                 # 初めに * 10 を適用
add_one2_2() = @. 10 * 1 + inp              # 初めに * 10 を適用
add_one3() = inp .|> (sqrt ∘ (x -> x * 2))  # 初めに * 2 を適用
add_one4() = inp .|> sqrt .|> (x -> x * 2)  # 初めに sqrt を適用
add_one5() = @. inp |> sqrt |> (*)$2        # 初めに sqrt を適用

# broadcasing := それぞれの element に対し、index の対応する関数をそれぞれ適用
ziplike() = ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]

f(x, y) = 3x + 4y;
A = [1.0, 2.0, 3.0];
B = [4.0, 5.0, 6.0];
f.(pi, A) # like `zipLongest`
f.(A, B)  # like simple `zip`

"""
These are the same: 

1. sin.(cos.(X)) 
2. broadcast(x -> sin(cos(x)), X)
3. [sin(cos(x)) for x in X]

Technically, the `fusion` stops as soon as a "non-dot" function call is encountered; 
for example, in `sin.(sort(cos.(X)))` the `sin` and `cos` loops cannot be merged because of the intervening `sort` function.
"""

# Pre allocation for Vector and apply function to each element
Y = [1.0:5.0;]

X = similar(Y) # pre-allocate output array

@. X = sin(cos(Y)) # equivalent to X .= sin.(cos.(Y))

# 1x2 matrix
this_is_matrix = 1 .+ [2, 3]
# 2x2 matrix
this_is_matrix2 = [1 2] .+ [3, 4]

# you can `reuse` variable from `outer scope` in loop
function f_using_outer_val()
    i = 0
    for outer i = 1:3
        # empty
    end
    return i
end
