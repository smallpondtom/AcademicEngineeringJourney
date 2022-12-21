### PROBLEM 2
# AUTHOR: Tomoki Koike
# DATE: OCT. 27 2019
# DESCRIPTION: This program creates an object called car and displays the user input and
#              computes the accelerated and decelerated speeds
###

# Main function
def main():
   # Accept user input
   [year_model, make] = getInputs()
   # Creating the object
   lexus = car(year_model, make)

   # Display the car data
   print()
   print('______ Car Data ______')
   print('Year Model: {0}'.format(lexus.get_year_model()))
   print('Make: {0}'.format(lexus.get_make()))
   print()

   # Call the methods in the object
   for x in range(5):
      lexus.accelerate()

   # Get the speed
   print('Current Speed: {0}'.format(lexus.get_speed()))

   # Call the brake method
   for x in range(5):
      lexus.brake()

   # Get the speed
   print('Current Speed: {0}'.format(lexus.get_speed()))

# Classes
class car():
   # Data attributes
   def __init__(self, year_model, make):
      self.__year_model = year_model
      self.__make = make
      self.__speed = 0

   # Accessor
   def get_year_model(self):
      return self.__year_model
   def get_make(self):
      return self.__make
   def get_speed(self):
      return self.__speed

   # Methods
   def accelerate(self):
      self.__speed += 5
      return self.__speed
   def brake(self):
      self.__speed -= 5
      return self.__speed

# Function
# Function to get user input
def getInputs():
   year_model = input('Enter the year model of your car -> ')
   make = input('Enter the make of your car -> ')
   return year_model, make

# Executing the main function
if __name__ == '__main__':
    main()

