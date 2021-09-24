using Dates

# import files into this main.jl scope
include("./my_sqaure.jl")
include("./my_rational.jl")
include("./fn_expr.jl")
include("./record.jl")
include("./scope.jl")

#=
- Julia Types | <https://docs.julialang.org/en/v1/manual/types/>
- What is difference between Type{T} and T | <https://discourse.julialang.org/t/what-is-difference-between-type-t-and-t/19325/57>
- UnionAll | <https://docs.julialang.org/en/v1/devdocs/types/#UnionAll-types>
- Lazy Macro | <https://github.com/MikeInnes/Lazy.jl#macros>
- latex_symbols.jl | <https://github.com/JuliaLang/julia/blob/37e239ce7fb04c16598e969350c53ab75a93afaf/stdlib/REPL/src/latex_symbols.jl#L528>
- PartialFunctions | <https://juliahub.com/ui/Packages/PartialFunctions/dX5Z0/1.0.4>
=#

# function Date(y::UInt, m::UInt = 1, d::UInt = 1)
#     err = validargs(Date, y, m, d) # `validargs` is not defined.
#     err === nothing || throw(err)
#     return Date(UTD(totaldays(y, m, d)))
# end

# "~/Documents/dev/julia/julia/src/main.jl"
path = Base.source_path()
path2 = @__FILE__
const x = Base.source_path()
path3() = x

# * Methods
m(x::Float64, y::Float64) = 2x + y
m(x::Integer, y::Integer) = 2x - y

same_type(x::T, y::T) where {T} = true
same_type(x, y) = false

testm(x::Int) = "definition for Int"
testm(x::Type{Int}) = "definition for Type{Int}"

# DataType <: Type{T} <: Any
# typeof(AbstractArray) = AbstractArray, supertype(AbstractArray) = UnionAll <: Type{T}
# Array <: DenseArray <: AbstractArray -- all type are UnionAll

# dump(Array) to show details types

# Extract the type parameter from a super-type: use `Base.eltype` insetad tho
# eltype(Array{UInt, 2}) = UInt64
# eltype(::Type{<:AbstractArray{T}}) where {T} = T

# copy_with_eltype(input, Float64) # changes the type of element `UInt` to `Float64`
input = Array{UInt}(undef, 2)
copy_with_eltype(input, Eltype) = copyto!(similar(input, Eltype), input)

# `f(x::Int...) = x` is a shorthand for `f(x::Vararg{Int}) = x`

struct Foo
    bar::Any
    baz::Any
end

#=
re-define constructor (called `outer constructor methods`)
however, `outer constructor methods` fails to address these two problems:
1. enforcing `invariants`(:= are kind of rules, guards)
2. allowing construction of self-referential objects. For these problems
=#

Foo(x) = Foo(x, x + 1)
Foo() = Foo(0)

# Using inner constructor methods
struct OrderedPair
    fst::Real
    snd::Real
    OrderedPair(fst, snd) = fst > snd ? error("out of order") : new(fst, snd)
end

# Incomplete Initialization
mutable struct SelfReferential
    self::SelfReferential
    SelfReferential() = (x = new(); x.self = x)
end

mutable struct MyLazyBoy
    data::Any
    MyLazyBoy(v) = complete_me(new(), v) # delegate
end

function complete_me(obj::MyLazyBoy, v)
    obj.data = v
    obj
end

# Outer-only constructors
struct SummedArray{T<:Number,S<:Number}
    data::Vector{T}
    sum::S
    function SummedArray(a::Vector{T}) where {T}
        S = widen(T)
        new{T,S}(a, sum(S, a))
    end
end

for line in eachline(open("./inputs.txt"))
    isempty(line) && break
    println(line)
end

open("./inputs.txt") do f
    foreach(println, eachline(f))
end
