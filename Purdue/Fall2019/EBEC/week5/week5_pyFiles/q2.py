###
# AUTHOR: Tomoki Koike
# DATE: Oct. 20, 2019
# DESCRIPTION: This program is designed to simulate a game of volleyball using probability.
###

# Main function
def main():
    # Printing the introduction
    introPrint()
    # Obtaining the inputs from the user
    [probA, probB, num] = getInputs()
    # Simulating the volleyball games
    [winA, winB] = allGamesSim(num, probA, probB)
    print()
    # Printing out the results
    printOutput(winA, winB, num)

# Import modules
import random as rand
import re

# Functions
# Input validation function
def getValid(prompt):
    basis = re.compile('[^0-9.]')  # Basis to check REGEX inside input
    while True:
        try:
            this = input(prompt)  # Obtain input from user
        except ValueError:
            # Invalid input
            print('Sorry, could not understand input. Please try again.')
            continue
        if basis.search(this):
            # Invalid input
            print('Please enter an appropriate input. Please try again.')
            continue
        else:
            # Valid input
            break
    return this

# Function to print out introduction
def introPrint():
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    print('Welcome. This program will simulate a game of volleyball')
    print('between 2 teams ''team A'' and ''team B''. Probabilities will')
    print('be assigned to each team indicating their potential of winning')
    print('the game. The probabilities are numbers between 0 and 1. The game')
    print('will be abide by the rules of racquetball. That being the serving')
    print('team can only score. It is a 15 point match and must be won by')
    print('a lead of 2 points.')
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=--=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    print()
    return

# Function that accepts the input from the user
def getInputs():
    # The probabilities for each team
    probA = getValid('Enter the probability team A will win the serving -> ')
    probB = getValid('Enter the probability team B will win the serving -> ')
    # Number of games to simulate
    num = getValid('Enter the number of games to simulate -> ')
    return float(probA), float(probB), int(num)

# Function deciding first serving team
def chooseServing():
    # Generating number 1 or 0
    chip = rand.randint(0, 1)
    if chip == 0:
        server = 'A'
    else:
        server = 'B'
    return server

# Function simulating one game
def oneGameSim(probA, probB, firstServe):
    serving = firstServe  # Which team starts serving
    scoreA = scoreB = 0  # Initialize the scores
    # Loop to simulate the game
    while not endGame(scoreA, scoreB):
        if serving == 'A':
            if rand.random() < probA:
                scoreA += 1
            else:
                serving = 'B'
        else:
            if rand.random() < probB:
                scoreB += 1
            else:
                serving = 'A'
    return scoreA, scoreB

# Function simulating all games
def allGamesSim(num, probA, probB):
    winA = winB = 0  # Initializing winning numbers
    # Loop to simulate all games
    for x in range(num):
        [scoreA, scoreB] = oneGameSim(probA, probB, chooseServing())
        # print()
        # print('========== MATCH  {0} =========='.format(x+1))
        # print('____team A____  ____team B____')
        # print('{0:8}      ||{1:8}'.format(scoreA, scoreB))
        # print()
        # Determine winner
        if scoreA > scoreB:
            winA += 1
        else:
            winB += 1
    return winA, winB

# Function that defines the end of the game
def endGame(scoreA, scoreB):
    # One team must be over 15 points
    cond1 = scoreA >= 15 or scoreB >= 15
    # The team to win must be leading the game by 2 points
    cond2 = (scoreA - scoreB >= 2) or (scoreB - scoreA >= 2)
    return cond1 and cond2

# Function to print out output
def printOutput(winA, winB, num):
    print('The number of games simulated in total: {0}'.format(num))
    print('Wins for team A: {0} ({1:.4f}%)'.format(winA, winA/num*100))
    print('Wins for team B: {0} ({1:.4f}%)'.format(winB, winB/num*100))

# Executing main function
if __name__ == '__main__':
    main()
