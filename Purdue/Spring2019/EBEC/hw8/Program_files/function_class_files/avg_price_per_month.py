# This the function file to calculate the monthly average gas price

# Function to the file and create a dictionary for each month and price
def read_file(file):
    # open the file
    afile = open(file, 'r')
    # Read the first line of the file
    aline = afile.readline()
    # Preallocating a dictionary to store the month as the keys and the
    # price of the gas as the values
    month_prices = {}
    # Loop to read all the lines in the file
    while aline != '':
        # Stripping the line break
        aline.rstrip('\n')
        # Creating the dictionary by reading the year and the price for each line
        # Slicing the string for the month
        month = aline[0:2]
        # Slicing the string for the price of the gas
        price = aline[11::]
        # The loop to increment the value for the month-key or append a new key with price
        if month in month_prices:
            month_prices[month]['Total Price'] += float(price)
            month_prices[month]['Count'] += 1
        else:
            month_prices[month] = {}
            month_prices[month]['Total Price'] = float(price)
            month_prices[month]['Count'] = 1
        # Reading the next line in the file
        aline = afile.readline()
    # Closing the file
    afile.close()
    return month_prices

# Function to calculate the average for each month of the gas price
def month_avg_cal(adict):
    # Preallocating a new dict with the month and the average price
    month_avg = {}
    # Creating the dictionary by looping through the parameter
    for key in adict:
        month_avg[key] = adict[key]['Total Price'] / adict[key]['Count']
    return month_avg

# Function to get the array of years
def get_months(avg_adict):
    # Preallocate a new list
    month_list = []
    for key in avg_adict:
         month_list.append(int(key))
    return month_list

# Function to get the average values for each month from the dict
def get_avg_price(avg_dict):
    # Preallocate the list
    avg_price_list = []
    for key in avg_dict:
        avg_price_list.append(avg_dict[key])
    return avg_price_list

