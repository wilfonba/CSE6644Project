
function GMRES(A, x, b)
    # Compute initial residual
    r0 = b - A*x

    # Calculate norm of initial residual
    normr0 = 0
    for i = 1:axes(r0,1)
        normr0 = normr0 + r0[i]*r0[i]
    end
    normr0 = sqrt(normr0)

    # Normalize initial residual to get v_1
    for i = 1:axes(r0,1)
        r0[i] = r0[i]/normr0
    end



end