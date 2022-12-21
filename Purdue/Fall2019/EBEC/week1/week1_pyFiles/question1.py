###
# AUTHOR: Tomoki Koike
# DATE: Sept. 12, 2019
# DESCRIPTION: This program will generate a certain pattern of asterisks using nested loops
###

def main():
    # Set the range for the outer loop corresponding to the number of rows
    rows = 9
    # Loop creating the pattern
    for x in range(1, rows+1):
        print('#', end='')
        for y in range(x):
           if y == x-1:
               print('#')
           else:
               print(' ', end='')
if __name__ == '__main__':
    main()
