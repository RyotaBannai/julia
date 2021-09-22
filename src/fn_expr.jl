using Lazy
using PartialFunctions

minmax(x, y) = (y < x) ? (y, x) : (x, y)

gap((min, max)) = max - min

test = () -> gap(minmax(10, 2))

mapped(l::Vector{UInt}) =
# do a,b would create a two-argument anonymous function
    map(l) do x
        cat(x)
    end

mapped2(l::Vector{UInt}) = @>> l begin
    map(cat)
end

mapped3(l::Vector{UInt}) = cat.(l)

cat(x::UInt) =
    if x < 0 && iseven(x)
        0
    elseif x == 0
        1
    else
        x
    end

cat2(x::UInt) = begin
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
fc(f::UInt, s::UInt) = (sqrt ∘ +)(f, s)

# piping
pp(f::UInt, s::UInt) = [f, s] |> sum |> sqrt

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
ziplike() =
    ["a", "list", "of", "strings"] .|> [uppercase, reverse, titlecase, length]

f(x, y) = 3x + 4y;
A = [1.0, 2.0, 3.0];
B = [4.0, 5.0, 6.0];
f.(pi, A) # like `zipLongest`
f.(A, B)  # like simple `zip`

#=
These are the same:

1. sin.(cos.(X))
2. broadcast(x -> sin(cos(x)), X)
3. [sin(cos(x)) for x in X]

Technically, the `fusion` stops as soon as a "non-dot" function call is encountered;
for example, in `sin.(sort(cos.(X)))` the `sin` and `cos` loops cannot be merged because of the intervening `sort` function.
=#

# Pre allocation for Vector and apply function to each element
Y = [1.0:5.0;]

X = similar(Y) # pre-allocate output array

@. X = sin(cos(Y)) # equivalent to X .= sin.(cos.(Y))

# 1x2 matrix
this_is_matrix = 1 .+ [2, 3]

# 2x2 matrix
this_is_matrix2 = [1 2] .+ [3, 4]
