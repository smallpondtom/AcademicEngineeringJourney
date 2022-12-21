import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

data = loadmat('hw3p1_data.mat')
x = data['udata']
y = data['ydata'].ravel()
A = np.stack((x[0]**2, x[1]**2, x[0]*x[1], x[0], x[1], np.ones_like(x[0])), axis=1)
alpha = np.linalg.inv(A.T @ A) @ A.T @ y

s = np.linspace(0, 1, 1024)
s, t = np.meshgrid(s, s)
basis = np.stack((s**2, t**2, s*t, s, t, np.ones_like(s)), axis=-1)
f = np.sum(basis * alpha, axis=-1)
plt.contour(s, t, f, levels=50)
plt.colorbar()
plt.savefig('p1c.png')
plt.show()