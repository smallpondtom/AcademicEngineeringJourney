###
# AUTHOR: Tomoki Koike
# DATE: OCT. 3, 2019
# DESCRIPTION: This program is designed to accept several formats of telephone numbers
# and validate if it is in proper format or not.
###

# Main function
def main():
    getValid('Please enter your US phone number properly. -> ')
    return

# Import modules
import re

# Functions
def getValid(instruc):
    base = re.compile(r'[^\d\s\(\)\-]')
    while True:
        try:
            this = input(instruc)
        except ValueError:
            print('Cannot understand. Please enter valid input.')
            continue
        # Validating the phone number
        if base.search(this) or not(10 <= len(this) and len(this) <= 14):
            print('Please follow the proper format for entering a US phone number.')
            print('You may only use parantheses, hypens, spaces, and 10 digits.')
            print('Please try again.')
            continue
        else:
            # Valid input
            print('Thank you very much. Your phone number has been saved.')
            break

# Executing main
if __name__ == "__main__":
    main()
