using Dates
using Lazy
using PartialFunctions

"""
- Julia Types | <https://docs.julialang.org/en/v1/manual/types/>
- Lazy Macro | <https://github.com/MikeInnes/Lazy.jl#macros>
- latex_symbols.jl | <https://github.com/JuliaLang/julia/blob/37e239ce7fb04c16598e969350c53ab75a93afaf/stdlib/REPL/src/latex_symbols.jl#L528>
- PartialFunctions | <https://juliahub.com/ui/Packages/PartialFunctions/dX5Z0/1.0.4>
"""

hello(who::String) = "Hello, $who"

minmax(x, y) = (y < x) ? (y, x) : (x, y)

gap((min, max)) = max - min

test = () -> gap(minmax(10, 2))

# function Date(y::UInt, m::UInt = 1, d::UInt = 1)
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


struct MyRecord
    first::UInt
    second::UInt
    vec::Vector{UInt}
end

r = MyRecord(1, 2, [1, 2, 3])
push!(r.vec, 4) # フィールドが指す address `は変更できないが、mutable` フィールド自体は変更可能

# you can change struct to `mutable` one 
struct mutable
    MMyRecord::Any
    first::UInt
    second::UInt
    vec::Vector{UInt}
end

# * Parametric Abstract Types
abstract type Pointy{T<:Real} end

# * Parametric Composite Types
struct Point{T} <: Pointy{T}
    x::T
    y::T
end

struct DiagPoint{T} <: Pointy{T}
    x::T
end

function norm(p::Point{<:Real}) # you can't put just `Read` because it doesn't accept any other type.
    sqrt(p.x^2 + p.y^2)
end

function norm2(p::Point{T} where {T<:Real})::T
    sqrt(p.x^2 + p.y^2)
end

"""
actual definition of Julia's Rational immutable type:

struct Rational{T<:Integer} <: Real
  num::T
  den::T
end
"""

const T1 = Array{Array{T,1} where T,1}
# Vector{Vector{T} where T} (alias for Array{Array{T, 1} where T, 1})

const T2 = Array{Array{T,1},1} where {T}
# Array{Vector{T}, 1} where T

""" |
<https://docs.julialang.org/en/v1/manual/types/#UnionAll-Types>

Type `T1` defines a 1-dimensional array of 1-dimensional arrays; each of the inner arrays consists of objects of the same type, but this type may vary from one inner array to the next. 

On the other hand, type `T2` defines a 1-dimensional array of 1-dimensional arrays all of whose inner arrays must have the same type. 

Note that `T2` is an abstract type, e.g., `Array{Array{Int,1},1} <: T2`, whereas `T1` is a concrete type. As a consequence, `T1` can be constructed with a zero-argument constructor `a=T1()` but `T2` cannot.
"""

struct WrapType{T}
    value::T
end

"""
WrapType(Float64) # default constructor, note DataType 
WrapType{DataType}(Float64)
"""
WrapType(::Type{T}) where {T} = WrapType{Type{T}}(T)

"""
WrapType(Float64) # sharpened constructor, note more precise Type{Float64}
WrapType{Type{Float64}}(Float64)
"""

struct Polar{T<:Real} <: Number
    r::T
    Θ::T
end

Polar(r::Real, Θ::Real) = Polar(promote(r, Θ)...)
Base.show(io::IO, z::Polar) = print(io, z.r, " * exp(", z.Θ, "im)")
Base.show(io::IO, ::MIME"text/plain", z::Polar{T}) where {T} =
    print(io, "Polar{$T} complex number:\n    ", z)

# display(z) -> show(stdout,MIME("text/plain"),z) -> show(stdout,z)

function Base.show_unquoted(io::IO, z::Polar, ::Int, predecence::Int)
    Base.operator_precedence(:*) <= predecence ? begin
        print(io, "(")
        show(io, z)
        print(io, ")")
    end : show(io, z)
end
"""
a = Polar(3,4.0)
:($a^2)
# shows `:((3.0 * exp(4.0im)) ^ 2)` instead of `3.0 * exp(4.0im) ^ 2`
"""

# passing context 
function Base.show(io::IO, z::Polar)
    get(io, :compact, false) ? print(io, z.r, "e", z.Θ, "im") :
    print(io, z.r, " * exp(", z.Θ, "im)")
end

"""
show(IOContext(stdout,:compact=>true),a) # 3.0e4.0im
show(a)                                  # 3.0 * exp(4.0im)
"""
