### QUESTION #2 ###
# AUTHOR     : TOMOKI KOIKE
# DATE       : NOV. 17 2019
# DESCRIPTION: THIS PROGRAM IS DESIGNED TO COMPUTE THE CROSS CORRELATION OF PROVIDED DATA OF TWO FILES AND
#              PLOT THE 2D CONTOUR OF THE RESULT.
###################

# Main function
def main():
    matA = readData('matrix_A.txt')  # Reading matrix A
    matB = readData('matrix_B.txt')  # Reading matrix B
    matC = crossCorr(matA, matB)  # Computing the cross correlation
    l = list(np.shape(matC))  # Obtaining the shape of matC as a list and not tuple
    size = l[0]
    # Computing the x- and y- axis matrices
    xmat, ymat = createAxisArray(np.min(matA), np.max(matA), np.min(matB), np.max(matB), size)
    # Plotting the contour
    plotContour(xmat, ymat, matC)

# Import modules
import numpy as np
import matplotlib.pyplot as plt
from scipy import signal

# Functions
# Function to read the text file
def readData(file):
    afile = open(file, 'r')  # Opening the file in read mode
    aline = afile.readline()  # Read the first line
    length = measureLen(aline)  # Get the length of the matrix rows and columns
    data_matrix = np.empty([length, length], dtype=float)  # Initialize an empty numpy array
    n = 0  # Initialize the counter for the index
    while aline != '':
        aline = aline.replace('\t', ' ')  # Replacing the newline character
        aline = aline.replace('\n', ' ')  # Replacing \n with space
        aline = aline.split()  # Splitting the string into a list
        aline = list(map(float, aline))  # Changing the data types into floats
        data_matrix[n, :] = aline  # Replacing the initialized numpy matrix with the data
        aline = afile.readline()  # Reading a new line
        n += 1  # Incrementing the counter
    return data_matrix

# Function to split the read line to find the length of the row and column
def measureLen(astring):
    astring = astring.replace('\t', ' ')  # Replacing the newline character
    astring = astring.replace('\n', ' ')
    astring = astring.split()  # Splitting the string into individual elements as a list
    return len(astring)

# Function to compute the cross-correlation of 2 matrices
def crossCorr(matA, matB):
    sizeA = np.array(list(np.shape(matA)), dtype=int)  # Obtaining the size of matA in immutable form
    sizeB = np.array(list(np.shape(matB)), dtype=int)  # OBtaining the size of matB in immutable form
    sizeC = sizeA - sizeB + [1, 1] # Calculating the size of the matrix with the cross correlation results
    corr = signal.correlate2d(matA, matB, mode='valid', boundary='fill')  # Using Scipy's 2D cross correlation

    ### The generic way of cross correlation using 4 for loops ###
    # matC = np.random.random_sample(sizeC)  # Initializing the matrix to store the resulting matrix
    # for p in range(sizeC[0]):
    #     for q in range(sizeC[1]):
    #         point = 0  # Initialize temporary value holder
    #         for i in range(sizeB[0]-1):
    #             for j in range(sizeB[1]-1):
    #                 point += (matA[p+i, q+j] - matB[i, j])**2
    #         matC[p, q] = point
    return corr

# Function that creates the array with x- and y-axis indices for the contour plot
def createAxisArray(xlow, xhigh, ylow, yhigh, size):
    # Intialize a numpy array for the x and y axis matrices
    xmat = np.random.random_sample([size, size])
    xline = np.linspace(start=xlow, stop=xhigh, num=size)
    ymat = np.random.random_sample([size, size])
    yline = np.linspace(start=ylow, stop=yhigh, num=size)
    for n in range(size):
        xmat[n, :] = xline
        ymat[n, :] = yline
    return xmat, ymat.T

# Function to plot the contour graph
def plotContour(xmat, ymat, data):
    plt.contourf(xmat, ymat, data)
    plt.title('Contour Plot of the Cross Correlation of Matrix A and B')
    plt.xlabel('x positions')
    plt.ylabel('y positions')
    plt.savefig('xcorr_contour_plot.png')
    plt.show()
    return

# Execute the main function
if __name__ == '__main__':
    main()
