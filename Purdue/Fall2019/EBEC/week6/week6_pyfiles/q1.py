### PROBLEM 1
# AUTHOR: Tomoki Koike
# DATE: OCT 27 2019
# DESCRIPTION: This program will create a class called Pet and execute the functions in
#              in the class to see that they are working fine.
###

# Main function
def main():
    # Pet 1
    [name1, animal_type1, age1] = enterInputs()
    # Creating an object from the class
    pet1 = Pet(name1, animal_type1, age1)
    # Printing out the data of pet
    print()
    print('>>> PET DATA <<<')
    print('NAME: {0}'.format(pet1.get_name()))
    print('ANIMAL TYPE: {0}'.format(pet1.get_animal_type()))
    print('AGE: {0}'.format(pet1.get_age()))
    print()

    # Pet 2
    [name2, animal_type2, age2] = enterInputs()
    # Creating an object from the class
    pet2 = Pet(name2, animal_type2, age2)
    # Printing out the data of pet
    print()
    print('>>> PET DATA <<<')
    print('NAME: {0}'.format(pet2.get_name()))
    print('ANIMAL TYPE: {0}'.format(pet2.get_animal_type()))
    print('AGE: {0}'.format(pet2.get_age()))

# Class
class Pet():
    # Data attributes
    def __init__(self, name, animal_type, age):
        self.__name = name
        self.__animal_type = animal_type
        self.__age = age

    # Mutators
    def set_name(self, name):
        self.__name = name
    def set_animal_type(self, animal_type):
        self.__animal_type = animal_type
    def set_age(self, age):
        self.__age = age

    # Accessors
    def get_name(self):
        return self.__name
    def get_animal_type(self):
        return self.__animal_type
    def get_age(self):
        return self.__age

# Function
# Obtaining inputs from the user
def enterInputs():
    name = input('Please enter the name of your pet -> ')
    animal_type = input('Please enter the type of your pet -> ')
    age = input('Please enter the age of your pet -> ')
    return name, animal_type, age

# Executing the main function
if __name__ == '__main__':
    main()