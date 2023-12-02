using LinearAlgebra


function Poisson2D!(A, M, N, b, m)

    D = spdiagm(-1 => ones(m-1),0 => -4*ones(m), 1=> ones(m-1))
    
    # Block tri-diagonal matrix A
    for i = 1:m
        # diagonal
        A[(i-1)*m+1:i*m,(i-1)*m + 1:i*m] = D

        # upper diagonal
        if i < m
            A[(i-1)*m+1:i*m,i*m+1:(i+1)*m] = sparse(I,m,m)
        end

        # lower diagonal
        if i > 1
            A[(i-1)*m+1:i*m,(i-2)*m+1:(i-1)*m] = sparse(I,m,m)
        end
    end

    # Circulant part m
    M[:] .= (1, -4, 1)

    # Sparse non-circulant part N
    N[:,:] = spzeros(m*m,m*m)
    N[1,m*m] = 1.0
    N[m*m,1] = 1.0

    # LHS b so that x = ones(n^2,1)
    b[:] = A*ones(m*m,1)   
end

function finiteElement!(A, M, N, b, m)

    # hepta-diagonal Mass Matrix
    A[:,:] = spdiagm(m, m, -3 => 1/2240*ones(m-3), -2 => 29/560*ones(m-2),
         -1 => 773/2240*ones(m-1), 0 => 31/140*ones(m), 
         1 => 773/2240*ones(m-1), 2 => 29/560*ones(m-2), 
         3 => 1/2240*ones(m-3))

    # Circulant part M
    M[:] = [1/2240, 3/56, 1191/2240, 151/140, 1191/2240, 3/56, 1/2240]

    # Sparse non-circulant part N
    for i = 1:m
        for j = i-3:i+3
            if j >= 1 && j <=m
                N[i,j] = M[j-i+4] - A[i,j]
            end
        end
    end


    N[1:3,m-2:m] = [1/2240 29/560 773/2240;
                    0       1/2240 29/560;
                    0       0      1/2240]

    N[m-2:m,1:3] = [1/2240 0 0;
                    29/560 1/2240 0;
                    773/2240 29/560 1/2240]

    # LHS b so that x = ones(m,1)
    b[:] = A*ones(m,1)

end