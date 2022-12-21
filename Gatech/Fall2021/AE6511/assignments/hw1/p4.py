import matplotlib.pyplot as plt
import numpy as np


y = np.linspace(0, 50, 100)
z = np.linspace(0, 50, 100)

Y, Z = np.meshgrid(y, z)

def f(a, b):
    return a**3 + b**3

fig = plt.figure()
ax = plt.axes(projection='3d')
ax.plot_surface(Y, Z, f(Y, Z), rstride=1, cstride=1,
                edgecolor='none', cmap='viridis')
ax.plot(0, 0, '.r', markersize=25)
ax.set_xlabel('y')
ax.set_ylabel('z')
plt.show()
