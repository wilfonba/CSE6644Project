using SparseArrays
using LinearAlgebra
using Plots

include("GMRES.jl")
include("SMW.jl")
include("Matrices.jl")

m = 10
A = spzeros(m*m,m*m)
M = zeros(1,3)
N = spzeros(m*m,m*m)
b = spzeros(m*m,1)

Poisson2D!(A, M, N, b, m)
