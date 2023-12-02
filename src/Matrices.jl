using SparseArrays

#function 2DPoisson!(A, M, N, m)

#end

function finiteElement!(A, M, N, m)

    A = spdiagm(-3 => 1/2440*ones(m))


end