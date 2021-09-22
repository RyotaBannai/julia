
struct MyRecord
    first::UInt
    second::UInt
    vec::Vector{UInt}
end

# フィールドが指す address `は変更できないが、mutable` フィールド自体は変更可能
r = MyRecord(1, 2, [1, 2, 3])
push!(r.vec, 4)

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

#=
type T should be the same type, if you want to use different type for each at constructor,
then, you should define outer constructor method as you desire.

Point(x::Int64, y::Float64) = Point(convert(Float64, x), y)
norm2(Point(1,2.))
=#
# Without  <:Real constraint, `promote` will try to convert endlessly, causing stackoverflow.
Point(x::T, y::T) where {T<:Real} = Point{T}(x, y);
Point(x::Real, y::Real) = Point(promote(x, y)...)

struct DiagPoint{T} <: Pointy{T}
    x::T
end

function norm(p::Point{<:Real}) # you can't put just `Read` because it doesn't accept any other type.
    sqrt(p.x^2 + p.y^2)
end

# inputs must be Float64 because the return value is Float64(bc `sqrt`)
function norm2(p::Point{T})::T where {T<:Real}
    sqrt(p.x^2 + p.y^2)
end

#=
actual definition of Julia's Rational immutable type:

struct Rational{T<:Integer} <: Real
  num::T
  den::T
end
=#

const T1 = Array{Array{T,1} where T,1}
# Vector{Vector{T} where T} (alias for Array{Array{T, 1} where T, 1})

const T2 = Array{Array{T,1},1} where {T}
# Array{Vector{T}, 1} where T

#= |
<https://docs.julialang.org/en/v1/manual/types/#UnionAll-Types>

Type `T1` defines a 1-dimensional array of 1-dimensional arrays; each of the inner arrays consists of objects of the same type, but this type may vary from one inner array to the next.

On the other hand, type `T2` defines a 1-dimensional array of 1-dimensional arrays all of whose inner arrays must have the same type.

Note that `T2` is an abstract type, e.g., `Array{Array{Int,1},1} <: T2`, whereas `T1` is a concrete type. As a consequence, `T1` can be constructed with a zero-argument constructor `a=T1()` but `T2` cannot.
=#

struct WrapType{T}
    value::T
end

#=
WrapType(Float64) # default constructor, note DataType
WrapType{DataType}(Float64)
"""
WrapType(::Type{T}) where {T} = WrapType{Type{T}}(T)

"""
WrapType(Float64) # sharpened constructor, note more precise Type{Float64}
WrapType{Type{Float64}}(Float64)
=#

struct Polar{T<:Real} <: Number
    r::T
    Θ::T
end

Polar(r::Real, Θ::Real) = Polar(promote(r, Θ)...)
Base.show(io::IO, z::Polar) = print(io, z.r, " * exp(", z.Θ, "im)")
Base.show(io::IO, ::MIME"text/plain", z::Polar{T}) where {T} =
    print(io, "Polar{$T} complex number:\n    ", z)

# display(z) -> show(stdout,MIME("text/plain"),z) -> show(stdout,z)

#=
`::` symbol, which only the type is given, means that for a function argument whose type is specified but whose value does not need to be referenced

<https://docs.julialang.org/en/v1/manual/conversion-and-promotion/#Defining-New-Conversions>
=#
function Base.show_unquoted(io::IO, z::Polar, ::Int, predecence::Int)
    Base.operator_precedence(:*) <= predecence ? begin
        print(io, "(")
        show(io, z)
        print(io, ")")
    end : show(io, z)
end

#=
a = Polar(3,4.0)
:($a^2)
# shows `:((3.0 * exp(4.0im)) ^ 2)` instead of `3.0 * exp(4.0im) ^ 2`
=#

# passing context
function Base.show(io::IO, z::Polar)
    get(io, :compact, false) ? print(io, z.r, "e", z.Θ, "im") :
    print(io, z.r, " * exp(", z.Θ, "im)")
end

#=
show(IOContext(stdout,:compact=>true),a) # 3.0e4.0im
show(a)                                  # 3.0 * exp(4.0im)
=#
