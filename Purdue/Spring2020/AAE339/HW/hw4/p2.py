#!/usr/bin/env/ python
"""
This program calculates the integrations in the process of computing the adiabatic flame
temperature for problem 2.
"""
from scipy.integrate import quad

def nitrogen_Cp(theta):
    return 39.060-512.79*theta^(-1.5)+1072.7*theta^(-2)-820.40*theta^(-3)

def oxygen_Cp(theta):
    return 37.432+0.020102*theta^1.5-178.57*theta^(-1.5)+236.88*theta^(-2)

def carbon_dioxide_Cp(theta):
    return -3.7357+30.529*theta(0.5)-4.1034*theta+0.024198*theta^2

def water_vapor_Cp(theta):
    return 143.05-183.54*theta^0.25+82.751*theta^0.5-3.6989*theta

def calc_adiabatic_flame_temp(Tref, Tad)

def main():


if __name__ == '__main__':
     main()