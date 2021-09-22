struct Squares
    count::Int
end

#=
for item in Squares(3)
    println(item)
end
=#
Base.iterate(S::Squares, state = 1) =
    state > S.count ? nothing : (state * state, state + 1)
# (Given r::Iterators.Reverse{T}, the underling iterator of type T is r.itr
Base.iterate(rS::Iterators.Reverse{Squares}, state = rS.itr.count) =
    state < 1 ? nothing : (state * state, state - 1)
Base.eltype(::Type{Squares}) = Int
Base.length(S::Squares) = S.count

struct SquaresVector <: AbstractArray{Int,1}
    count::Int
end

# the first defines the eltype, and the second defines the ndims
Base.size(S::SquaresVector) = (S.count,)
Base.IndexStyle(::Type{<:SquaresVector}) = IndexLinear()
Base.getindex(S::SquaresVector, i::Int) = i * i

#=
s = SquaresVector(4)
s[s .> 8]
=#

struct SparseArray{T,N} <: AbstractArray{T,N}
    data::Dict{NTuple{N,Int},T}
    dims::NTuple{N,Int}
end

# Notice that this is an `IndexCartesian array`, so we must manually define `getindex` and `setindex!` at the dimensionality of the array

# Vararg is NTuple type, such that `SparseArray(Float64, 3, 3)` # dims = (3, 3)
SparseArray(::Type{T}, dims::Int...) where {T} = SparseArray(T, dims)
SparseArray(::Type{T}, dims::NTuple{N,Int}) where {T,N} =
    SparseArray{T,N}(Dict{NTuple{N,Int},T}(), dims) # !

Base.size(A::SparseArray) = A.dims
Base.similar(A::SparseArray, ::Type{T}, dims::Dims) where {T} =
    SparseArray(T, dims)
Base.getindex(A::SparseArray{T,N}, I::Vararg{Int,N}) where {T,N} =
    get(A.data, I, zero(T))
Base.setindex!(A::SparseArray{T,N}, v, I::Vararg{Int,N}) where {T,N} =
    (A.data[I] = v)

#=
j A[:] = 1:length(A);A
3×3 SparseArray{Float64, 2}:
 1.0  4.0  7.0
 2.0  5.0  8.0
 3.0  6.0  9.0
=#
