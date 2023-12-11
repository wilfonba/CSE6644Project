import numpy as np
from typing import Tuple
import scipy.linalg as spl

def get_N(A, c):
    return spl.circulant(c)-A

def circ_first_col(A: np.ndarray) -> np.ndarray:
    c = A[:,0]
    return c

def circ_base_norm(A, omega = 1) -> np.ndarray:
    n = len(A)
    Q = np.diag(np.ones(n-1), 1) + np.diag(np.ones(1), 1-n)
    d = [1/omega * np.trace(A.T @ np.linalg.matrix_power(Q,i))/n for i in range(1, n+1)]
    c = [d[(i-1) % n] for i in range(n)]
    return np.asarray(c)

def circ_max(A) -> np.ndarray:
    n = len(A)
    Q = np.diag(np.ones(n-1), 1) + np.diag(np.ones(1), 1-n)
    d = [np.max(np.diag(A.T @ np.linalg.matrix_power(Q,i))) for i in range(1, n+1)]
    c = [d[(i-1) % n] for i in range(n)]
    return np.asarray(c)

def circ_min(A) -> np.ndarray:
    n = len(A)
    Q = np.diag(np.ones(n-1), 1) + np.diag(np.ones(1), 1-n)
    d = [np.min(np.diag(A.T @ np.linalg.matrix_power(Q,i))) for i in range(1, n+1)]
    c = [d[(i-1) % n] for i in range(n)]
    return np.asarray(c)

# def circ_max_min(A) -> np.ndarray:
#     n = len(A)
#     Q = np.diag(np.ones(n-1), 1) + np.diag(np.ones(1), 1-n)
#     d = [np.min(np.diag(A.T @ np.linalg.matrix_power(Q,i))) for i in range(1, n)]
#     d.append(np.max(np.diag(A)))
#     # c = [d[(i-1) % n] for i in range(n)]
#     return d

# MTX_SPLITTING_FUNCS = [circ_first_col, circ_base_norm, circ_base_norm, circ_max, circ_min]
