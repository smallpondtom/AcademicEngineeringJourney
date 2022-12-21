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

import test_rrt as prg
import os
import matplotlib.pyplot as plt

#Run program 10 times saving files
def main():
    dir_path = os.path.dirname(os.path.realpath(__file__))
    for i in range(1, 11):
        prg.main(json_export=False)

        # Deleting existing image files
        img_file_name = 'Random' + str(i) + '.png'
        file_path = dir_path + '\\scenarios\\' + img_file_name
        try:
            os.remove(file_path)
        except OSError as e:
            print("Error: %s : %s" % (file_path, e.strerror))

        # Saving new image files
        plt.savefig('scenarios/'+img_file_name)
        plt.pause(0.05)
        plt.close()

if __name__ == '__main__':
    main()