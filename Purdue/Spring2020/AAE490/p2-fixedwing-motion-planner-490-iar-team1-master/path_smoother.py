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

### THIS FILE DOES NOT WORK NEED IMPROVEMENT IN ALGOIRHTM ###
# This file tries 2 methods
# Method 1: Trajectory planning with f(t) = a0 + a1*x(t) + a2*(x(t))^2 + ...
#           polynomial generation.
# Method 2: Curvature for each juxtaposed points filtered with maximum angle constraint. The
#           theory for this is described more in detail in a separate folder.
#

# Import modules
import numpy as np
import math
from scipy.optimize import fsolve

class SmoothPath:
    """
    Class to smooth the optimal path along with the angle constraints
    """

    def __init__(self, path, obstacles, max_angle, start, goal, velocity):
        self.path = path
        self.theta = None
        self.obstacles = obstacles
        self.max_angle = max_angle
        self.start = start
        self.goal = goal
        self.velocity = velocity
        self.new_path = []

    def path_smooth(self):
        """
        Function to smooth the path
        :return: The smooth path
        """
        self.new_path = self.path

        path_angles = self.calc_all_angles(self.new_path)
        for i in range(1, len(self.path)-2):
            if i == 1:  # Ignore the first index
                continue
            elif path_angles[i] > self.max_angle:
                xy_c, r = self.solve_curvature_center_and_radius(self.path[i-1],
                                                                 self.path[i],
                                                                 self.path[i+1])
                self.generate_xy_from_curvature(xy_c, r, i)


        for i in range(1, len(self.new_path)-1):  # First smooth based on line segment length
            distances = self.calc_all_dist(self.new_path)
            if i == 1:  # Ignore the first index
                continue
            elif i+1 == len(distances) or i == len(distances):
                break
            if distances[i] > 1:
                self.new_path.pop(i+1)  # Delete the insufficient point

        # Final check for obstacles
        for node_idx, node in enumerate(self.new_path):
            dist, idx = self.closest_obstacle(node)
            if dist <= self.obstacles[idx][2]:
                self.new_path.pop(node_idx)

        golden_path = self.new_path

        return golden_path

        #
        # for i in range(1, len(new_path)-1):  # First smooth based on line segment to obstacle distance
        #     line_obstacle_distances = self.line_and_obstacle_distance(new_path)
        #     if i == 1:  # Ignore the first index
        #         continue
        #     elif i+1 == len(line_obstacle_distances) or i == len(line_obstacle_distances):
        #         break
        #     if line_obstacle_distances[i-1] > 1.2 and line_obstacle_distances[i+1] > 1.2:
        #         new_path.pop(i-1)  # Delete the insufficient points
        #         new_path.pop(i+1)
        #         mid1 = self.calc_mid_point(new_path[i-2], new_path[i-1])
        #         mid2 = self.calc_mid_point(new_path[i-1], new_path[i])
        #         new_path.insert(i-1, mid1)  # Replacing the popped nodes with better mid point nodes
        #         new_path.insert(i+1, mid2)
        #
        #         # Check obstacles
        #         for node_idx, node in enumerate(new_path[i-1:i+1]):
        #             dist, idx = self.closest_obstacle(node)
        #             if dist <= self.obstacles[idx][2]:
        #                 new_path.pop(node_idx)
        #
        #
        # for i in range(1, len(new_path)-1):  # Second smooth based on angles
        #     path_angles = self.calc_all_angles(new_path)
        #     if i == 1:  # Ignore the first index
        #         continue
        #     elif i+1 == len(path_angles) or i == len(path_angles):
        #         break
        #     if path_angles[i] > self.max_angle:
        #         mid = self.calc_mid_point(new_path[i-1], new_path[i+1])
        #         new_path.pop(i)
        #         new_path.insert(i, mid)
        #
        #         # Check obstacles
        #         for node_idx, node in enumerate(new_path[i-1:i+1]):
        #             dist, idx = self.closest_obstacle(node)
        #             if dist <= self.obstacles[idx][2]:
        #                 new_path.pop(node_idx)
        #
        # # golden_path = self.trajectory_generation(new_path)
        # golden_path = new_path
        # # Final check for obstacles
        # for node_idx, node in enumerate(golden_path):
        #     dist, idx = self.closest_obstacle(node)
        #     if dist <= self.obstacles[idx][2]:
        #         golden_path.pop(node_idx)
        #
        # if golden_path[-1] != self.start:
        #     golden_path = golden_path + [self.start]
        # print(golden_path)
        # return golden_path


    def generate_xy_from_curvature(self, xy_center, radius, idx):
        """
        Function that generates new points from curvatures
        :param xy_center: Center of curvature [x, y]
        :param radius: Radius of curvature
        :param idx: Current index in loop
        :return: None
        """
        x_center = xy_center[0]
        y_center = xy_center[1]
        theta1 = math.acos((self.path[idx-1][0] - x_center)/radius)
        theta2 = math.acos((self.path[idx][0] - x_center)/radius)
        theta3 = math.acos((self.path[idx+1][0] - x_center)/radius)

        theta_span1 = np.linspace(theta1+0.001, theta2-0.001, 10)
        theta_span2 = np.linspace(theta2+0.001, theta3-0.001, 10)

        xy_new1 = np.empty([len(theta_span1), 2])
        xy_new2 = np.empty([len(theta_span2), 2])
        xy_new1[:, 0] = radius*np.cos(theta_span1) + x_center
        xy_new1[:, 1] = radius*np.sin(theta_span1) + y_center
        xy_new2[:, 0] = radius * np.cos(theta_span2) + x_center
        xy_new2[:, 1] = radius * np.sin(theta_span2) + y_center

        # Convert to list
        xy_new1 = xy_new1.tolist()
        xy_new2 = xy_new2.tolist()

        idx_new_path = self.new_path.index(self.path[idx])
        # Insert the new points
        for node in xy_new2[::-1]:
            self.new_path.insert(idx_new_path+1, node)
        for node in xy_new1[::-1]:
            self.new_path.insert(idx_new_path-1, node)
        idx_new_path = self.new_path.index(self.path[idx])
        self.new_path.pop(idx_new_path)
        return

    def trajectory_generation(self, new_path):
        """
        Function to generate trajectory for 6th order polynomial
        :param new_path: The new modified path
        :return: New path [[x,y],...]
        """

        distances = self.calc_all_dist(new_path)
        distances.insert(0,0)
        path_times = np.array(distances)/self.velocity
        path_t_elapse = np.cumsum(path_times)

        div = len(new_path) // 6

        golden_path = []
        counter = 0
        for i in range(0, len(new_path), 6):
            if counter == 0:
                # X-values
                X = np.array([x for (x, y) in new_path[0:6]])
                X = np.concatenate((X, [0]))
                X = np.transpose(X)
                # Y-values
                Y = np.array([y for (x, y) in new_path[0:6]])
                Y = np.concatenate((Y, [0]))
                Y = np.transpose(Y)
                matA = self.trajectory_Array_generation(path_t_elapse[0:6])
                start_time = path_t_elapse[0]
                end_time = path_t_elapse[6]
            else:
                # X-values
                X = np.array([x for (x, y) in new_path[i-counter:(i-counter+6)]])
                X = np.concatenate((X, [0]))
                X = np.transpose(X)
                # Y-values
                Y = np.array([y for (x, y) in new_path[i-counter:(i-counter+6)]])
                Y = np.concatenate((Y, [0]))
                Y = np.transpose(Y)
                matA = self.trajectory_Array_generation(path_t_elapse[i-counter:(i-counter+6)])
                start_time = path_t_elapse[i-counter]
                end_time = path_t_elapse[(i-counter+6)]

            if i != div:
                counter += 1
                x_coeffs = np.matmul(np.linalg.inv(matA), X)
                y_coeffs = np.matmul(np.linalg.inv(matA), Y)

                new_nodes = self.gen_new_traj_nodes(x_coeffs, y_coeffs, start_time, end_time)
                golden_path += new_nodes
            else:
                golden_path += new_path[6*div:-1]
        return golden_path

    def closest_obstacle(self, node):
        """
        Function to find the closest obstacle
        :param node: The provided node
        :return: Distance of the closest circle and the index of the circle
        """

        distances = []
        for (x_center, y_center, radius) in self.obstacles:
            x_distance = x_center - node[0]
            y_distance = y_center - node[1]
            distances.append(math.sqrt(x_distance**2 + y_distance**2))

        return min(distances), distances.index(min(distances))

    def line_and_obstacle_distance(self, path):
        """
        Function that calculates the distance of each line segment of path to the closest obstacle
        :param path: The path list of nodes
        :return: Array with all the distances
        """

        dist_list = []
        for i in range(len(path)-1):
            node1 = path[i+1]
            node2 = path[i]
            x = [node1[0], node2[0]]
            y = [node1[1], node2[1]]

            # Closest circle
            x_mean = np.mean(x)
            y_mean = np.mean(y)
            _, closest_obstacle_index = self.closest_obstacle([x_mean, y_mean])
            closest_obstacle = self.obstacles[closest_obstacle_index]

            fit_parameters = np.polyfit(x, y, 1)
            slope = fit_parameters[0]
            y_intersect = fit_parameters[1]

            dx_sqr = (x[0] - x[1])**2
            dy_sqr = (y[0] - y[1])**2
            dist = abs(slope*closest_obstacle[0] - closest_obstacle[1] + y_intersect)/math.sqrt(dx_sqr + dy_sqr)
            dist_list.append(dist)

        return dist_list

    def solve_curvature_center_and_radius(self, node1, node2, node3):
        """
        Function that solves fsolve and calculates the center and radius of curvature
        :param node1: The (i-1)th node
        :param node2: The (i)th node
        :param node3: The (i+1)th node
        :return: The center and radius of curvature
        """

        res = fsolve(self.juxtapose_pts_curvature, np.array([0, 0]), args=(node1, node2, node3))
        x_center = res[0]
        y_center = res[1]
        curve_radius = math.sqrt((node3[0] - x_center)**2 + (node3[1] - y_center)**2)
        return res, curve_radius

    @ staticmethod
    def juxtapose_pts_curvature(z, node1, node2, node3):
        """
        Function with nonlinear system equations for the curvature center
        :param z: The xy-position of the center of the curvature to solve for
        :param node1: The (i-1)th node
        :param node2: The (i)th node
        :param node3: The (i+1)th node
        :return: Return the nonlinear system equations
        """

        x_center = z[0]
        y_center = z[1]
        x1 = node1[0]
        x2 = node2[0]
        x3 = node3[0]
        y1 = node1[1]
        y2 = node2[1]
        y3 = node3[1]

        F = np.empty(2)
        F[0] = (x1 - x_center)**2 + (y1 - y_center)**2 - (x3 - x_center)**2 - (y3 - y_center)**2
        F[1] = (x2 - x_center)*(x3 - x1) + (y2 - y_center)*(y3 - y1)
        return F

    @staticmethod
    def gen_new_traj_nodes(x_coeff, y_coeff, start_time, end_time):
        """
        Function that computes the new node path with trajectory planning
        :param x_coeff: X function polynomial coefficients [np.array]
        :param y_coeff: Y function polynomial coefficients [np.array]
        :param start_time: The start time of the interval
        :param end_time: The end time of the interval
        :return: New nodes with x-position and y-positions [[x,y],...]
        """

        T = np.linspace(start_time, end_time, 10)
        new_nodes = []

        for t_i in T:
            t_vec = np.array([1, t_i, t_i** 2, t_i** 3, t_i** 4, t_i** 5, t_i** 6])
            x_new = np.dot(x_coeff, t_vec)
            y_new = np.dot(y_coeff, t_vec)
            new_nodes.append([float(x_new), float(y_new)])

        return new_nodes

    @staticmethod
    def trajectory_Array_generation(T):
        """
        Function that generates the array for the trajectory generation
        :param T: Time list elapse at that point [t1,...,t6]
        :return: Array
        """

        arr_row = np.array([[1, T[0], T[0]**2, T[0]**3, T[0]**4, T[0]**5, T[0]**6]])
        arr = arr_row
        for i in range(1, 6):
            arr_row = np.array([[1, T[i], T[i]**2, T[i]**3, T[i]**4, T[i]**5, T[i]**6]])
            arr = np.concatenate((arr, arr_row), axis=0)
        arr_jerk_row = np.array([[0, 0, 0, 0, 24*T[5]**4, 60*T[5]**5, 120*T[5]**6]])
        arr = np.concatenate((arr, arr_jerk_row), axis=0)
        return arr

    @staticmethod
    def calc_all_angles(path):
        """
        Function to return a list with all the angle between points
        :param path: The path list of nodes
        :return: List of angles
        """

        ang_list = []
        for i in range(len(path)-1):
            node1 = path[i+1]
            node2 = path[i]

            ang = math.atan2((node2[1] - node1[1]), (node2[0] - node1[0]))
            ang_list.append(ang)

        return ang_list

    @staticmethod
    def calc_all_dist(path):
        """
        Function to calculate all the distances each two points in path
        :param path: The path [[x,y],...]
        :return: The list with all the distances
        """

        dist = []
        for i in range(len(path)-1):
            node1 = path[i]
            node2 = path[i+1]
            dx = node2[0] - node1[0]
            dy = node2[1] - node1[1]
            D = math.sqrt(dx**2 + dy**2)
            dist.append(D)

        return dist

    @staticmethod
    def points_fit_curve(nodes):
        """
        Function that fits two points to a curve
        :param nodes: Array of nodes
        :return: Fitted data points in list form
        """

        x = [x for (x, y) in nodes]
        y = [y for (x, y) in nodes]

        fit_parameters = np.polyfit(x, y, 6)  # 6th order
        poly = np.poly1d(fit_parameters)
        xp = list(np.linspace(nodes[0][0], nodes[-1][0], 3))
        yp = list(poly(xp))
        return xp, yp

    @staticmethod
    def calc_mid_point(node1, node2):
        """
        Function that calculates mid points
        :param node1: Node 1 [x,y]
        :param node2: Node 2 [x,y]
        :return: Mid node
        """

        xmid = 0.5*(node1[0] + node2[0])
        ymid = 0.5*(node1[1] + node2[1])
        return [xmid, ymid]