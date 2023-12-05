import numpy as np

def nonnegative_matrices(n, size=(100, 100)):
    out = np.zeros((n, *size))
    for i in range(n):
        out[i] = np.random.rand(*size)
    return out

def positive_matrices(n, size=(100, 100)):
    out = np.zeros((n, *size))
    for i in range(n):
        out[i] = 1 + np.random.rand(*size)
    return out

def random_distribution_matrices(n, size=(100, 100)):
    out = np.zeros((n, *size))
    for i in range(n):
        out[i] = np.random.uniform(-1, 1, size)
    return out

def symmetric_matrices(n, size=(100, 100)):
    out = np.zeros((n, *size))
    for i in range(n):
        b = np.random.rand(*size)
        out[i] = b+b.T/2
    return out

def spd_matrices(n, size=(100, 100)):
    out = np.zeros((n, *size))
    rdm = random_distribution_matrices(n, size)
    for i in range(n):
        out[i] = np.dot(rdm[i], rdm[i].T)
    return out


# def specific_spectrum_matrices(n, size=(100, 100)):
#     pass  # Placeholder 

# def sparsity_pattern_matrices(n, size=(100, 100)):
#     pass # Placeholder

# Generating and saving the matrices
out = []
n_matrices = 1000
size = (100,100)
for func in [nonnegative_matrices, positive_matrices, random_distribution_matrices, symmetric_matrices, spd_matrices]:
    matrices = func(n_matrices, size)
    filename = f"{func.__name__}.npy"
    np.save(f'matrices/{filename}', matrices)
