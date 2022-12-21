## PROBLEM #3
# NAME: Tomoki Koike
# DUE: Oct. 3, 2019
# DESCRIPTION: This program will read a file containing the number of steps
# made by a certain individual for one year. The program will output the average
# steps for each month
# (with input validations)
##

# Modules
# Importing calendar module
import calendar
# Importing mean from statistics module
from statistics import mean

# FUNCTIONS
# Function for input validation
def getValid(prompt):
    while True:
        try:
            # trying input with without any conditions at first
            this = input(prompt)
        except ValueError:
            # Prints the user to input again since the input was not valid
            print('Sorry, could not understand. Please enter again.')
            continue
            # For when the input is a number
        if (this.lstrip('-').replace('.','',1).isdigit()):
                # For when the input is a number
            if this.find('.') != -1:
                # Ruling out float inputs as errors
                print('Error. Please enter a positive INTEGER value.')
                continue
            elif int(this) > 0:
                # Valid input (a positive integer)
                break
            else:
                # Invalid input
                print('Error. Please enter a positive integer value.')
                continue
        else:
            # For when the input is the file name (string)
            revStr = this[::-1]
            if revStr[0:4] == 'txt.':
                # Valid input for .txt extension for file name
                break
            else:
                # Invalid file extension
                print('Error. Please enter a valid file name with .txt extension.')
    return this

# This function reads the file into one list with all the step per day data
def read_file(fileName):
    # Open the file to read
    file = open(fileName, 'r')
    # Read the first line of the file
    read_line = file.readline()
    # Preallocating list to hold all step values
    steps_list = []
    # Loop to read all the values
    while read_line != '':
        # Append the read string number into the list
        steps_list.append(int(read_line))
        # Reading the next line
        read_line = file.readline()
    # Closing the open file
    file.close()
    return steps_list

# This function generates the average steps for each month
def avg_month_step(steps_list):
    # List with the number of days in the months in order from Jan to Dec
    monthDays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    # Initialize Counter
    counter = 1
    for x in monthDays:
        sliced_list = steps_list[0:x+1]
        # Calculate mean for the month
        step_month_mean = mean(sliced_list)
        print('{0:10}: {1:6>d}'.format(calendar.month_name[counter], int(step_month_mean)))
        # Deleting unnecessary indices from the list with steps
        del steps_list[0:x+1]
        # Increment counter
        counter += 1
    return

# Main
def main():
    # Reading the data text file with steps
    list_of_steps = read_file(getValid('Type the name of the file you would like to read including the file extension -> '))
    # Calculating and output the average for each month
    print()
    print('Total steps for each month:')
    print('---------------------------')
    avg_month_step(list_of_steps)

# Execute main
if __name__ == '__main__':
    main()

