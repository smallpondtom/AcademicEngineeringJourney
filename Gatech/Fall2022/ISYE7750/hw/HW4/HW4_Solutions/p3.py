import numpy as np
import matplotlib.pyplot as plt

# define phi_k(t)
def phi(k, t, N):
    return np.exp(-100*(t - k/N)**2)

# define radial basis kernel
def kernel(s, t):
    return np.exp(-100*(s-t)**2)

fig, axs = plt.subplots(2, 3, figsize=(20, 10))
axs[0, 0].plot([k/10. for k in range(1, 10+1)], [phi(k, 1/3, 10) for k in range(1, 10+1)], marker='x')
axs[0, 0].set_title('N=10')

axs[0, 1].plot([k/20. for k in range(1, 20+1)], [phi(k, 1/3, 20) for k in range(1, 20+1)], marker='x')
axs[0, 1].set_title('N=20')

axs[0, 2].plot([k/50. for k in range(1, 50+1)], [phi(k, 1/3, 50) for k in range(1, 50+1)], marker='x')
axs[0, 2].set_title('N=50')

axs[1, 0].plot([k/100. for k in range(1, 100+1)], [phi(k, 1/3, 100) for k in range(1, 100+1)], marker='x')
axs[1, 0].set_title('N=100')

axs[1, 1].plot([k/200. for k in range(1, 200+1)], [phi(k, 1/3, 200) for k in range(1, 200+1)], marker='x')
axs[1, 1].set_title('N=200')

axs[1, 2].plot(np.linspace(0, 1, 1000), kernel(np.linspace(0, 1, 1000), 1/3), marker='x')
axs[1, 2].set_title('RBF')

    
fig.tight_layout()
plt.savefig('p3.png')
