# This the function file to calculate the annual average gas price

# Function to the file and create a dictionary for each year and price
def read_file(file):
    # open the file
    afile = open(file, 'r')
    # Read the first line of the file
    aline = afile.readline()
    # Preallocating a dictionary to store the year as the keys and the
    # price of the gas as the values
    year_prices = {}
    # Loop to read all the lines in the file
    while aline != '':
        # Stripping the line break
        aline.rstrip('\n')
        # Creating the dictionary by reading the year and the price for each line
        # Slicing the string for the year
        year = aline[6:10]
        # Slicing the string for the price of the gas
        price = aline[11::]
        # The loop to increment the value for the year-key or append a new key with price
        if year in year_prices:
            year_prices[year]['Total Price'] += float(price)
            year_prices[year]['Count'] += 1
        else:
            year_prices[year] = {}
            year_prices[year]['Total Price'] = float(price)
            year_prices[year]['Count'] = 1
        # Reading the next line in the file
        aline = afile.readline()
    # Closing the file
    afile.close()
    return year_prices

# Function to calculate the average for each year of the gas price
def year_avg_cal(adict):
    # Preallocating a new dict with the year and the average price
    year_avg = {}
    # Creating the dictionary by looping through the parameter
    for key in adict:
        year_avg[key] = adict[key]['Total Price'] / adict[key]['Count']
    return year_avg

# Function to get the array of years
def get_years(avg_adict):
    # Preallocate a new list
    year_list = []
    for key in avg_adict:
        year_list.append(int(key))
    return year_list

# Function to get the average values for each year from the dict
def get_avg_price(avg_dict):
    # Preallocate the list
    avg_price_list = []
    for key in avg_dict:
        avg_price_list.append(avg_dict[key])
    return avg_price_list

