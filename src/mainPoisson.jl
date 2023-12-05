using SparseArrays
using LinearAlgebra
using Plots
using FFTW
using ToeplitzMatrices
using BenchmarkTools
using SpecialMatrices

include("GMRES.jl")
include("SMW.jl")
include("Matrices.jl")

m = 4
tol = 1e-16
maxIter = 1000

A = spzeros(m*m,m*m)
M = zeros(m*m,1)
N = spzeros(m*m,m*m)
b = spzeros(m*m,1)

Poisson2D!(A, M, N, b, m*m)

x, nIter = GMRES!(A, b, tol, maxIter)

println("GMRES Converged")
println("residual: ", norm(b - A*x))
println("nIter: ", nIter)

x, nIter = SMW(M, N, b, zeros(m*m,1), tol, maxIter)

println("SMW Converged")
println("residual: ", norm(ones(m*m,1) - x))
println("nIter: ", nIter)