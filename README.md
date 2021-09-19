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
- Functions:
  - When `a bare identifier` or `dot expression` occurs after a semicolon, `the keyword argument name is implied by the identifier or field name`. For example,
   - `plot(x, y; width)` is equivalent to` plot(x, y; width=width)` and,
   - `plot(x, y; options.width)` is equivalent to `plot(x, y; width=options.width)`
  - rightmost occurance is applied:
   - In the call `plot(x, y; options..., width=2)` it is possible that the options structure also contains a value for width. In such a case the rightmost occurrence takes precedence. When `plot(x, y; width=3, width=2)`, `width=2` is applied
- [Supporting multi-dispatch](https://docs.julialang.org/en/v1/manual/methods/#Methods)