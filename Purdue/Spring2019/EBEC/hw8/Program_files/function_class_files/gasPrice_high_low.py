# This function file will include the functions to compute the highest gas price in the data file along with the
# date as well as the minimum in the same manner
# Also it will sort the data from high to low or low to high

# Function to read the file
def read_file(file):
    # open the file
    afile = open(file, 'r')
    # Read the first line of the file
    aline = afile.readline()
    # Preallocating a dictionary to store the year as the keys and the
    # price of the gas as the values
    date_prices = {}
    # Loop to read all the lines in the file
    while aline != '':
        # Stripping the line break
        aline.rstrip('\n')
        # Creating the dictionary by reading the year and the price for each line
        # Slicing the string for the year
        date = aline[0:10]
        # Slicing the string for the price of the gas
        price = aline[11::]
        date_prices[date] = float(price)
        # Reading the next line in the file
        aline = afile.readline()
    # Closing the file
    afile.close()
    return date_prices

# Function to separate the dict into date and price
def get_date(adict):
    # Preallocate a new list
    date_list = []
    for key in adict:
        date_list.append(key)
    return date_list

def get_price(adict):
    # Preallocate the list
    price_list = []
    for key in adict:
        price_list.append(adict[key])
    return price_list

# Finding the index of the maximum
def max_index(price_list):
    return price_list.index(max(price_list))

# Finding the index of the minimum
def min_index(price_list):
    return price_list.index(min(price_list))


# Function to generate new file
def gen_new_file(price_list, date_list, newName):
    # Open file
    newfile = open(newName, 'w')
    for x in range(len(price_list)):
        newfile.write('DATE: {0} PRICE: {1:>5}'.format(date_list[x], price_list[x]) + '\n')
    # Closing new file
    newfile.close()

