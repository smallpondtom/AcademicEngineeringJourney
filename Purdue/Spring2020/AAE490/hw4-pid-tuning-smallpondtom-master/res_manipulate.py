"""
HW4 PYTHON SCRIPT TO PLOT THE RESULTS WE GET FROM THE DRONE LOGSYNC DATA
AUTHOR: TOMOKI KOIKE
"""

import numpy as np
import matplotlib.pyplot as plt
import os

file_name = 'a.txt'

def read_file(filename):
    return np.loadtxt(filename)


def find_file_and_del(file_name):
    if file_name in os.listdir(os.curdir):
        os.remove(file_name)


def plot_flight_param(data, handle):
    global file_name
    # file_name1 = input('Enter the file name to save for altitude plot: ')
    # file_name2 = input('Enter the file name to save for motor input plot: ')
    file_name1 = 'alt_' + handle + '.png'
    file_name2 = 'motor_' + handle + '.png'
    file_name = file_name1
    t = np.arange(start=0.01, stop=(len(data[:, 0]) + 1) * 0.01, step=0.01)
    z = np.array(data[:, 0])
    m1 = np.array(data[:, 1])
    m2 = np.array(data[:, 2])
    m3 = np.array(data[:, 3])
    m4 = np.array(data[:, 4])
    z = z.astype(np.float)
    m1 = m1.astype(np.float)
    m2 = m2.astype(np.float)
    m3 = m3.astype(np.float)
    m4 = m4.astype(np.float)

    plt.figure(1)
    plt.plot(t, z)
    plt.title('Altitude over Time')
    plt.xlabel('time [s]')
    plt.ylabel('altitude [m]')
    plt.grid(which='both')
    plt.show(block=False)
    plt.savefig(file_name)
    plt.close()

    file_name = file_name2
    plt.figure(2)
    plt.plot(t, m1, label='m1')
    plt.plot(t, m2, label='m2')
    plt.plot(t, m3, label='m3')
    plt.plot(t, m4, label='m4')
    plt.title('Motor Inputs for all 4 over Time')
    plt.xlabel('time [s]')
    plt.ylabel('motor inputs')
    plt.legend()
    plt.grid(which='both')
    plt.show(block=False)
    plt.savefig(file_name)
    plt.close()
    return t, z

def main():
    file = input("Enter the name of the file: ")
    file_handle = file.rstrip('.txt')
    data = read_file(file)
    t, z = plot_flight_param(data,file_handle)


if __name__ == '__main__':
    main()