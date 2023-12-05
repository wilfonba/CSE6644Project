using LinearAlgebra

function Poisson2D!(A, M, N, b, m)

    M[:,:] = spzeros(m,1)
    M[1] = 16
    M[2] = -5
    M[m] = -5
    M[:,:] = M[:,:]./6

    N[:,:] = spzeros(m,m)
    N[1,1] = 8
    N[m,m] = 8
    N[1,m] = -5
    N[m,1] = -5
    N[:,:] = N./6

    A[:,:] = spdiagm(-1 => -5/6*ones(m-1), 0 => 16/6*ones(m), 1 => -5/6*ones(m-1))
    A[1,1] = A[1,1] - 8/6
    A[m,m] = A[m,m] - 8/6

    b[:] = A*ones(m,1)
    display(Matrix(N))
end

# function Poisson2D!(A, M, N, b, m)

#     D = spdiagm(-1 => ones(m-1),0 => -4*ones(m), 1=> ones(m-1))
    
#     # Block tri-diagonal matrix A
#     for i = 1:m
#         # diagonal
#         A[(i-1)*m+1:i*m,(i-1)*m + 1:i*m] = D

#         # # upper diagonal
#         # if i < m
#         #     A[(i-1)*m+1:i*m,i*m+1:(i+1)*m] = sparse(I,m,m)
#         # end

#         # # lower diagonal
#         # if i > 1
#         #     A[(i-1)*m+1:i*m,(i-2)*m+1:(i-1)*m] = sparse(I,m,m)
#         # end
#     end

#     # Circulant part m
#     M[:,1] = spzeros(m*m,1)
#     M[1:2,1] = [-4;1];
#     M[m*m,1] = 1

#     # Sparse non-circulant part N
#     N[:,:] = spzeros(m*m,m*m)
#     N[1,m*m] = 1.0
#     N[m*m,1] = 1.0

#     # for i = 1:m
#     #     # upper diagonal
#     #     if i < m
#     #         N[(i-1)*m+1:i*m,i*m+1:(i+1)*m] = -sparse(I,m,m)
#     #     end

#     #     # lower diagonal
#     #     if i > 1
#     #         N[(i-1)*m+1:i*m,(i-2)*m+1:(i-1)*m] = -sparse(I,m,m)
#     #     end
#     # end


#     # LHS b so that x = ones(n^2,1)
#     b[:] = A*ones(m*m,1)   
# end

function finiteElement!(A, M, N, b, m)

    # hepta-diagonal Mass Matrix
    A[:,:] = spdiagm(m, m, -3 => 1/2240*ones(m-3), -2 => 3/56*ones(m-2),
         -1 => 1191/2240*ones(m-1), 0 => 151/140*ones(m), 
         1 => 1191/2240*ones(m-1), 2 => 3/56*ones(m-2), 
         3 => 1/2240*ones(m-3))
    A[1:4,1:4] = [31/40 773/2240 29/560 1/2240;
                773/2240 41/40 17/32 3/56;
                29/560 17/32 151/140 1191/2240;
                1/2240 3/56 1191/2240 151/140];
    A[m-3:m,m-3:m] = [151/140 1191/2240 3/56 1/2240;
                1191/2240 151/140 17/32 29/560;
                3/56 17/32 41/40 773/2240; 
                1/2240 29/560 773/2240 31/140];
    

    # Circulant part M
    M[:] = [151/140; 1191/2240; 3/56; 1/2240; zeros(m-7,1); 1/2240; 3/56; 1191/2240]

    # Sparse non-circulant part N
    N[1:3,m-2:m] = [1/2240 3/56 1191/2240;
                    0       1/2240 3/56;
                    0       0      1/2240]

    N[m-2:m,1:3] = [1/2240 0 0;
                    3/56 1/2240 0;
                    1191/2240 3/56 1/2240]
    
    N[1:3,1:3] = [17/56 209/1120 1/560;
                209/1120 3/56 1/2240;
                1/560 1/2240 0]
    
    N[m-2:m,m-2:m] = [0 1/2240 1/560;
                    1/2240 3/56 209/1120;
                    1/560 209/1120 6/7]

    # LHS b so that x = ones(m,1)
    b[:] = A*ones(m,1)

end