### NOTES
- Conventions:
 - Functions that write to their arguments have names that end in `!`. These are sometimes called "`mutating`" or "`in-place`" functions because they are intended to produce changes in their arguments after the function is called, not just return a value.
- Syntax Conflicts: `Juxtaposed literal coefficient syntax` may conflict with some numeric literal syntaxes:
 - In all cases the ambiguity is resolved in favor of interpretation as numeric literals:
  - Expressions starting with `0x/0o/0b` are always `hexadecimal/octal/binary` literals.
  - Expressions starting with a numeric literal followed by `e` or `E` are always `floating-point literals`.
  - Expressions starting with a numeric literal followed by `f` are always `32-bit floating-point literals`.
- `Vectorized "dot" operators`:
  - `dot calls`: `2 .* A.^2 .+ sin.(A)` (or equivalently `@. 2A^2 + sin(A)`, using the `@. macro`) 
  - `nested dot calls` like `f.(g.(x))` are fused, and "adjacent" binary operators like `x .+ 3 .* x.^2` are equivalent to nested dot calls `(+).(x, (*).(3, (^).(x, 2)))`.

- `A = [1,2,3]; 0 .< A .< 1;` returns `[0,0,0]`, which is a kind of masks for each element in array A 
  - `v(x) = (println(x); x); v(1) < v(2) <= v(3)`
- [`Operators With Special Names`](https://docs.julialang.org/en/v1/manual/functions/#Operators-With-Special-Names): A few special expressions correspond to calls to functions with 
  - Expression	Calls
  - `[A B C ...]`	`hcat` - create matix
  - `[A; B; C; ...]`	`vcat` - create matix
  - `[A B; C D; ...]`	`hvcat` - create matix
  - `A'`	`adjoint`
  - `A[i]`	`getindex`
  - `A[i] = x`	`setindex!`
  - `A.n`	`getproperty`
  - `A.n = x`	`setproperty!`

- [`Scope constructs`](https://docs.julialang.org/en/v1/manual/variables-and-scoping/#man-scope-table): The constructs introducing scope blocks are:
  - `Construct`	`Scope type`	`Allowed within`
  - `module, baremodule`	`global`	`global`
  - `struct`	`local (soft)`	`global`
  - `for, while, try`	`local (soft)`	`global, local`
  - `macro`	`local (hard)`	`global`
  - `functions, do blocks, let blocks, comprehensions, generators`	`local (hard)`	`global, local`

  - those which only introduce a "`soft scope`", which affects whether `shadowing` a `global variable by the same name` is allowed or not.
  - `begin` block doesn't introduct new scope
- Functions:
  - When `a bare identifier` or `dot expression` occurs after a semicolon, `the keyword argument name is implied by the identifier or field name`. For example,
   - `plot(x, y; width)` is equivalent to` plot(x, y; width=width)` and,
   - `plot(x, y; options.width)` is equivalent to `plot(x, y; width=options.width)`
  - rightmost occurance is applied:
   - In the call `plot(x, y; options..., width=2)` it is possible that the options structure also contains a value for width. In such a case the rightmost occurrence takes precedence. When `plot(x, y; width=3, width=2)`, `width=2` is applied
- [Supporting multi-dispatch](https://docs.julialang.org/en/v1/manual/methods/#Methods)
- Type: 
  - `Any` is commonly called "`top`" because it is at the apex of the type graph. Julia also has a predefined abstract "`bottom`" type, at the nadir of the type graph, which is written as `Union{}`. It is the exact opposite of `Any`: no object is an instance of `Union{}` and all types are supertypes of `Union{}`.

- The type `Vararg{T,N}` corresponds to exactly `N` elements of type `T`. `NTuple{N,T}` is a convenient alias for `Tuple{Vararg{T,N}}`, i.e. a tuple type containing exactly `N` elements of type `T`.
- The syntax `Array{<:Integer}` is a convenient shorthand for `Array{T} where T<:Integer`
- Method:
  - A definition of one possible behavior for a `function` is called a `method`.
  - The `choice of which method to execute` when a function is applied is called `dispatch`.