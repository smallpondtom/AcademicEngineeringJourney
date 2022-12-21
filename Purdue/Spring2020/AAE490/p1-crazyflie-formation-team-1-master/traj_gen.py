import numpy as np
import matplotlib.pyplot as plt
from math import factorial as fact
import json

## Set-up (can be easily changed to adjust problem) ##
trajectories = 8  # total number of trajectory legs
num_BCs = 8  # number of boundary conditions
drones = 4
# Define IC's (or b matrix)
IC_x = np.zeros((drones, trajectories * num_BCs))
IC_y = np.zeros((drones, trajectories * num_BCs))
# IC Matrix: [p(0),p1(0),p'(0),p1'(0),p''(0),p1''(0),p'''(0),p1'''(0)]
## Drone 0
ICx0 = np.transpose([0,.5,0,.5,0,0,0,0]) ## Trajectory 0's ICs
ICx1 = np.transpose([.5,1,.5,0,0,0,0,0])
ICx2 = np.transpose([1,.5,0,-.5,0,0,0,0])
ICx3 = np.transpose([.5,0,-.5,0,0,0,0,0])
ICx4 = np.transpose([0,-.5,0,-.5,0,0,0,0])
ICx5 = np.transpose([-.5,-1,-.5,0,0,0,0,0])
ICx6 = np.transpose([-1,-.5,0,.5,0,0,0,0])
ICx7 = np.transpose([-.5,0,.5,0,0,0,0,0])
IC_x[0][:] = np.concatenate((ICx0,ICx1,ICx2,ICx3,ICx4,ICx5,ICx6,ICx7))

#-----------------y traj-------------------#
ICy0 = np.transpose([0,-.5,0,0,0,0,0,0]) ## Trajectory 0's ICs
ICy1 = np.transpose([-.5,0,0,.5,0,0,0,0])
ICy2 = np.transpose([0,.5,.5,0,0,0,0,0])
ICy3 = np.transpose([.5,0,0,-.5,0,0,0,0])
ICy4 = np.transpose([0,-.5,-.5,0,0,0,0,0])
ICy5 = np.transpose([-.5,0,0,.5,0,0,0,0])
ICy6 = np.transpose([0,.5,.5,0,0,0,0,0])
ICy7 = np.transpose([.5,0,0,0,0,0,0,0])
IC_y[0][:]  = np.concatenate((ICy0,ICy1,ICy2,ICy3,ICy4,ICy5,ICy6,ICy7))

## Drone 1
ICx0 = np.transpose([0,.5,0,0,0,0,0,0]) ## Trajectory 0's ICs
ICx1 = np.transpose([.5,0,0,-.5,0,0,0,0])
ICx2 = np.transpose([0,-.5,-.5,0,0,0,0,0])
ICx3 = np.transpose([-.5,-1,0,-.5,0,0,0,0])
ICx4 = np.transpose([-1,-1.5,-.5,0,0,0,0,0])
ICx5 = np.transpose([-1.5,-1,0,.5,0,0,0,0])
ICx6 = np.transpose([-1,-.5,.5,0,0,0,0,0])
ICx7 = np.transpose([-.5,0,0,0,0,0,0,0])
IC_x[1][:] = np.concatenate((ICx0,ICx1,ICx2,ICx3,ICx4,ICx5,ICx6,ICx7))

#-----------------y traj-------------------#
ICy0 = np.transpose([0,.5,0,.5,0,0,0,0]) ## Trajectory 0's ICs
ICy1 = np.transpose([.5,1,.5,0,0,0,0,0])
ICy2 = np.transpose([1,.5,0,-.5,0,0,0,0])
ICy3 = np.transpose([.5,0,-.5,0,0,0,0,0])
ICy4 = np.transpose([0,.5,0,.5,0,0,0,0])
ICy5 = np.transpose([.5,1,.5,0,0,0,0,0])
ICy6 = np.transpose([1,.5,0,-.5,0,0,0,0])
ICy7 = np.transpose([.5,0,-.5,0,0,0,0,0])
IC_y[1][:]  = np.concatenate((ICy0,ICy1,ICy2,ICy3,ICy4,ICy5,ICy6,ICy7))

## Drone 2
ICx0 = np.transpose([0,-.5,0,-.5,0,0,0,0]) ## Trajectory 0's ICs
ICx1 = np.transpose([-.5,-1,-.5,0,0,0,0,0])
ICx2 = np.transpose([-1,-1.5,0,-.5,0,0,0,0])
ICx3 = np.transpose([-1.5,-2,-.5,0,0,0,0,0])
ICx4 = np.transpose([-2,-1.5,0,.5,0,0,0,0])
ICx5 = np.transpose([-1.5,-1,.5,0,0,0,0,0])
ICx6 = np.transpose([-1,-.5,0,.5,0,0,0,0])
ICx7 = np.transpose([-.5,0,.5,0,0,0,0,0])
IC_x[2][:] = np.concatenate((ICx0,ICx1,ICx2,ICx3,ICx4,ICx5,ICx6,ICx7))

#-----------------y traj-------------------#
ICy0 = np.transpose([0,.5,0,0,0,0,0,0]) ## Trajectory 0's ICs
ICy1 = np.transpose([.5,0,0,-.5,0,0,0,0])
ICy2 = np.transpose([0,-.5,-.5,0,0,0,0,0])
ICy3 = np.transpose([-.5,0,0,.5,0,0,0,0])
ICy4 = np.transpose([0,.5,.5,0,0,0,0,0])
ICy5 = np.transpose([.5,0,0,-.5,0,0,0,0])
ICy6 = np.transpose([0,-.5,-.5,0,0,0,0,0])
ICy7 = np.transpose([-.5,0,0,0,0,0,0,0])
IC_y[2][:]  = np.concatenate((ICy0,ICy1,ICy2,ICy3,ICy4,ICy5,ICy6,ICy7))

## Drone 3
ICx0 = np.transpose([0,-.5,0,0,0,0,0,0]) ## Trajectory 0's ICs
ICx1 = np.transpose([-.5,-1,0,-.5,0,0,0,0])
ICx2 = np.transpose([-1,-1.5,-.5,0,0,0,0,0])
ICx3 = np.transpose([-1.5,-1,0,.5,0,0,0,0])
ICx4 = np.transpose([-1,-.5,.5,0,0,0,0,0])
ICx5 = np.transpose([-.5,0,0,.5,0,0,0,0])
ICx6 = np.transpose([0,.5,.5,0,0,0,0,0])
ICx7 = np.transpose([.5,0,0,0,0,0,0,0])
IC_x[3][:] = np.concatenate((ICx0,ICx1,ICx2,ICx3,ICx4,ICx5,ICx6,ICx7))

#-----------------y traj-------------------#
ICy0 = np.transpose([0,-.5,0,-.5,0,0,0,0]) ## Trajectory 0's ICs
ICy1 = np.transpose([-.5,-1,-.5,0,0,0,0,0])
ICy2 = np.transpose([-1,-.5,0,.5,0,0,0,0])
ICy3 = np.transpose([-.5,0,.5,0,0,0,0,0])
ICy4 = np.transpose([0,-.5,0,-.5,0,0,0,0])
ICy5 = np.transpose([-.5,-1,-.5,0,0,0,0,0])
ICy6 = np.transpose([-1,-.5,0,.5,0,0,0,0])
ICy7 = np.transpose([-.5,0,.5,0,0,0,0,0])
IC_y[3][:]  = np.concatenate((ICy0,ICy1,ICy2,ICy3,ICy4,ICy5,ICy6,ICy7))

coeffs_x = np.zeros((drones, trajectories, trajectories))  # matrix to store solved coefficients
coeffs_y = np.zeros((drones, trajectories, trajectories))
A = np.zeros((8, 8))
for k in range(4):  # order of derivative
    for t in range(2):  # Time values are zero and 1 for every leg of the trajectory
        for i in range(k, 8):  # order of coefficient
            A[2 * k + t][i] = fact(i) / (fact(i - k)) * t ** (i - k)

# coeffs[rows: trajectory][columns: coeffs for column# term in polynomial]
for drone_num in range(drones):
    for leg in range(trajectories):
        c_x = np.linalg.inv(A).dot(IC_x[drone_num][leg * 8:leg * 8 + 8])
        c_y = np.linalg.inv(A).dot(IC_y[drone_num][leg * 8:leg * 8 + 8])

        for j in range(trajectories):
            coeffs_x[drone_num][leg][j] = c_x[j]
            coeffs_y[drone_num][leg][j] = c_y[j]

    T = np.linspace(0, 1)
    for leg in range(trajectories):
        x = 0
        y = 0
        for i in range(8):
            x += coeffs_x[drone_num][leg][i] * T ** i
            y += coeffs_y[drone_num][leg][i] * T ** i
        plt.figure(drone_num + 1)
        plt.plot(x, y)
        #plt.show()

    ## Create crazyflie data format
crazyflie_data = np.zeros((drones, trajectories, 34))

for drone_num in range(drones):
    for leg in range(trajectories):
        crazyflie_data[drone_num][leg][0] = 1
        for i in range(1, 9):
            crazyflie_data[drone_num][leg][i] = coeffs_x[drone_num][leg][i - 1]
            crazyflie_data[drone_num][leg][i + 8] = coeffs_y[drone_num][leg][i - 1]

data_dict = {
    'radio://0/100/250K/E7E7E7E703': {
        'trajectory_id': 0,
        'trajectory': crazyflie_data[0][:][:].tolist(),
        'duration': 1
    },

    'radio://0/100/250K/E7E7E7E705': {
        'trajectory_id': 1,
        'trajectory': crazyflie_data[1][:][:].tolist(),
        'duration': 1
    },

    'radio://0/100/250K/E7E7E7E708': {
        'trajectory_id': 2,
        'trajectory': crazyflie_data[2][:][:].tolist(),
        'duration': 1
    },

    'radio://0/100/250K/E7E7E7E709': {
        'trajectory_id': 3,
        'trajectory': crazyflie_data[3][:][:].tolist(),
        'duration': 1
    }

}

with open('data_dict.json', 'w') as f:
    json.dump(data_dict, f, indent=True)
