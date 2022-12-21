## PROBLEM #3
# NAME: Tomoki Koike
# DUE: 4/30/2019
# DESCRIPTION: This program is designed to import a module that
# enables us to create an object which manipluates the employee data.
# STAND: Class of 2020
##

# Importing the module
import ENG_beginners_level_course.HW8.function_class_files.employee_classes as empC

def main():
    # User inputs
    # Production worker
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    employeeName = input('Please enter the name of the employee -> ')
    employeeNum = input('Please enter the number of the employee -> ')
    shiftNum = input('Please enter the shift number for the production worker -> ')
    hrPayRate = input('Please enter the hour pay rate for this production worker -> ')

    # Creating the object
    print()
    prodWorkerData = empC.ProductionWorker(shiftNum, hrPayRate, employeeName, employeeNum)
    # Mutator and Accessor methods called
    prodWorkerData.set_EmployeeName(employeeName)
    print(prodWorkerData.get_EmployeeName())
    prodWorkerData.set_EmployeeNum(employeeNum)
    print(prodWorkerData.get_EmployeeNum())
    prodWorkerData.set_shiftNum(shiftNum)
    print(prodWorkerData.get_shiftNum())
    prodWorkerData.set_hr_pay_rate(hrPayRate)
    print(prodWorkerData.get_hr_pay_rate())
    print()
    # print
    line1 = 'Employee Name: {0} >> Employee Number: {1}'
    line2 = '-------> Production worker'
    line3 = 'Shift #: {0} \n Hour pay rate: {1}'
    print(line1.format(employeeName, employeeNum) + '\n' + line2 + '\n' + line3.format(shiftNum, hrPayRate))

    # Shift Supervisor
    # user inputs
    print('-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-')
    employeeName = input('Please enter the name of the employee -> ')
    employeeNum = input('Please enter the number of the employee -> ')
    yearSal = input('Please enter the annual salary of the shift supervisor -> ')
    yearBonus = input('Please enter the annual bonus of this shift supervisor -> ')

    # Creating the object
    print()
    shiftAdvisorData = empC.ShiftSupervisor(yearSal, yearBonus, employeeName, employeeNum)
    # Mutator and Accessor methods called
    shiftAdvisorData.set_EmployeeName(employeeName)
    print(shiftAdvisorData.get_EmployeeName())
    shiftAdvisorData.set_EmployeeNum(employeeNum)
    print(shiftAdvisorData.get_EmployeeNum())
    shiftAdvisorData.set_yearSal(yearSal)
    print(shiftAdvisorData.get_yearSal())
    shiftAdvisorData.set_yearBonus(yearBonus)
    print(shiftAdvisorData.get_yearBonus())
    print()

    # Printing results
    line1 = 'Employee Name: {0} >> Employee Number: {1}'
    line2 = '-------> Shift Supervisor'
    line3 = 'Annual Salary: {0} \n Annual Bonus: {1}'
    print(line1.format(employeeName, employeeNum) + '\n' + line2 + '\n' + line3.format(yearSal, yearBonus))

if __name__ == '__main__':
    main()
