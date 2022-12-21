from control import step_info
import numpy as np
import matplotlib.pyplot as plt

data = np.loadtxt('temperatureData.csv')

N = len(data)
T = np.arange(N)

fig = plt.figure()
plt.rcParams['figure.figsize'] = (12, 8)
plt.plot(T, np.mean(data[0:33])*np.ones(N), '--')
plt.plot(T, np.mean(data[42:50])*np.ones(N), '--')
plt.scatter(T, data)
plt.xlabel(r'$t$')
plt.ylabel(r'$\degree F$')
plt.savefig('temperature_response.png')
sysinfo = step_info(data, T)

'''
sysinfo = {'RiseTime': 33,
 'SettlingTime': 71,
 'SettlingMin': 80.058655,
 'SettlingMax': 93.841644,
 'Overshoot': 5.610559466414027,
 'Undershoot': 88.11880637669529,
 'Peak': 93.841644,
 'PeakTime': 63,
 'SteadyStateValue': 88.856308}
'''