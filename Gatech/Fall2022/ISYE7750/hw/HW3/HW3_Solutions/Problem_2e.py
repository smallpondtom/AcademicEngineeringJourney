import numpy as np
import matplotlib.pyplot as plt
from scipy.io import loadmat

data = loadmat('hw3p1_data.mat')
x = data['udata']
y = data['ydata'].ravel()
A = np.stack((x[0]**2, x[1]**2, x[0]*x[1], x[0], x[1], np.ones_like(x[0])), axis=1)
ATA = A.T @ A
ATy = A.T @ y
Q = np.array([
    [4/3, 0, 1/2, 1, 0, 0],
    [0, 4/3, 1/2, 0, 1, 0],
    [1/2, 1/2, 2/3, 1/2, 1/2, 0],
    [1, 0, 1/2, 1, 0, 0],
    [0, 1, 1/2, 0, 1, 0],
    [0, 0, 0, 0, 0, 0],
])

s = np.linspace(0, 1, 1024)
s, t = np.meshgrid(s, s)
basis = np.stack((s**2, t**2, s*t, s, t, np.ones_like(s)), axis=-1)
for i, delta in enumerate([
    1e-4,
    np.sqrt(np.sum(ATA**2)/np.sum(Q**2)),
    1e4
]):
    print('Results for delta={}'.format(delta))
    alpha = np.linalg.inv(ATA + (delta * Q)) @ ATy
    print('alpha:')
    print(alpha.reshape(-1, 1))
    f = np.sum(basis * alpha, axis=-1)
    plt.figure()
    plt.contour(s, t, f, levels=50)
    plt.colorbar()
    plt.title('Contour for delta={}'.format(delta))
    plt.savefig('p2e_delta_{}.png'.format(i))
    plt.show()