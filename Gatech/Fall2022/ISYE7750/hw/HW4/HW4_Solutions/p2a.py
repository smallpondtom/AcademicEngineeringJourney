import numpy as np
import matplotlib.pyplot as plt
import scipy.io as sio
from numpy import linalg as LA

data = sio.loadmat('hw04p2_data.mat')
M = data['M'][0,0]
T = data['T'][:,0]  # shape=(10,)
y = data['y'][:,0]  # shape=(10,)

# create f_true
def f_true(t):
    return np.sin(12*(t+0.2))/(t+0.2)

# creat the kernel
def kernel(s,t, sigma):
    return  np.exp(-(t-s)**2/(2*sigma**2))

# create K matrix
def K_matrix(T, sigma):
    K = np.zeros((T.shape[0], T.shape[0]))
    for i in range(T.shape[0]):
        for j in range(T.shape[0]):
            K[i,j] = kernel(T[i], T[j], sigma)

    return K


sigma = 0.1
delta = 0.004
K = K_matrix(T, sigma)
alpha = np.linalg.solve(K + delta * np.identity(T.shape[0]), y)

fig, ax = plt.subplots()
t = np.linspace(0, 1, 1000)
y_true = f_true(t)
y_hat = np.zeros(1000)
for m in range(T.shape[0]):
    y_hat += alpha[m] * kernel(T[m], t, sigma)

ax.plot(t, y_true, label=r"$f_{true}(t)$")
ax.plot(t, y_hat, label=r"$\hat{f}(t)$")
ax.scatter(T, y, marker='o', color='red', label='data points')
ax.set(xlabel="t")
ax.legend()
fig.tight_layout()
plt.savefig('p2a.png')

# compute the sample error
y_sample_hat = np.zeros(T.shape[0])
for m in range(T.shape[0]):
    y_sample_hat += alpha[m] * kernel(T[m], T, sigma)
sample_error = LA.norm(y-y_sample_hat, 2)
print(f"The sample error = {sample_error} when delta = {sigma}")

# compute the generalization error
integrand = (y_true - y_hat)**2
generalization_error = np.sqrt(np.trapz(integrand, x=t))
print(f"The generalization error = {generalization_error}  when delta = {sigma}")

