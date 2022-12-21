import numpy as np
import matplotlib.pyplot as plt
import scipy.integrate as integrate
from scipy import linalg


# define the classic bell-curve bump function
def phi(t):
    return np.exp(-t ** 2)


# define the basis function phi_k given k and N
def phi_k(t, k, N):
    return phi(N * t - k + 0.5)


# construct Gram matrix for s given N
def Gram_matrix(N):
    G = np.zeros((N, N))
    for i in range(N):
        for j in range(i, N):
            integrand = lambda t: phi_k(t, i + 1, N) * phi_k(t, j + 1, N)
            integral = integrate.quad(integrand, 0, 1)[0]
            G[i, j] = integral
            G[j, i] = integral
    return G


# create an image of the kernel k(s,t)
N = 10
G = Gram_matrix(N)
H = linalg.inv(G)
s = np.linspace(0, 1, 100)
t = np.linspace(0, 1, 100)
k_s_t = np.zeros((100, 100))
for idx in range(100):
    for n in range(1, N + 1):
        y = np.zeros(100)
        for k in range(1, N + 1):
            y += H[n - 1, k - 1] * phi_k(t, k, N)
        k_s_t[idx, :] += phi_k(s[idx], n, N) * y

plt.imshow(k_s_t)
plt.xlabel('t')
plt.ylabel('s')
plt.colorbar()
plt.savefig('p1c.png')