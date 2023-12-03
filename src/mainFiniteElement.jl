using SparseArrays
using LinearAlgebra

include("GMRES.jl")
include("SMW.jl")
include("Matrices.jl")

m = 100
tol = 1e-16
maxIter = 100
nIter = 0

A = spzeros(m,m)
M = zeros(1,7)
N = spzeros(m,m)
b = spzeros(m,1)

finiteElement!(A, M, N, b, m)

x, nIter = @time GMRES!(A, b, tol, maxIter)

println("GMRES Converged")
println("residual: ", norm(A*x - b))
println("nIter: ", nIter)
