import matplotlib.pyplot as plt
import numpy as np


y = np.linspace(-3, 3, 100)
z = np.linspace(-3, 3, 100)

Y, Z = np.meshgrid(y, z)

def f(a, b):
    return (b - a**2) * (b - 2 * a**2)

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(Y, Z, f(Y, Z), rstride=1, cstride=1,
                edgecolor='none')
ax.set_xlabel('y')
ax.set_ylabel('z')
plt.show()
