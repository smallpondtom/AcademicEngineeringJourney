# This function contains private class that calculates the approximation of the
# numerical integration of a specific equation for a given interval of x-values.

# Importing modules
# This modulus will enable to evaluate specific functions
import sympy
from sympy.abc import x
# Module to conduct mathematical computations of sin and sqrt


class NumIntegrateTrapezoid:
    # Initialize parameters
    def __init__(self, steps, formula, x_start, x_end):
        # Steps/How many parts is the x interval divided into
        self.__steps = int(steps)
        # The function of f(x)
        self.__formula = formula
        # The initial x-value
        self.__x_start = float(x_start)
        # The final x-value
        self.__x_end = float(x_end)

    # Method to evaluate the formula for a specific formula
    def eval_formula(self, x_value):
        # Generating the function
        expr = self.__formula
        f = sympy.lambdify(x, expr)
        # Returning the evaluated function value by substituting x with a specific value
        return f(x_value)

    # Method to evaluate the increment for the numerical integration
    def eval_increment(self):
        # Returning the increment
        return (self.__x_end - self.__x_start)/self.__steps

    # Method to create the list of x-values increasing with the provided increment
    def eval_x_vals(self):
        # Preallocating the list to contain all the x-values
        x_list = []
        # Loop to construct the list of x-values
        for n in range(self.__steps + 1):
            x_list.append(self.__x_start + n * self.eval_increment())
        return x_list

    # Method to evaluate the numerical integration or the approximation using summation of series
    def eval_summ(self):
        # Initialize a value holder for the n-th value
        approx = 0
        # Obtain the list of x-values
        x_list = self.eval_x_vals()
        # Obtain the increment for the numerical integration
        increm = self.eval_increment()
        # Loop to conduct the summation
        for n in range(self.__steps):
            # The n-th y-value
            y_n = self.eval_formula(x_list[n])
            # The (n+1)-th y-value
            y_np1 = self.eval_formula(x_list[n+1])
            # Summation of series
            approx += 0.5 * (increm * (y_n + y_np1))
        # Returning the numerical integration value
        return approx

    # Mutator methods
    def set_steps(self, steps):
        self.__steps = steps
    def set_formula(self, formula):
        self.__formula = formula
    def set_x_start(self, x_start):
        self.__x_start = x_start
    def set_x_end(self, x_end):
        self.__x_end = x_end

    # Accessor methods
    def get_steps(self):
        return self.__steps
    def get_formula(self):
        return self.__formula
    def get_x_start(self):
        return self.__x_start
    def get_x_end(self):
        return self.__x_end

    # String method
    def __str__(self):
        line1 = 'The approximated area using the numerical integration for'
        line2 = ' the function '
        line3 = ' with a x-interval of '
        line4 = ' is: '
        return line1 + line2 + 'f(x) = ' + self.__formula + line3 \
               + '[' + format(self.__x_start, '.4f') + ':' + format(self.__x_end, '.4f')\
               + ']' + line4 + format(self.eval_summ(), '.4f')
