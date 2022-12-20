/******************************************************************************
* Assignment:  Homework#2
* Lab Section: Tuesday, 11:30, SC Hall 189
* Description: This program aims to calculate the length of the string 
* of a pendulum(consisting of a mass hanging from the ceiling with a string)
* with its period and also calculating the period of from its string length.
* Programmers: Tomoki Koike koike@purdue.edu
*             
*              
******************************************************************************/

#include <stdio.h>
#include <math.h>

int main(void)
{
  //Local Declarations
  double L_or_P;     //The length of the string or the period inputted by user  
  double period;     //The period of the pendulum
  double length;     //The length of the pendulum 
  double result;     //The calculated result either a period or a length
  int a;             //The option number inputted by user       
  char value1;       //The values or m for the entered value
  char value2;       //The values or m for the resulting value
  double freq;       //The frequency of the pendulum

  //Statements 
  printf("Pendulum Calculations\n");
  printf("1. Given period calculate length\n");
  printf("2. Given length caluculate period\n");
  printf("Enter your option now -> ");
  scanf("%i", &a);

  value1 = 115 + (a - 1) * (-6);

  printf("\n\nEnter value in %c -> ", value1);
  scanf("%lf", &L_or_P );
  
  value2 = 109 + (a - 1) * 6;
  period = 2 * M_PI * sqrt(L_or_P / 9.8);
  length = L_or_P * L_or_P / 4 / M_PI / M_PI * 9.8 * (2 - a);
  result = period * (a - 1) + length;
  freq = ((a - 1) / period) + ((2 - a) / L_or_P);

  printf("\n\nGiven value: %.2lf %c\n", L_or_P, value1);
  printf("Resulting value: %.2lf %c\n", result, value2);
  printf("Frequency: %.4lf Hz\n", freq);

  return 0;
} //main

