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


# plot k_tau(t)
t = np.linspace(0, 1, 1000)
N = 10
G = Gram_matrix(N)
H = linalg.inv(G)
tau = 0.371238
k_tau = np.zeros(1000)
for n in range(1, N+1):
    y = np.zeros(1000)
    for k in range(1, N + 1):
        y += H[n - 1, k - 1] * phi_k(t, k, N)
    k_tau += phi_k(tau, n, N) * y

fig, ax = plt.subplots()
ax.plot(t, k_tau)
ax.set(xlabel="t", ylabel=r'$k_{\tau}(t)$')
fig.tight_layout()
plt.savefig('p1b.png')

# verify that <f, k_tau> = f(tau)
alpha = np.random.randn(N)
print(f"alpha = {alpha}")
f_tau = 0
for k in range(1, N+1):
    f_tau += alpha[k-1] * phi_k(tau, k, N)
print(f"f(tau) = {f_tau}")

ft = np.zeros(1000)
for k in range(1, N+1):
    ft += alpha[k-1] * phi_k(t, k, N)

f_k_tau = np.trapz(ft*k_tau, x=t)
print(f"<f, k_tau> = {f_k_tau}")