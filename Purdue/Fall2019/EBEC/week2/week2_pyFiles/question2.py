## PROBLEM #2
# NAME: Tomoki Koike
# DUE: Sept. 19, 2019
# DESCRIPTION: This program reads a file with the winners of the World Series
# into a dictionary and when the user inputs a year from 1904 to 2009 the program will output the
# winner of that year and the nunmber of times that the team won the World Series.
# (with input validations)
##

# Functions
# Function for input validation
def getValid(prompt):
    while True:
        try:
            # trying input with without any conditions at first
            this = int(input(prompt))
        except ValueError:
            # Prints the user to input again since the input was not valid
            print('Sorry, could not understand. Please enter again.')
            continue
            # For when the input is a number
        if this >= 1903 and this <= 2009:
            if this == 1904 or this == 1994:
                print('There was no world series in this year please select another year -> ')
                continue
            else:
                # Valid input
                break
        else:
            # Invalid input
            print('Error. Please enter a year in between the period of 1903 ~ 2009 -> ')
            continue
    return this

# Function to read a file and create a dictionary with team names and number of times winning the
# World Series
def create_dict1(file):
    # Opening the file
    specimen_file = open(file,'r')
    # Reading the first line of the file
    line = specimen_file.readline()
    # Dictionary to store the team names
    teamName = []
    numberOfWins = []
    # Looping to create the keys and values for the dict by reading the file
    while line != '':
        if teamName.count(line) == 0:
            # Append to the teamName list if it appears for the first time
            teamName.append(line)
            # Add one win for this team
            numberOfWins.append(1)
        else:
            # Add the number of wins for this team
            name_idx = teamName.index(line)
            numberOfWins[name_idx] += 1
        # Read the next line in the file
        line = specimen_file.readline()
    # Close the open file
    specimen_file.close()
    # Now create the dictionary
    WorldSeriesWinner_dict = dict(zip(teamName, numberOfWins))
    return WorldSeriesWinner_dict

# Function that creates a dictionary with the team names and the year that they won the World Series
def create_dict2(file):
    # Opening the file
    specimen_file = open(file, 'r')
    # Reading the file
    line = specimen_file.readline()
    # List of year
    years = []
    starting_year = 1903
    winningTeam = []
    # Loop
    while line != '':
        if starting_year != 1904 and starting_year != 1994:
            winningTeam.append(line)
            years.append(starting_year)
            line = specimen_file.readline()
            starting_year += 1
        else:
            starting_year += 1
    # Close the open file
    specimen_file.close()
    # Create the dictionary
    winnerTeam_and_year = dict(zip(years, winningTeam))
    return winnerTeam_and_year

# Function to create the output based on what year the user selects
def output(dict1, dict2, user_input):
    # Printing out the winner of the year
    team = dict2[user_input]
    print('1. The World Series winner of {0}: {1}'.format(user_input, team))
    # Printing out the number of times the team won the world series
    print('2. Number of times {0} won the World Series: {1}'.format(team, dict1[team]))
    return

# Main
def main():
    # creating the dictionaries
    WorldSeriesWinner_dict = create_dict1('WorldSeriesWinners.txt')
    WinnerTeam_and_year = create_dict2('WorldSeriesWinners.txt')

    # User input of the year to see the winner
    user_input = getValid('Please enter the year from 1903 to 2009 -> ')
    # output
    output(WorldSeriesWinner_dict, WinnerTeam_and_year, user_input)
    return
if __name__ == '__main__':
    main()
