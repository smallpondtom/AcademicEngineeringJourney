###
# AUTHOR: Tomoki Koike
# DUE: Oct. 3, 2019
# DESCRIPTION: This program includes a function that will calculate the greatest common divisor
# for the 2 input numbers.
###

# Main
def main():
    num1, num2 = [int(z) for z in input('Enter two integers to find the greatest common divisor -> ').split()]
    gcd = find_gcd(num1, num2)
    print('The greatest common divisor of {0} & {1} is {2}'.format(num1, num2, gcd))

# Functions
# GCD calculator
def find_gcd(num1, num2):
    # First distinguish which input variable is larger
    if num1 >= num2:
        high = num1
        low = num2
    else:
        high = num2
        low = num1
    # Calculating the mod/remainder of high and low division
    mod = high % low
    if mod != 0:
        # Recursive use of the find_gcd function
        low = find_gcd(low, mod)
        return low
    else:
        return low

if __name__ == "__main__":
    main()


