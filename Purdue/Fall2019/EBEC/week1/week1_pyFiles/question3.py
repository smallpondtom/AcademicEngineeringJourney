###
# AUTHOR: Tomoki Koike
# DATE: Sept. 12, 2019
# DESCRIPTION: This python program will tranpose a certain matrix and also conduct a matrix multiplication
###

def main():
    # Define matrix M
    M = [[2, -5, 8, 11], [3, 7, -9, -5], [4, 0, -1, 7]]
    # Defining the number of rows and columns
    rows = 3
    cols = 4
    # Create an empty matrix to use in part b
    M_t = [[0,0,0],[0,0,0],[0,0,0],[0,0,0]]

    print('---PART A---')
    #<a>
    # Nested loops to transpose the matrix
    for x in range(cols):
        for y in range(rows):
            temp = M[y][x]
            M_t[x][y] = temp
            print(temp, '   ', end='')
            # The if statement below is just to make the output neater
            if temp < 10 and temp > 0:
                print(' ', end='')
        print()

    print()
    print('---PART B---')
    #<b>
    # Nested loop to conduct a matrix multiplication
    for x in range(rows):
        temp = 0 # Initialize temporary place holder
        for y in range(cols):
            temp += M[x][y] * M_t[y][x]
        print(temp)

if __name__ == '__main__':
    main()
