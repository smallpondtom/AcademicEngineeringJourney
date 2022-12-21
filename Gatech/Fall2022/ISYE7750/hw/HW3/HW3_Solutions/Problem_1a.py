import numpy as np
from scipy.io import loadmat

data = loadmat('hw3p1_data.mat')
x = data['udata']
y = data['ydata'].ravel()
A = np.stack((x[0]**2, x[1]**2, x[0]*x[1], x[0], x[1], np.ones_like(x[0])), axis=1)
print(A)