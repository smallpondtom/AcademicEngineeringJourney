#!\usr\bin\env python3
"""
Fixed Wing Motion Planner Project
>> Description: Execution file of path planning with obstacles implementing
                Rapidly-Exploring Random Trees (RRT).

>> Team 1: Hanyao Hu
           Tomoki Koike
           Herschel Meadow
           Luke Ritchison

Purdue University, West Lafayette, IN
School of Engineering, Aeronautical and Astronautical Engineering, AAE 49000iar
"""

# Importing modules
from rrt_model import RRT
import random
import math
import matplotlib.pyplot as plt
import path_smoother
import json
import os

def generate_random_obstacles(N, lower_limit, upper_limit, min_radius, max_radius):
    """
    Function to generate circle obstacles
    :param N: The number of circles
    :param lower_limit: The lower limit of the center of the circles
    :param upper_limit: The upper limit of the center of the circles
    :param min_radius: The minimum radius value
    :param max_radius: The maximum radius value
    :return: Obstacle list [[x, y, radius],...]
    """

    obstacles = []
    for i in range(N):
        circle = (random.uniform(lower_limit, upper_limit),
                  random.uniform(lower_limit, upper_limit),
                  random.uniform(min_radius, max_radius))
        obstacles.append(circle)
    return obstacles

def generate_random_goal(min, max, obstacles):
    """
    Function that generates random goal point
    :param min: The minimum value possible
    :param max: The maximum value possible
    :param obstacles: List of obstacles [{x, y, radius},...]
    :return: Random Goal point [x, y]
    """

    while True:
        rand_goal = [random.randint(min, max), random.randint(min, max)]
        if clear_obstacle(rand_goal, obstacles):
            return rand_goal
        else:
            continue

def clear_obstacle(point, obstacles):
    """
    Function to check if the arriving node collides with any obstacles
    :param point: Random point
    :param obstacles: The list of obstacles
    :return: Boolean of True/False of whether there is no collision
    """

    for (x_center, y_center, radius) in obstacles:
        x_distance = x_center - point[0]
        y_distance = y_center - point[1]
        distance = math.sqrt(x_distance**2 + y_distance**2)

        if distance <= radius:
            return False  # Collides with obstacle
    return True  # Clear

def main(json_export=False):
    """
    Main function
    :return: None
    """

    # Generate random obstacles
    obstacles = generate_random_obstacles(10, 2, 15, 0.25, 2.5)
    # Generate random goal point
    goal_position = generate_random_goal(10, 20, obstacles)

    # Initialize parameters for RRT
    rrt = RRT(start=[0, 0], goal=goal_position, obstacles=obstacles, xy_field=[-2, 20],
              extend_dist=0.4, velocity=0.04, max_angle=math.pi/4, iterations=2000)

    opt_path = rrt.path_planning(show_animation=True)
    x_opt_path = [x for (x, y) in opt_path]  # Extracting x values
    y_opt_path = [y for (x, y) in opt_path]  # Extracting y values


    # Smooth path generator abandoned
    # smoop = path_smoother.SmoothPath(path=opt_path, obstacles=obstacles, max_angle=math.pi/8,
    #                                  start=[0, 0], goal=goal_position, velocity=0.04)
    # smooth_path = smoop.path_smooth()
    # x_smooth_path = [x for (x, y) in smooth_path]  # Extracting x values
    # y_smooth_path = [y for (x, y) in smooth_path]  # Extracting y values

    # Plotting the optimal path
    if opt_path is None:
        print("Could not find optimal path.")
    else:
        print("Optimal path has been found.")

        rrt.plot_simulation()
        plt.plot(x_opt_path, y_opt_path, '-r', linewidth=2)
        # plt.plot(x_smooth_path, y_smooth_path, '-b', linewidth=1.5)
        plt.grid(True)
        plt.pause(0.01)
        plt.show(block=False)

        if json_export == True:
            dir_path = os.path.dirname(os.path.realpath(__file__))
            # Deleting existing image files
            data_file_name = 'path_data.json'
            file_path = dir_path + '\\json_data\\' + data_file_name
            try:
                os.remove(file_path)
            except OSError as e:
                print("Error: %s : %s" % (file_path, e.strerror))

            with open('json_data/path_data.json', 'w', encoding='utf-8') as f:
                json.dump(opt_path, f, ensure_ascii=False, indent=4)

if __name__ == '__main__':
    main(json_export=True)

