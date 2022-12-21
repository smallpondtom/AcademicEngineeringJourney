###
# AUTHOR     : Tomoki Koike
# DATE       : Oct. 20 2019
# DESCRIPTION: This program is designed to manipulate a data text file and break the
#              specific data by relevance. And then break each of them into equal numbers
#              of data and create a histogram for each data.
###

# Main Function
def main():
    [diam, circ, aspr] = createList('Particle_Morphology_Data.txt')
    # For diameters
    diam_count = segmentcount(diam)
    diam_barwidth = getbarwidth(diam)
    diam_left_edge = getleftedge(diam_barwidth)
    fig1 = plt.figure()
    histplot(diam_count, diam_left_edge, diam_barwidth, 'blue')
    plt.xlabel('Diameter')
    plt.ylabel('Count')
    plt.title('Count of Diameters in 12 Equally Spaced Segments')
    plt.show(block=False)
    fig1.savefig('Diameter.png')
    time.sleep(1)
    plt.close('all')
    # For circularity
    circ_count = segmentcount(circ)
    circ_barwidth = getbarwidth(circ)
    circ_left_edge = getleftedge(circ_barwidth)
    fig2 = plt.figure()
    histplot(circ_count, circ_left_edge, circ_barwidth, 'red')
    plt.xlabel('Circularity')
    plt.ylabel('Count')
    plt.title('Count of Circularities in 12 Equally Spaced Segments')
    plt.show(block=False)
    fig2.savefig('Circularity.png')
    time.sleep(1)
    plt.close('all')
    # For aspect ratio
    aspr_count = segmentcount(aspr)
    aspr_barwidth = getbarwidth(aspr)
    aspr_left_edge = getleftedge(aspr_barwidth)
    fig3 = plt.figure()
    histplot(aspr_count, aspr_left_edge, aspr_barwidth, 'green')
    plt.xlabel('Aspect Ratio')
    plt.ylabel('Count')
    plt.title('Count of Aspect Ratios in 12 Equally Spaced Segments')
    plt.show(block=False)
    fig3.savefig('AspectRatio.png')
    time.sleep(1)
    plt.close('all')

# Imported Modules
import matplotlib.pyplot as plt
import time

# Functions
# Reading the file and creating lists
def createList(afile):
    data_file = open(afile, 'r')  # Open the file
    aline = data_file.readline()  # Reading the first line
    # Preallocating the lists
    diam = []  # List of diameters
    circ = []  # List of circularities
    aspr = []  # List of aspect ratios
    # Loop through the file and read all the lines
    while aline != '':
        aline = aline.rstrip('\n')  # Striping off the end of the readline
        temp = list(aline.split('\t'))  # Splitting the read line by spaces
        diam.append(float(temp[0]))  # Appending the diameter value in the read line
        circ.append(float(temp[1]))  # Appending the circularity value in the read line
        aspr.append(float(temp[2]))  # Appending the aspect ratio value in the read line
        aline = data_file.readline()  # Reading the next line
    data_file.close()  # Closing the opened file
    return diam, circ, aspr

# Function that gives the maximum and the minimum
def max_min(alist):
    return max(alist), min(alist)

# Function that retrieves the range of the list
def getrange(alist):
    [amax, amin] = max_min(alist)  # Obtaining the maximum and minimum values of the list
    return amax - amin

# Function that gives the left edge of the bar graph or histogram
def getleftedge(bar_width):
    left_edge = []  # Initializing list
    for x in range(1, 13):
        left_edge.append(bar_width*x)
    return left_edge

# Function to find bar_width
def getbarwidth(alist):
    list_range = getrange(alist)
    chop = list_range / 12
    return chop

# Function that segments the lists
def segmentcount(alist):
    chop = getbarwidth(alist)  # Dividing the range into 12 equal segments
    sorted_list = sorted(alist)  # Sorting the list
    count_list = []  # Initializing the count list
    for x in range(1, 13):
        i = 0  # Counter
        sliced_list = []  # Initializing the sliced list
        if x != 12:
            while sorted_list[i] <= (min(alist)+chop*x):
                sliced_list.append(sorted_list[i])  # Appending value
                i += 1  # Incrementing counter
        else:
            sliced_list = sorted_list
        del sorted_list[0:i]  # Delete the values that are unnecessary
        count_list.append(len(sliced_list))  # Appending to the count list
    return count_list

# Function to plot histogram
def histplot(count_list, left_edge, bar_width, iro):
    plt.bar(left_edge, count_list, bar_width, edgecolor='black', color=iro)
    return

if __name__ == '__main__':
    main()