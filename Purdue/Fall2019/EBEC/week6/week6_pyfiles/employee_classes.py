# This is the python file with the classes that have the
# classes that we are instructed to create

class Employee:
    # Data attributes
    def __init__(self, EmployeeName, EmployeeNum):
        self.__EmployeeName = EmployeeName
        self.__EmployeeNum = EmployeeNum

    # Mutators
    def set_EmployeeName(self, EmployeeName):
        self.__EmployeeName = EmployeeName
    def set_EmployeeNum(self, EmployeeNum):
        self.__EmployeeNum = EmployeeNum

    # Accessors
    def get_EmployeeName(self):
        return self.__EmployeeName
    def get_EmployeeNum(self):
        return self.__EmployeeNum

# Subclass for production employee
class ProductionWorker(Employee):
    # Data attriubtes
    def __init__(self, shiftNum, hr_pay_rate, EmployeeName, EmployeeNum):
        Employee.__init__(self, EmployeeName, EmployeeNum)
        self.__shiftNum = shiftNum
        self.__hr_pay_rate = hr_pay_rate

    # Mutators
    def set_shiftNum(self, shiftNum):
        self.__shiftNum = shiftNum
    def set_hr_pay_rate(self, hr_pay_rate):
        self.__hr_pay_rate = hr_pay_rate

    # Accessor
    def get_shiftNum(self):
        return self.__shiftNum
    def get_hr_pay_rate(self):
        return self.__hr_pay_rate

# Subclass for shift supervisor
class ShiftSupervisor(Employee):
    # Data attributes
    def __init__(self, yearSal, yearBonus, EmployeeName, EmployeeNum):
        Employee.__init__(self, EmployeeName, EmployeeNum)
        self.__yearSal = yearSal
        self.__yearBonus = yearBonus

    # Mutator
    def set_yearSal(self, yearSal):
        self.__yearSal = yearSal
    def set_yearBonus(self, yearBonus):
        self.__yearBonus = yearBonus

    # Accessor
    def get_yearSal(self):
        return self.__yearSal
    def get_yearBonus(self):
        return self.__yearBonus