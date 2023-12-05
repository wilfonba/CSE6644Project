function SMW(M, N, b, m, tol, maxIter)

    x = zeros(m,1)

    error = 1.0
    nIters = 0

    cc = fft(M)

    while error > tol && nIters <maxIter
        nIters += 1
        c = N*x + b
        xNew = real(fft(ifft(c)./cc))
        error = norm(xNew - x)
        x .= copy(xNew)
    end

    return x, nIters

end