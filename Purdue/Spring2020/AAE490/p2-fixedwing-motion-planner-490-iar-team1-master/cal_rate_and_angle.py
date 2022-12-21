#!\usr\bin\env python3
"""
Fixed Wing Motion Planner Project
>> Description: Path smoothing file of path planning with obstacles implementing
                Rapidly-Exploring Random Trees (RRT).

>> Team 1: Hanyao Hu
           Tomoki Koike
           Herschel Meadow
           Luke Ritchison

Purdue University, West Lafayette, IN
School of Engineering, Aeronautical and Astronautical Engineering, AAE 49000iar
"""

import numpy as np
import math

class cal_rate_and_angle:
    """
    Class to compute the roll rate and bank angle
    """
    def __init__(self, path, velocity):
        self.path = path
        self.velocity = velocity
        self.roll_rate = []
        self.bank_angle = []
        self.g = 9.81

    @property
    def cal_angle_and_rate(self):
        for i in range(len(self.path)-2):
            x1 = self.path[i][0]
            y1 = self.path[i][1]
            x2 = self.path[i+1][0]
            y2 = self.path[i+1][1]
            x3 = self.path[i+2][0]
            y3 = self.path[i+2][1]

            # Deltas
            dx = x2 - x1
            dy = y2 - y1

            # Double Deltas
            x123 = np.array([x1, x2, x3])
            y123 = np.array([y1, y2, y3])
            ddx123 = np.gradient(x123)
            ddy123 = np.gradient(y123)
            ddx1 = ddx123[0]
            ddy1 = ddy123[0]

            # Yaw angles and yaw rate
            psi = math.atan(dy/dx)
            dpsi_dx = -dy / (dx ** 2 + dy ** 2) * ddx1
            dpsi_dy = dx / (dx ** 2 + dy ** 2) * ddy1
            dot_psi = dpsi_dx*self.velocity*math.cos(psi) + dpsi_dy*self.velocity*math.sin(psi)

            # Dot x and Dot y
            dot_x = self.velocity * math.cos(psi)
            dot_y = self.velocity * math.sin(psi)

            # Bank angle/Roll angle
            phi = math.atan(self.velocity * dot_psi / self.g)
            self.bank_angle.append(np.rad2deg(phi))

        # Roll rate
        phi_np = np.array(self.bank_angle)
        dphi = np.gradient(phi_np)
        self.roll_rate = dphi

        self.roll_rate = np.flip(self.roll_rate)
        self.bank_angle.reverse()
        return self.roll_rate, self.bank_angle
