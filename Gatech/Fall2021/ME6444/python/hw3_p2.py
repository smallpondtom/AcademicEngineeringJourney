import matplotlib.pyplot as plt
import numpy as np
from scipy.integrate import solve_ivp, DOP853

# Defining parameters
params = {
    'rho': 500,
    'A': 0.0001,
    'l': 10,
    'T0': 1500,
    'E1': 2.5e+6,
    'E2': 0.5e+6,
    'alpha': 1.2e+6
}

# System ODE
# x0 : beta1
# x1 : beta1_dot
# x2 : beta2
# x3 : beta2_dot
def nonlinear_string_ode(t, x, rho, A, l, T0, E1, E2, alpha):
    c11 = alpha*A/l**3 * (36.5284*x[0]**2 + 97.4091*x[2]**2)*x[1] 
    c12 = 194.8182*alpha*A/l**3 * x[0] * x[2] * x[3]
    c13 = 4.9348*T0/l * x[0]
    c14 = E1*A/l**3 * x[0] * (18.2642 * x[0]**2 + 146.1136 * x[2]**2)
    c15 = E2*A/l**5 * x[0] * (75.1085 * x[0]**4 + 2.1030e+3 * x[0]**2 * x[2]**2 + 3.6052e+3 * x[2]**4)
    beta1ddot = -2/rho/A/l * (c11 + c12 + c13 + c14 + c15)
    
    c21 = alpha*A/l**3 * (97.4091*x[0]**2 + 584.4545*x[2]**2)*x[3] 
    c22 = 194.8182*alpha*A/l**3 * x[0] * x[2] * x[1]
    c23 = 19.7392*T0/l * x[0]
    c24 = E1*A/l**3 * x[2] * (146.1136 * x[0]**2 + 292.2273 * x[2]**2)
    c25 = E2*A/l**5 * x[2] * (1.0515e+3 * x[0]**4 + 7.2104e+3 * x[0]**2 * x[2]**2 + 4.8069e+3 * x[2]**4)
    beta2ddot = -2/rho/A/l * (c21 + c22 + c23 + c24 + c25)
    
    return [x[1], beta1ddot, x[3], beta2ddot]
    
    
def solve_diffeq(func, t, tspan, ic, parameters={}, algorithm='DOP853', stepsize=np.inf):
    return solve_ivp(fun=func, t_span=tspan, t_eval=t, y0=ic, method=algorithm, 
                     args=tuple(parameters.values()), atol=1e-8, rtol=1e-5, max_step=stepsize)


def phasePlane(x1, x2, x3, x4, func, parameters):
    X1, X2 = np.meshgrid(x1, x2)  # create grid
    X3, X4 = np.meshgrid(x3, x4)  # create grid
    
    u1, v1 = np.zeros(X1.shape), np.zeros(X2.shape)
    u2, v2 = np.zeros(X3.shape), np.zeros(X4.shape)
    
    NI, NJ = X1.shape
    for i in range(NI):
        for j in range(NJ):
            x = X1[i, j]
            y = X2[i, j]
            xx = X3[i, j]
            yy = X4[i, j]
            dx = func(0, (x, y, xx, yy), *parameters.values())  # compute values on grid
            u1[i, j] = dx[0]
            v1[i, j] = dx[1]
            
            u2[i, j] = dx[2]
            v2[i, j] = dx[3]
    M1 = np.hypot(u1, v1)
    u1 /= M1
    v1 /= M1
    
    M2 = np.hypot(u2, v2)
    u2 /= M2
    v2 /= M2
    return X1, X2, u1, v1, M1, u2, v2, M2

# x0 = np.random.uniform(-20, 20, (1,4))
x0 = [
    [-9.75191938, -2.91119727, -7.59715504, -2.7920785 ],
    [8.03450823, -17.2739244,   -5.20571273,  -6.70185079],
    [-17.37872695,  18.30880768,   1.79869491,   6.2961463 ],
    [ 6.72887358,  2.64431655, -7.31783452,  3.42364048]
]

x1, x2 = np.meshgrid(np.linspace(-20, 20, 20), np.linspace(-170, 170, 20))
x3, x4 = np.meshgrid(np.linspace(-30, 30, 20), np.linspace(-100, 100, 20))

# Set up the figure the way we want it to look
fig, ax = plt.subplots(2, 2, figsize=(11, 9), constrained_layout=True)

# Phase plane
b1, b1d, b2, b2d = nonlinear_string_ode(2, [x1, x2, x3, x4], *params.values())

m1 = np.hypot(b1, b1d)
m2 = np.hypot(b2, b2d)

i = 0
t1 = np.linspace(0, 200, 100000)
t_span1 = (np.min(t1), np.max(t1))
for x0i in x0:
    ax[i//2, i%2].quiver(x1, x2, b1/m1, b1d/m1, m1, scale=None, pivot='mid')
    sol1 = solve_diffeq(nonlinear_string_ode, t1, t_span1, x0i, params)
    ax[i//2, i%2].plot(sol1.y[0, :], sol1.y[1, :], '-')
    ax[i//2, i%2].plot(0, 0, '.r', ms=15)
    ax[i//2, i%2].set_title(r'$x_0$='+str(x0i))
    i+=1

fig.supxlabel(r'$\beta_1$')
fig.supylabel(r'$\dot{\beta}_1$')
plt.savefig('../plots/nl_string_mode1_phase.png')
plt.show()    

fig, ax = plt.subplots(2, 2, figsize=(11, 9), constrained_layout=True)
i = 0
t1 = np.linspace(0, 200, 100000)
t_span1 = (np.min(t1), np.max(t1))
for x0i in x0:
    ax[i//2, i%2].quiver(x3, x4, b2/m2, b2d/m2, m2, scale=None, pivot='mid')
    sol1 = solve_diffeq(nonlinear_string_ode, t1, t_span1, x0i, params)
    ax[i//2, i%2].plot(sol1.y[2, :], sol1.y[3, :], '-')
    ax[i//2, i%2].plot(0, 0, '.r', ms=15)
    ax[i//2, i%2].set_title(r'$x_0$='+str(x0i))
    i+=1

fig.supxlabel(r'$\beta_2$')
fig.supylabel(r'$\dot{\beta}_2$')
plt.savefig('../plots/nl_string_mode2_phase.png')
plt.show()    