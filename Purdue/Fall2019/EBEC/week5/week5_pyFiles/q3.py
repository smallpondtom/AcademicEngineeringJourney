###
# AUTHOR     : Tomoki Koike
# DATE       : Oct. 20, 2019
# DESCRIPTION: This program lets the user play the game of rock, paper, scissor with a computer
###

# Main
def main():
    # Starting game
    startGame()
    # Initiate game loop
    gameLoop()

# Modules
import random as rand
import re

# Matrix with winning, losing, and tying combinations (player perspective)
# combos = {
#     'win':[13, 32, 21],
#     'lose':[12, 23, 31],
#     'tie':[11, 22, 33]
# } The matrix indices
combos = [
    ['tie', 'lose', 'win'],
    ['win', 'tie', 'lose'],
    ['lose', 'win', 'tie']
]
# Matrix on the moves
moves = ['rock', 'paper', 'scissors']

# Functions
# Function for input validation
def getValid(prompt):
    base = re.compile('[^a-z]')
    while True:
        try:
            # Getting input from player
            this = input(prompt)
        except ValueError:
            # Inappropriate input
            print('Sorry, could not understand. Please try again.')
        if base.search(this):
            # Inappropriate input
            print('Your input was not accepted. Please enter only lower case alphabets with no space.')
        elif this != 'rock' and this != 'paper' and this != 'scissors':
            # Invalid input
            print('You probably had a typo. Please try again.')
            continue
        else:
            # Valid input
            break
    return this

# Function to start the game
def startGame():
    print('Welcome!')
    print('Let''s play Rock, Paper, Scissors!')
    return

# Function that chooses the computers move
def computerHand():
    hand = rand.randint(1,3)
    return hand

def playerHand():
    hand = getValid('Please enter rock, paper, or scissors -> ')
    # Assigning numbers depending on move
    if hand == 'rock':
        handCode = 1
    elif hand == 'paper':
        handCode = 2
    else:
        handCode = 3
    return handCode

# Function that shows the result of the game
def playGame(computer, player):
    # Getting result of the game
    result = combos[player-1][computer-1]
    return result

def gameLoop():
    # Counter for number of games played
    counter = 1
    while True:
        print()
        print('<<<-------Game {0}------->>>'.format(counter))
        # Generating the compture's move
        computerMove = computerHand()
        # Generating the player's move
        playerMove = playerHand()
        print('>>You: ' + moves[playerMove-1])
        print('>>Computer: ' + moves[computerMove-1])
        # Obtaining the result
        result = playGame(computerMove, playerMove)
        # Determing if the game ends or continues
        if result == 'win':  # If player wins
            print('You win!')
            break
        elif result == 'lose':  # If player loses
            print('You lose! Too bad.')
            break
        else:  # If player ties
            print('You tied! Continue the Game!')
            counter += 1
            continue
    return

# Executing main function
if __name__ == '__main__':
    main()