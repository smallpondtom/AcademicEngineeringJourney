## PROBLEM #1
# NAME: Tomoki Koike
# DUE: 4/30/2019
# DESCRIPTION: This is an execution file for problem one of homework 8.
# This will execute the functions that will calculate the numerical integration
# for specific functions and x intervals.
# STAND: Class of 2020
##

# Importing the function created mainly for this problem.
# This file is inside a subdirectory of HW8
# named function_class_files
import ENG_beginners_level_course.HW8.function_class_files.num_integrate_trapezoid as num_intg_trap
# Import math module for advanced mathematical computations
import math

# Functions
# Function for input validation
def getValid(prompt, a, b):
    while True:
        try:
            # Trying input with no constraints
            this = input(prompt)
        except ValueError:
            # Invalid input
            print('Sorry, could not understand input. Please try again.')

        # Adding constraints
        if a == 'none':
            if int(this) < 0:
                # Invalid input
                print('Error. Please enter a value equal to or greater than 0.')
                continue
            else:
                # Valid input
                break
        else:
            if this < a:
                # Invalid input
                print('Error. Final value must being greater than initial.')
                continue
            else:
                # valid input
                break
    return this


# Main function
def main():
    # Assumption
    print('The steps for the numerical integration is 1000')
    print()

    # -----Question 1-----
    print('----- Q1 -----')
    formula1 = 'x*2'
    steps1 = 1000
    x_start1 = 0
    x_end1 = 1
    # Creating NumIntegrateTrapezoid object
    approx1 = num_intg_trap.NumIntegrateTrapezoid(steps1, formula1, x_start1, x_end1)
    # Getting the approximation
    approx1.eval_summ()
    # Printing the result
    print(approx1)

    # -----Question 2-----
    print('----- Q2 -----')
    formula2 = 'sin(x)'
    steps2 = 1000
    x_start2 = 0
    x_end2 = math.pi/2
    # Creating NumIntegrateTrapezoid object
    approx2 = num_intg_trap.NumIntegrateTrapezoid(steps2, formula2, x_start2, x_end2)
    # Getting the approximation
    approx2.eval_summ()
    # Printing the result
    print(approx2)

    # -----Question 3-----
    print('----- Q3 -----')
    formula3 = 'sin(x)'
    steps3 = 1000
    x_start3 = 0
    x_end3 = math.pi
    # Creating NumIntegrateTrapezoid object
    approx3 = num_intg_trap.NumIntegrateTrapezoid(steps3, formula3, x_start3, x_end3)
    # Getting the approximation
    approx3.eval_summ()
    # Printing the result
    print(approx3)

    # -----Question 4-----
    print('----- Q4 -----')
    # Get the user inputs
    formula4 = input('Please enter the function of x to investigate -> ')
    steps4 = 1000
    x_start4 = getValid('What is the initial value of x? -> ', 'none', 'none')
    x_end4 = getValid('What is the final value of x? -> ', x_start4, 'none')
    # Creating NumIntegrateTrapezoid object
    approx4 = num_intg_trap.NumIntegrateTrapezoid(steps4, formula4, str(x_start4), str(x_end4))
    # Getting the approximation
    approx4.eval_summ()
    # Printing the result
    print(approx4)

# Calling main function
if __name__ == '__main__':
    main()