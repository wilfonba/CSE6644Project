import unittest
import numpy as np
import scipy.linalg as spl
from matrix_splitting import get_N, circ_first_col, circ_base_norm, circ_max, circ_min, circ_max_min

class TestCirculantMatrixOperations(unittest.TestCase):

    def setUp(self):
        self.A = np.array([[1, 2, 3], 
                           [4, 5, 6], 
                           [7, 8, 9]])

    def test_get_N(self):
        c = np.array([1, 2, 3])
        
        expected = np.array([[0,-1,1],
                             [2,4,3],
                             [4,6,8]])
        np.testing.assert_array_equal(get_N(self.A, c), expected)

# array([[1, 3, 2],
#        [2, 1, 3],
#        [3, 2, 1]])
    def test_circ_first_col(self):
        c = circ_first_col(self.A)
        N = get_N(self.A,c)
        expected_c = np.array([1,4,7])
        expected_N = np.array([[0,-5,-1],
                               [0,4,-1],
                               [0,4,8]])
        np.testing.assert_array_equal(c, expected_c)
        np.testing.assert_array_equal(N, expected_N)

    def test_circ_base_norm(self):
        c = circ_base_norm(self.A)
        # Add specific tests for circ_base_norm

    def test_circ_max(self):
        c = circ_max(self.A)
        # Add specific tests for circ_max

    def test_circ_min(self):
        c = circ_min(self.A)
        # Add specific tests for circ_min

    def test_circ_max_min(self):
        d = circ_max_min(self.A)
        # Add specific tests for circ_max_min

    # Additional tests for edge cases and invalid inputs can be added here

if __name__ == '__main__':
    unittest.main()
