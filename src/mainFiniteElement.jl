using SparseArrays
using LinearAlgebra

include("GMRES.jl")
include("SMW.jl")
include("Matrices.jl")

m = 100
A = spzeros(m,m)
M = zeros(1,7)
N = spzeros(m,m)
b = spzeros(m,1)

finiteElement!(A, M, N, b, m)
