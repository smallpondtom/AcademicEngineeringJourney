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


# plot y(t)
t = np.linspace(0, 1, 1000)
N = 10
G = Gram_matrix(N)
H = linalg.inv(G)
fig, ax = plt.subplots()
for i in range(1, N+1):
    y = np.zeros(1000)
    for k in range(1, N+1):
        y += H[i-1, k-1] * phi_k(t, k, N)
    ax.plot(t, y)
    ax.set(xlabel="t")
    ax.set_title(r'$\tilde{\phi}_{%d}$' % i)
    fig.tight_layout()
    plt.savefig('p1_n_{}.png'.format(i))
    plt.cla()