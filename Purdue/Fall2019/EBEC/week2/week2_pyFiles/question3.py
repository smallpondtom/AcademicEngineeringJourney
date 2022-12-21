## PROBLEM #3
# NAME: Tomoki Koike
# DUE: Sept. 19, 2019
# DESCRIPTION: This program has a function that conducts prime factorization
# for any number and outputs all of the factors in ascending order.
# (with input validation)
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
        if type(this) != int or this <= 0:
            print('Please enter a proper integer value -> ')
            continue
        else:
            # Valid input
            break
    return this

# Determining all the prime numbers up to the number we want to factorize
def prime_nums(high):
    low = 1  # Defining the lower range for the list
    primes = []  # Preallocate the list containing all the prime numbers up to the high
    # The for loop
    for x in range(low, high+1):
        ct = 0  # Counter to determine the numbers of divisors
        for y in range(1,x+1):
            if x % y == 0:  # If y is a divisor of x increment the counter by 1
                ct += 1
        if ct == 1 or ct == 2:  # If the counter indicates 1 or 2 print the prime number
            primes.append(x)  # Appending the prime number to the list
        else:  # If there are more than two divisors, the number x is not a prime number
            pass
    return primes

# Function that conducts prime factorization
def prime_factor(anum, primes):
    factors = []  # Preallocating a list with all the factors
    idx = 1  # Initialize an index counter
    while idx < len(primes):
        temp = anum // primes[idx]  # Temporary number
        if anum % primes[idx] == 0:
            factors.append(primes[idx])
            anum = temp  # Swap anum with prime number
        else:
            idx += 1
    return factors

def main():
    num = getValid('Enter a number to factorize into prime numbers -> ')
    factors = prime_factor(num, prime_nums(num))
    # Printing out the results
    print('The number {0} is factorized into the prime numbers: '.format(num), end='')
    for x in range(len(factors)):
        if x != len(factors)-1:
            print(factors[x], 'x ', end='')
        else:
            print(factors[x])

if __name__ == '__main__':
    main()


