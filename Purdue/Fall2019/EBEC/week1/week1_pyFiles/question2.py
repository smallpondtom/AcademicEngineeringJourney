###
# AUTHOR: Tomoki Koike
# DATE: Sept. 12, 2019
# DESCRIPTION: This program will find and print out all the prime integer numbers between 1-100.
###

def main():
    low, high = 1, 100 # Defining the range for the list
    # The for loop
    for x in range(low, high+1):
        ct = 0 # Counter to determine the numbers of divisors
        for y in range(1,x+1):
            if x % y == 0: # If y is a divisor of x increment the counter by 1
                ct += 1
        if ct == 1 or ct == 2: # If the counter indicates 1 or 2 print the prime number
            if x < 10: # **This if-else is just to make the output neater
                print('', x, ' ', end='')
            else:
                print(x, ' ', end='')
        else: # If there are more than two divisors, the number x is not a prime number
            print(' -', ' ', end='')
        # **Just to make the output neater
        if x % 10 == 0:
            print()

if __name__ == '__main__':
    main()