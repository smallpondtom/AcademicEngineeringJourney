### QUESTION #1 ###
# AUTHOR     : TOMOKI KOIKE
# DATE       : NOV. 17 2019
# DESCRIPTION: THIS PROGRAM IS DESIGNED TO PLOT A 2D FILED CONTOUR GRAPH FOR A PROVIDED DATA OF
#              A VELOCITY FIELD OF A LINEAR SHEAR FLOW.
###################

# Main function
def main():
    # Obtaining the ranges for the axes from the user
    [xlow, xhigh, ylow, yhigh] = enterInput()
    [xmat, ymat] = createAxisArray(xlow, xhigh, ylow, yhigh)
    plotContour(xmat, ymat, readData('linear_shear_flow_u.txt'))

# Import modules
import re
import matplotlib.pyplot as plt
import numpy as np

# Functions
# Function for the user to enter inputs
def enterInput():
    xrange = getValid('Please enter the range for the x-axis (i.e. [0 10.2]) -> ')
    xlow = xrange[0]
    xhigh = xrange[1]
    yrange = getValid('Please enter the range for the y-axis (i.e. [0 25.5]) -> ')
    ylow = yrange[0]
    yhigh = yrange[1]
    return xlow, xhigh, ylow, yhigh

# Function that extracts the numbers from the input string
def extractNum(astring):
    astring = astring.replace('[', '')
    astring = astring.replace(']', '')
    astring = astring.split()
    return astring

# Function to validate input
def getValid(prompt):
    base = re.compile('[^0-9.-]')
    while True:
        try:
            this = input(prompt)
            num_list = extractNum(this)
            low = num_list[0]
            high = num_list[1]
        except ValueError:
            # Invalid input
            print('Sorry, could not understand input. Please try again.')
            continue
        if base.search(low) or base.search(high):
            # Invalid input
            print('Inappropriate input. Please try again.')
            continue
        else:
            # Valid input
            break
    return list(map(float, num_list))

# Function to read the text file
def readData(file):
    afile = open(file, 'r')  # Opening the file in read mode
    aline = afile.readline()  # Read the first line
    data_matrix = np.empty([63, 63], dtype=float)  # Initialize an empty numpy array
    n = 0  # Initialize the counter for the index
    while aline != '':
        aline = aline.replace('\t', '')  # Replacing the newline character
        aline = aline.split()  # Splitting the string into a list
        aline = list(map(float, aline))  # Changing the data types into floats
        data_matrix[n, :] = aline  # Replacing the initialized numpy matrix with the data
        aline = afile.readline()  # Reading a new line
        n += 1  # Incrementing the counter
    return data_matrix

# Function that creates the array with x- and y-axis indices for the contour plot
def createAxisArray(xlow, xhigh, ylow, yhigh):
    size = 63  # Size of the data matrix
    # Intialize a numpy array for the x and y axis matrices
    xmat = np.random.random_sample([63, 63])
    xline = np.linspace(start=0, stop=5, num=63)
    ymat = np.random.random_sample([63, 63])
    yline = np.linspace(start=-2, stop=2, num=63)
    for n in range(size):
        xmat[n, :] = xline
        ymat[n, :] = yline
    return xmat, ymat.T

# Function to plot the contour graph
def plotContour(xmat, ymat, data):
    plt.contourf(xmat, ymat, data)
    plt.title('Velocity Field of Linear Shear Flow')
    plt.xlabel('x positions')
    plt.ylabel('y positions')
    plt.savefig('shear_flow_u_contour.png')
    plt.show()
    return

# Executing main function
if __name__ == '__main__':
    main()
