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

import matplotlib.pyplot as plt
import numpy as np
import os
import json

from cal_rate_and_angle import cal_rate_and_angle

#plot the result
def main():
    # Importing json data file with path nodes
    with open("json_data/path_data.json") as json_file:
        path_data = json.load(json_file)

    # Preparation to save image file
    dir_path = os.path.dirname(os.path.realpath(__file__))
    img_file_name = 'rollAng_rollRate.png'
    file_path = dir_path + '\\data_plots\\' + img_file_name

    try:
        os.remove(file_path)
    except OSError as e:
        print("Error: %s : %s" % (file_path, e.strerror))

    # Test case for input
    calculate = cal_rate_and_angle(path=path_data, velocity=10)
    roll, angle = calculate.cal_angle_and_rate
    fig, ax = plt.subplots()
    plt.title("Roll Rate and Bank Angle in Degrees, V = 10 m/s")
    ax.plot(roll, label="roll rate")
    ax.plot(angle, label="bank angle")
    ax.legend()
    plt.grid()
    plt.show(block=False)
    plt.savefig(file_path)
    plt.pause(0.05)
    plt.close()



if __name__ == '__main__':
    main()