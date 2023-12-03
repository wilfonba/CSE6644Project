using LoopVectorization: @turbo

function GMRES!(A, b, tol, maxIter)
    error = 0
    m = size(A,1)
    x = zeros(m,1)
    v = spzeros(m, maxIter)
    y = zeros(maxIter+1)
    H = spzeros(maxIter + 1, maxIter)
    g = spzeros(m,1)
    nIter = 0

    # Compute initial residual
    r0 = b - A*x

    # Calculate norm of initial residual
    beta = 0
    for i = axes(r0,1)
        beta = beta + r0[i]*r0[i]
    end
    beta = sqrt(beta)
    g[1] = beta

    # Normalize initial residual to get v_1
    for i = axes(r0,1)
        v[i,1] = r0[i]/beta
    end

    @time for j = 1:maxIter-1
        nIter += 1

        # Pick a new vector w
        w = A*v[:,j]

        # Orthogonalize
        for i = 1:j
            H[i,j] = myDotProduct(w,v[:,i])
            for k = 1:m
                w[k] = w[k] - H[i,j]*v[k,i]
            end
        end

        # Find the magnitude
        normW = 0
        for i = axes(w,1)
            normW += w[i]*w[i]
        end
        normW = sqrt(normW)
        H[j+1,j] = normW

        if abs(H[j+1,j]) <= 1e-16
            break
        end

        # Compute error
        error = computeError(H, beta, error, j + 1, y, g)  

        display(error)
        if (error < tol)
            break
        end
        
        # Normalize
        for i = axes(w,1)
            w[i] = w[i]/normW
        end

        v[:,j+1] = w
        
    end

    y[1:nIter] = H[1:nIter,1:nIter]\y[1:nIter]

    display(y[1:nIter])

    computeError(H,beta,error,nIter,y,g)
    x = v[:,1:nIter]*y[1:nIter]

    return x, nIter

end

function computeError(HL, beta, error, m, y, g)

    K = zeros(2,2);

    i = m-1

    a = sqrt(HL[i,i]*HL[i,i] + HL[i+1,i]*HL[i+1,i])
    c = HL[i,i]/a
    s = HL[i+1,i]/a

    K = copy(HL[i:i+1,i:i+1])
    
    HL[i,i] = c*K[1,1] + s*K[2,1]
    HL[i+1,i] = -s*K[1,1] + c*K[2,1]
    HL[i,i+1] = c*K[1,2] + s*K[2,2]
    HL[i+1,i+1] = -s*K[1,2] + c*K[2,2]

    g[i] = c*g[i]
    g[i+1] = -s*g[i]

    y[1:m] = g[1:m]
    error = abs(g[m])

end

function myDotProduct(A,B)
    s = 0.0
    for i = axes(A,1)
        s += A[i]*B[i]
    end
    return s
end