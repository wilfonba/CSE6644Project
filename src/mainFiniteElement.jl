using SparseArrays
using LinearAlgebra
using BenchmarkTools
using ToeplitzMatrices
using SpecialMatrices
using FFTW

include("GMRES.jl")
include("SMW.jl")
include("Matrices.jl")

m = 1000
tol = 1e-16
maxIter = 1000
nIter = 0

A = spzeros(m,m)
M = zeros(m,1)
N = spzeros(m,m)
b = spzeros(m,1)


finiteElement!(A, M, N, b, m)

@info "GMRES"
x, nIter = GMRES!(A, b, m, tol, maxIter)
bench = @benchmark GMRES!(A, b, m, tol, maxIter)
@info "GMRES Converged. residual: $(norm(b - A*x))" nIter
display(bench)
# println("GMRES Converged")
# println("residual: ", norm(b - A*x))
# println("nIter: ", nIter)

@info "SMW:"
x, nIter = SMW(M, N, b, m, tol, maxIter)
bench = @benchmark SMW(M, N, b, m, tol, maxIter)
@info "SMW Converged. residual: $(norm(b - A*x))" nIter
display(bench)
# println("SMW Converged")
# println("residual: ", norm(b - A*x))
# println("nIter: ", nIter)

