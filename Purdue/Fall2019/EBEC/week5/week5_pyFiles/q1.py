###
# AUTHOR     : Tomoki Koike
# DATE       : Oct 20th, 2019
# DESCRIPTION: This program reads a file and creates a bar and line graph based on
#              the data from the text file.
###

# Main Function
def main():
    # Reading the file
    data = read_file('1994_Weekly_Gas_Averages.txt')
    # Creating the line graph for the data
    create_lineGraph(data)
    # Creating the bar chart for the data
    create_barChart(data)

# Import modules
import matplotlib.pyplot as plt

# Functions
# Function to read the data from the file
def read_file(file):
    # Opening the flle
    subject_file = open(file, 'r')
    # Reading the first line of the file
    line = subject_file.readline()
    # Preallocate the list to store the data
    data = []
    # Loop to the read all the data from the file
    while line != '':
        # Appending the data read from the file to the list
        data.append(line)
        # Reading the next line
        line = subject_file.readline()
    # Closing the file
    subject_file.close()
    return data

# Function to create an optimal tick list
def create_tick_list(data, x_tick):
    tick_list = []
    counter = 0
    sort_data = sorted(data)
    for x in x_tick:
        tick_list.append(sort_data[x-1])
    return tick_list

def create_lineGraph(data):
    # Creating the x-values corresponding to the input data
    x_vals = range(1, len(data)+1)
    x_tick = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    x_tick_count = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    # The list for ticks
    # most decimals
    y_tick_list = create_tick_list(data, x_tick)
    y_tick_list_count = x_tick_count
    # Plotting
    plt.figure(1)
    plt.plot(x_vals, data, 'ro-')
    # Setting the title
    plt.title('The Average Weekly Price of the Gas in 1994')
    # Putting x labels
    plt.xlabel('Week')
    plt.ylabel('Price ($)')
    # Putting the ticks on the graph
    plt.xticks(x_tick_count, x_tick)
    plt.yticks(y_tick_list_count, y_tick_list)
    # Putting the grids on the graph
    plt.grid(True)
    # Saving the graph as
    plt.savefig('gas_price_1994_line.png')
    # Showing the graph
    plt.show()
    return

# Function to create a bar chart
def create_barChart(data):
    # Creating the x-values corresponding to the input data
    x_vals = range(1, len(data) + 1)
    x_tick = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    x_tick_count = [1, 5, 10, 15, 20, 25, 30, 35, 40, 45, 50]
    # The list for ticks
    # most decimals
    y_tick_list = create_tick_list(data, x_tick)
    y_tick_list_count = x_tick_count
    # Plotting
    bar_width = 0.5
    plt.figure(1)
    plt.bar(x_vals, data, bar_width)
    # Setting the title
    plt.title('The Average Weekly Price of the Gas in 1994')
    # Putting x labels
    plt.xlabel('Week')
    plt.ylabel('Price ($)')
    # Putting the ticks on the graph
    plt.xticks(x_tick, x_tick_count)
    plt.yticks(y_tick_list_count, y_tick_list)
    # Saving the chart as a file
    plt.savefig('gas_price_1994_bar.png')
    # Showing the chart
    plt.show()
    return

# Calling out the main function
if __name__ == '__main__':
    main()

