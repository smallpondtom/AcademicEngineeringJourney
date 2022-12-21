import numpy as np

N = 10000
A = np.array([[1.01, 0.99],
              [0.99, 0.98]])
A_inv = np.linalg.inv(A)
e = np.random.randn(2, N)
error = np.dot(A_inv, e)
print(f"The mean-squared error = {np.mean(np.sum(error**2, axis=0))}")