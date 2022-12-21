###
# AUTHOR: Tomoki Koike
# DATE: OCT. 3, 2019
# DESCRIPTION: This program is designed to encrypte a text by finding the primiitivve roots and
# processing the output with some couple of more steps. (without input validation)
###

# Main function
def main():
    txt = input('Enter a string form text to encrypt -> ')
    num = int(input('Enter a number to create the encryption key -> '))
    encrypt(txt, int(num))

# Importing modules
import numpy as np

# Functions
# Determining all the prime numbers up to the number we want to factorize
def prime_nums(high):
    low = 1  # Defining the lower range for the list
    primes = []  # Preallocate the list containing all the prime numbers up to the high
    # The for loop
    for x in range(low, high + 1):
        ct = 0  # Counter to determine the numbers of divisors
        for y in range(1, x + 1):
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
    phi = len(coprimes)
    return phi

# Function that computes the primitive root
def primitiveRoot(anum):
    phi = totient(anum)  # Obtain the Euler Phi function of the number
    factors = prime_factor(phi, prime_nums(phi))  # Obtain the prime factors
    factors = set(factors)  # Convert the list to a set to get rid of duplicate values
    factors = list(factors)  # Convert it back to list so it is immutable
    # Loop to find the primitive root
    for val in factors:
        ct = 0  # Initiate counter
        for x in factors:
            up = phi / x
            if (val**up) % anum == 1:
                break
            else:
                ct += 1
        if ct == len(factors):
            root = val
            break
    return root

def toAscii(txt):
    txt_list = list(txt)  # Convert the string to a list
    # A loop to convert each value in the text list into ascii value
    for idx, val in enumerate(txt_list):
        ascii_val = ord(val)
        txt_list[idx] = ascii_val  # Replacing the value with an ascii value
    return txt_list

# The function that converts ascii values to characters
def asciiToValue(ascii_list):
    # A loop to convert ascii values back to values
    for i, x in enumerate(ascii_list):
        val = chr(x)
        ascii_list[i] = val
    return ascii_list

# The encrypt function
def encrypt(txt, num):
    root = primitiveRoot(num)  # Retrieving the primitive root of the input number
    key = root % 128  # Get the remainder of primitive root modulus of 128
    ascii_list = toAscii(txt)  # Get the list of txt converted into ascii values
    new_ascii_list = list(np.array(ascii_list) + key)
    new_list = asciiToValue(new_ascii_list)  # Converting the new ascii list to character list
    new_txt = ''.join(new_list)
    # Print output
    print('The encrypted text -> {0}'.format(new_txt))

if __name__ == '__main__':
    main()
