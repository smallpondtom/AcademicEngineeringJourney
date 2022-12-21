###
# AUTHOR: Tomoki Koike
# DUE: Oct. 3, 2019
# DESCRIPTION: This program is designed to convert algebraic infix expressions into prefix and
# postfix expressions.
###

# Modules
import re

# Main function
def main():
    infix = getValid('Enter a valid infix algebraic expression -> ')
    print('Prefix expression: ', output(infixToPrefix(infix)))
    print('Postfix expression: ', output(infixToPostfix(infix)))
    return


# Functions
def getValid(prompt):
    base = re.compile('[^a-zA-Z0-9+\+\-\*/\(\)\.]')
    while True:
        try:
            # trying input with without any conditions at first
            this = (input(prompt))
            this = re.sub(r'\s+', '', this)
        except ValueError:
            # Prints the user to input again since the input was not valid
            print('Sorry, could not understand. Please enter again.')
            continue
            # For when there is a mon-digit character in the input
        if base.search(this):
            print('Error! Plesae enter a valid algebraic calculation expression.')
            continue
        else:
            # Valid input
            break
    this = list(this)  # Convert the string into list
    this.insert(0,'(')
    this.append(')')
    return this

# Dictionary with the operators and the priorities of them
priority = {
    '^':4,
    '*':3,
    '/':3,
    '+':2,
    '-':2,
    '(':1,
    ')':1
}

# Function that converts infix to postfix
def infixToPostfix(infix):
    check = re.compile(r'[\+\-\*/]')  # Setting RegEx for later conditions
    base = re.compile(r'\w')  # Setting RegEx for later conditions
    # Initialize the output postfix as a list
    postfix = []
    # Initialize the operators stack as a list
    operators = []
    ct = 1  # A counter
    # Loop to rearrange the infix to postfix
    for x in infix:
        if base.search(x) or x == '.':
            postfix.append(x)
        elif x == '(':
            operators.append(x)
        elif ct != len(infix) and x == ')':
            while True:
                hold = operators.pop()
                if not hold or hold == '(':
                    break
                elif check.search(hold):
                    postfix.append(hold)
                else:
                    pass
        elif ct == len(infix):
            while len(operators) > 1:
                postfix.append(operators.pop())
        else:  # For when the index is an operator
            if operators:
                hold = operators[len(operators)-1]
                while len(operators) > 0 and priority[hold] >= priority[x]:
                    postfix.append(operators.pop())
                    hold = operators[len(operators)-1]
            operators.append(x)
        ct += 1  # Increment counter
    return postfix

# Function that converts the infix to a prefix
def infixToPrefix(infix):
    infix = infix[::-1]  # Reversing the list
    # Reversing the positions of ( and )
    for idx, val in enumerate(infix):
        if val == '(':
            infix[idx] = ')'
        elif val == ')':
            infix[idx] = '('
        else:
            pass
    # Using the postfix converter
    prefix = infixToPostfix(infix)
    # Reverse the immediate output to obtain prefixed expression
    prefix = prefix[::-1]
    return prefix

# Function for the output
def output(string):
    return ''.join(string)

# Executing main
if __name__ == '__main__':
    main()

