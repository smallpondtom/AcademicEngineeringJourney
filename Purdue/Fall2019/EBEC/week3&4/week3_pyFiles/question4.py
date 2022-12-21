## PROBLEM #4
# NAME: Tomoki Koike
# DUE: Oct. 3, 2019
# DESCRIPTION: This program will take in text file with data of the
# PowerBall Lottery and there winning numbers of a specific period.
# This program will manipulate the data to output the frequency of the
# winning numbers and provide the most frequent numbers etc.
##

# import Modules
import collections

# Functions
# Function to read the text file
def read_file_all(file):
    # Opening the file to read
    afile = open(file, 'r')
    # Reading the first line
    aline = afile.readline()
    # Initialize a list to contain all the values from the data
    all_nums = []
    # Loop to read all the lines
    while aline != '':
        # stripping the sentence end
        aline = aline.rstrip('\n')
        # Splitting the values into individual strings
        aline = aline.split()
        # Append to the list
        for x in aline:
            all_nums.append(x)
        # Read the next line
        aline = afile.readline()
    # Closing the open file
    afile.close()
    return all_nums

# Function to read the text file
def read_file_powerball(file):
    # Opening the file to read
    afile = open(file, 'r')
    # Reading the first line
    aline = afile.readline()
    # Initialize a list to contain all the values from the data
    powerball_nums = []
    # Loop to read all the lines
    while aline != '':
        # stripping the sentence end
        aline = aline.rstrip('\n')
        # Splitting the values into individual strings
        aline = aline.split()
        # Append to the list
        powerball_nums.append(int(aline[5]))
        # Read the next line
        aline = afile.readline()
    # Closing the open file
    afile.close()
    return powerball_nums

# Function to read the text file and create dict to find the overdues
def read_file_overdue(file):
    # Opening the file to read
    afile = open(file, 'r')
    # Reading the first line
    aline = afile.readline()
    # initializing the counter to check for the overdue
    time = 654
    adict = {}
    # Loop to read all the lines
    while aline != '':
        # stripping the sentence end
        aline = aline.rstrip('\n')
        # Splitting the values into individual strings
        aline = aline.split()
        # Calling the function to create dict to figure overdues
        make_dict_overdue(aline, time, adict)
        # decrement time
        time -= 1
        # Read the next line
        aline = afile.readline()
    # Closing the file
    afile.close()
    return adict

# Function to create a dictionary for the frequency of the winning numbers
def make_dict_freq(all_nums):
    # Create a empty dict
    adict = {}
    # Assigning the value in list as key
    for x in range(len(all_nums)):
        key = all_nums[x]
        if key in adict:
            adict[key] += 1
        else:
            adict[key] = 1
    return adict

# Function to create the overdue dict
def make_dict_overdue(aline, time, adict):
    for key in aline:
        adict.update({key: time})
    return adict

# Function to sort dict from small to large
def dict_sort(adict):
    return collections.OrderedDict(sorted(adict.items(), key=lambda kv: kv[1]))

# Function to sort dict in reverse large to small
def dict_sort_rev(adict):
    return collections.OrderedDict(sorted(adict.items(), key=lambda kv: kv[1], reverse=True))

# Function to print results
def output_dict(adict):
    counter = 0
    for k in adict:
        if counter == 10:
            break
        else:
            print(k, ' ', end='')
        counter += 1
    return

# Function to print out the dictionary with all he numbers as their frequency
def print_freq(adict):
    counter = 0
    for x in sorted(adict):
        print('#{0:<2}: {1:3} times, '.format(x, adict[x]), end='')
        counter += 1
        if counter % 10 == 0:
            print()
    return

# Main function
def main():
    all_nums = read_file_all('pbnumbers.txt')
    overdue_dict = read_file_overdue('pbnumbers.txt')
    freq_dict = make_dict_freq(all_nums)
    powerball_nums = read_file_powerball('pbnumbers.txt')
    powerball_freq = make_dict_freq(powerball_nums)

    # Results
    print('The 10 most common numbers:', end=' ')
    output_dict(dict_sort_rev(freq_dict))
    print()
    print('The 10 least common numbers:', end=' ')
    output_dict(dict_sort(freq_dict))
    print()
    print('The 10 most overdue numbers:', end=' ')
    output_dict(dict_sort_rev(overdue_dict))
    print('\n')
    print('The frequency of all numbers from 1 to 69:')
    print_freq(freq_dict)
    print('\n')
    print('The frequency of the numbers of the powerball from 1 to 26:')
    print_freq(powerball_freq)

# Executing the main function
if __name__ == '__main__':
    main()
