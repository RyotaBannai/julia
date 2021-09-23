
# 3×3 Matrix{Int64}
test = [zeros(Int, 2, 2) [1; 2]; [3 4] 5]

x = rand(8)
test2 = [0.25 * x[i] for i = 1:length(x)-1]

# Using generator
test3 = map(tuple, (1 / (i + j) for i = 1:2, j = 1:2), [1 3; 2 4])

# If-filtering
test4 = [(i, j) for i = 1:3 for j = 1:i if i + j == 4]

x = reshape(1:16, 4, 4)
indexed = x[1, [2 3; 4 1]]

A = reshape(1:32, 4, 4, 2)
page = A[:, :, 1]

# j take_diag(page)
take_diag =
   (A::Matrix{T} where {T})-> Base.foldl(
      (accm, i) -> push!(accm, A[CartesianIndex(i, i)]),
      1:size(page)[1],
      init = eltype(A)[],
   )
   
take_diag2 = A[CartesianIndex.(axes(A, 1), axes(A, 2)), 1]
