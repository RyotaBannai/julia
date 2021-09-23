function make_expr2(op, opr1, opr2)
    opr1f, opr2f = map(x -> isa(x, Number) ? 2 * x : x, (opr1, opr2))
    Expr(:call, op, opr1f, opr2f)
end

test = make_expr2(:+, 1, 2)
test2 = make_expr2(:+, 1, Expr(:call, :*, 5, 8))

#=
j eval(test2) # 42
=#

#=
Compiler will replace all instances of @sayhello with:
:( println("Hello, Julia!") )

also, we can view the `quoted` return expression using the function `macroexpand (important note: this is an extremely useful tool for debugging macros):

j macroexpand(Main, :(@welcome("human"))) # or,
j @macroexpand @welcome "human"
:(Main.println("Welcome back, ", "human"))

=#
macro sayhello()
    return :(println("Hello, Julia!"))
end

macro welcome(name::String)
    return :(println("Welcome back, ", $name))
end

test3 = @sayhello()
test4 = @welcome("Julia")
test5 = @welcome "Julia"

#=
Invoking array literals (or comphrehension)

@name[a b] * v
@name([a b]) * v
=#


# @__LINE__, @__FILE__, and @__DIR__
macro __LOCATION__()
    return QuoteNode(__source__)
end

# j dump(@__LOCATION__())


#=
Julia's assert macro def
<https://github.com/JuliaLang/julia/blob/master/base/error.jl#L216>
=#

# j @mtime 3
macro mtime(expr)
    return :(timeit(() -> $(esc(expr))))
end

function timeit(f)
    t0 = time_ns()
    val = f()
    t1 = time_ns()
    println("elapsed time: ", (t1 - t0) / 1e9, " seconds")
    return val
end


struct MyNumber
    x::Float64
end

#=
use
`:()` instead of `quote ... end`, and,
`@eval` intead of `eval(:( ... ))`
=#

for op in (:sin, :cos, :tan, :log, :exp)
    @eval Base.$op(a::MyNumber) = MyNumber($op(a.x))
end


# sub2ind_loop((3, 5), 1, 2) # N=2, I=(1, 2)
function sub2ind_loop(dims::NTuple{N}, I::Integer...) where {N}
    ind = I[N] - 1
    for i = N-1:-1:1
        ind = I[i] - 1 + dims[i] * ind
    end
    return ind + 1
end

sub2ind_rec(dims::Tuple{}) = 1;
sub2ind_rec(dims::Tuple{}, i1::Integer, I::Integer...) =
    i1 == 1 ? sub2ind_rec(dims, I...) : throw(BoundsError());
sub2ind_rec(dims::Tuple{Integer,Vararg{Integer}}, i1::Integer) = i1;
sub2ind_rec(dims::Tuple{Integer,Vararg{Integer}}, i1::Integer, I::Integer...) =
    i1 + dims[1] * (sub2ind_rec(Base.tail(dims), I...) - 1);
