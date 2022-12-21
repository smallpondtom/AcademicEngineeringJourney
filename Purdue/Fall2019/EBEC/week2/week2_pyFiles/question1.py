###
# AUTHOR: Tomoki Koike
# DATE: Sept. 19, 2019
# DESCRIPTION: This program will include a function that analyzes a matrix and determine
# wether or not the matrix identifies as a Lo Shu Magic Square. That is, whether or not
#  the sum of the rows, cols, and diagonals add up to be all the same.
###

# The function
def is_loShuMagicSq(a_matrix):
        # Initializing a inidcator of whether or not it is a Lo Shu Magic Square
        sgn = 1
        # Required sum is 15
        sum_req = 15
        # Finding the sum in the rows
        for x in a_matrix:
                magic_sum = sum(x) # Summing the entire rows
                hold = magic_sum # Placeholder for the summed value
                if hold != sum_req:
                        sgn = 0 # If its not a magic square set indicator to zero
                        break # Exit loop
        magic_sum = 0 # Reset this value
        # Finding the sum in columns
        if sgn == 1:
                for x in range(3):
                        magic_sum = 0 # Reset the magic_sum
                        for y in range(3):
                                magic_sum += a_matrix[y][x]
                        hold = magic_sum
                        if hold != sum_req:
                                sgn = 0
                                break
        # Finding the sum in the diagonals
        if sgn == 1:
                if a_matrix[0][0]+a_matrix[1][1]+a_matrix[2][2] != sum_req:
                        sgn = 0
                if a_matrix[0][2]+a_matrix[1][1]+a_matrix[2][0] != sum_req:
                        sgn = 0
        # Print out conclusion
        if sgn == 0:
                print('This matrix is not a Lo Shu Magic Square.')
        else:
                print('This matrix is a Lo Shu Magic Square.')
