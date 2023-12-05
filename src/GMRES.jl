using LoopVectorization: @turbo

function GMRES!(A, b, m, tol, maxIter)
    x = zeros(m,1)
    v = spzeros(m, maxIter)
    H = spzeros(maxIter + 1, maxIter)
    g = spzeros(m,1)
    nIter = 0

    # Calculate norm of initial residual
    beta = myDotProduct(b,b)
    beta = sqrt(beta)
    g[1] = beta

    # Normalize initial residual to get v_1
    for i = axes(b,1)
        v[i,1] = b[i]/beta
    end

    for j = 1:maxIter-1
        nIter += 1

        # Pick a new vector w
        w = A*v[:,j]

        # Orthogonalize
        for i = 1:j
            H[i,j] = @views myDotProduct(w,v[:,i])
            for k = 1:m
                w[k] = w[k] - H[i,j]*v[k,i]
            end
        end

        # Find the magnitude
        normW = @views myDotProduct(w,w)
        normW = sqrt(normW)
        H[j+1,j] = normW

        if abs(H[j+1,j]) <= 1e-16
            break
        end

        # Normalize
        for i = axes(w,1)
            w[i] = w[i]/normW
        end

        v[:,j+1] = w
        # Compute error
        r = vcat(norm(b), zeros(j))
        z = H[1:j+1,1:j] \ r
        x = v[:,1:j]*z
        residual = norm(b - A*x)

        if (residual < tol)
            break
        end
        
    end

    return x, nIter

end

function myDotProduct(A,B)
    s = 0.0
    for i = axes(A,1)
        s += A[i]*B[i]
    end
    return s
end