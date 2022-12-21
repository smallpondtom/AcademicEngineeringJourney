## PROBLEM #4
# NAME: Tomoki Koike
# DUE: Sept. 19, 2019
# DESCRIPTION: This program will take in an input of a natural number and print out all of the coprimes that are
# smaller than the natural number and bigger than 1. And then solve the Euler's Phi Function for that natural
# number. (with input validation)
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

# Function that creates a list for the coprimes of a certain natural number
def totient(n):
    coprimes = []  # Preallocating a list to store all the coprimes
    coprimes.append(1)  # Always 1 is inlcuded
    f1 = prime_factor(n, prime_nums(n))
    f1 = set(f1)  # Convert list into set
    for x in range(2, n):
        f2 = prime_factor(x, prime_nums(x))
        f2 = set(f2)
        f_intersect = f1 & f2
        if not f_intersect:  # If there are no intersections between the sets it is a coprime
            coprimes.append(x)
    # Append the number for the Euler's Phi Function at the end of the list
    coprimes.append(len(coprimes))
    return coprimes

def main():
    # Accept input
    num = getValid('Enter a natural number to find the coprimes and Euler''s Phi Function -> ')
    # Call the function totient(n)
    coprimes = totient(num)
    # Print out the results
    print('The coprimes for the number {0} are: '.format(num))
    ct = 1  # A counter to make the output look neater
    for x in range(len(coprimes)-1):
        print(coprimes[x], ' ', end='')
        # Just to make the output neater
        if ct % 20 == 0:
            print()
        ct += 1
    print()
    print('The Euler''s Phi Function will be: phi(n) = {0}'.format(coprimes[-1]))

if __name__ == '__main__':
    main()


