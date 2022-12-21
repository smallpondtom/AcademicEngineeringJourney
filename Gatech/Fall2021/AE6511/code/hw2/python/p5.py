import numpy as np
import matplotlib.pyplot as plt
from sympy.solvers import solve
from sympy import Symbol

def g2(x):
    return -2 * x + 11

def g3(x):
    return 0.5 * x - 1

G2 = np.vectorize(g2)
G3 = np.vectorize(g3)

x = Symbol('x')
x1 = 0
x2 = solve(g2(x) - g3(x))

y1 = G2(0)
y2 = G3(0)
y3 = G2(x2)

xr = np.linspace(-1, 4, 100)
y2r = G2(xr)
y3r = G3(xr)

plt.plot(xr, y2r, '-k')
plt.plot(xr, y3r, '-k')
temp = np.linspace(-3, 15)
plt.plot(np.zeros(temp.shape), temp, '-k')

plt.plot(x1, y1, 'go', markersize=10)
plt.plot(x1, y2, 'go', markersize=10)
plt.plot(x2, y3, 'go', markersize=10)

plt.fill([x1, x1, *x2], [y1, y2, y3], 'red', alpha=0.5)
plt.xlim(-1, 4)
plt.ylim(-2.4, 14.5)
plt.grid(True)
plt.xlabel(r'$x_1$')
plt.ylabel(r'$x_2$')
plt.savefig('p5_region.png')
plt.show()