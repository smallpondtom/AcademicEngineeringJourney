## PROBLEM #2
# NAME: Tomoki Koike
# DUE: 4/30/2019
# DESCRIPTION: This program is designed to read the file GasPrices.txt
# and store the dates and the prices of the gas for each read line.
# Than use the matplotlib module to analyze the data, that is
# plotting graphs and printing out the maximum, minimum, and average.
# STAND: Class of 2020
##

# import modules
from pathlib import Path
import numpy as np
import matplotlib.pyplot as pylt
import ENG_beginners_level_course.HW8.function_class_files.avg_price_per_year as appy
import  ENG_beginners_level_course.HW8.function_class_files.avg_price_per_month as appm
import ENG_beginners_level_course.HW8.function_class_files.gasPrice_high_low as gphl

# Functions
# Main function
def main():
    # Enabling to read the text file in another directory
    data_dir = Path('C:\\CodingTomo\\python_folder\\ENG_beginners_level_course\\HW8\\text_files')
    file = data_dir / 'GasPrices.txt'
    # ----- Question 1 -----
    year_prices = appy.read_file(file)
    year_avg = appy.year_avg_cal(year_prices)
    year_list = appy.get_years(year_avg)
    year_avg_prices = appy.get_avg_price(year_avg)

    # Plotting the results
    pylt.bar(year_list, year_avg_prices, 0.5)
    pylt.title('Average Price of Gas by Year')
    pylt.xlabel('Years')
    pylt.ylabel('Gas Prices ($)')
    pylt.show()

    # ----- Question 2 -----
    month_prices = appm.read_file(file)
    month_avg = appm.month_avg_cal(month_prices)
    month_list = appm.get_months(month_avg)
    month_avg_prices = appm.get_avg_price(month_avg)
    # Sorting the month_list into order and prices accordingly
    month_list_np = np.array(month_list)
    ind = np.argsort(month_list_np)
    month_list_np = month_list_np[ind]
    month_avg_prices_np = np.array(month_avg_prices)
    month_avg_prices_np = month_avg_prices_np[ind]

    # Plotting the results
    pylt.plot(month_list_np, month_avg_prices_np, '-or')
    pylt.title('Average Price of Gas by Month')
    pylt.xlabel('Months')
    pylt.ylabel('Gas Prices ($)')
    pylt.xticks([1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12],
                ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug', 'Sep', 'Oct', 'Nov', 'Dec'])
    pylt.show()

    # ----- Question 3 -----
    date_prices = gphl.read_file(file)
    date_list = gphl.get_date(date_prices)
    price_by_date_list = gphl.get_price(date_prices)
    # Getting the maximum value and its date
    max_ind = gphl.max_index(price_by_date_list)
    max_price_by_date = price_by_date_list[max_ind]
    max_price_date = date_list[max_ind]
    # Getting the minimum value and its date
    min_ind = gphl.min_index(price_by_date_list)
    min_price_by_date = price_by_date_list[min_ind]
    min_price_date = date_list[min_ind]
    # Result
    print('----- Q 3 -----')
    print('The maximum price and its date is: {0} at {1}'.format(max_price_by_date, max_price_date))
    print('The minimum price and its date is: {0} at {1}'.format(min_price_by_date, min_price_date))

    # ----- Question 4 -----
    # Sorting the dates and price into low to high
    price_by_date_list_np = np.array(price_by_date_list)
    price_by_date_list_np = price_by_date_list_np[np.argsort(price_by_date_list_np)]
    date_list_np = np.array(date_list)
    date_list_np = date_list_np[np.argsort(price_by_date_list_np)]
    # Creating a new file
    # Select the text file directory to save file
    newfile1 = data_dir / 'GasPrices_low_to_high.txt'
    gphl.gen_new_file(price_by_date_list_np, date_list_np, newfile1)

    # ----- Question 5 -----
    # Sorting the dates and price into high to low just reverse the previous lists
    date_list_np = date_list_np[::-1]
    price_by_date_list_np = price_by_date_list_np[::-1]
    # Create new file
    # Select the text file directory to save file
    newfile2 = data_dir / 'GasPrices_high_to_low.txt'
    gphl.gen_new_file(price_by_date_list_np, date_list_np, newfile2)

# Executing the main
if __name__ == '__main__':
    main()