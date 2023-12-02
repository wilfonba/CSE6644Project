using SparseArrays

include("GMRES.jl")
include("SMW.jl")
include("Matrices.jl")

n = 10
A = spzeros(10,10)
M = spzeros(10,10)
N = spzeros(10,10)

finiteElement!(A, M, N, 10)

print(Matrix(A))
spdiagm(-3 => 1/2440*ones(m))