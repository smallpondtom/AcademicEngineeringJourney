
/******************************************************************************
* Assignment:  HW03
* Lab Section: Tuesday, 11:30, SC Hall
* Description: This program calculates the length and the period of a pendulum made by different materials: brass, steel, or aluminum. The lengths to periods will be calculated for when the rods change its length due to linear expansion.
* Programmers: Tomoki Koike  koike@purdue.edu
*              
******************************************************************************/

#include <stdio.h>
#include <math.h>
#include <stdlib.h>

//Function Declarations 
double input_length(void);
double input_tempI(void);
double input_tempF(void);
double periodCal(double length);
double linExp(double lengthRod, double coeff, double tempI, double tempF);
double output(double length, double period);

int main()
{
  //Local Declarations 
  double lengthI;     // The initial length of the rod 
  double tempI;       // The initial temperature
  double tempF;       // The final temperature
  double orgnPeriod;  // The original period calculated from the initial state
  double lengthBrass; // The length of brass rod at final temperature 
  double lengthSteel; // The length of steel rod at final temperature
  double lengthAl;    // The length of aluminum rod at final temperature 
  double coeffBrass = 19.0 * pow(10, -6);  // The average coefficient of linear expansion of brass
  double coeffSteel = 11.0 * pow(10, -6);  // The average coefficient of linear expansion of steel
  double coeffAl = 24.0 * pow(10, -6);     // The average coefficient of linear expansion of aluminum
  double periodBrass; // The new period for the brass pendulum
  double periodSteel; // The new period for the steel pendulum
  double periodAl;    // The new period for the aluminum pendulum
  
  // receive the user's entered values: length, initial and final temperature 
  lengthI = input_length();
  tempI = input_tempI();
  tempF = input_tempF();
  
  // calculate the period from original length and temperature
  orgnPeriod = periodCal(lengthI);

  // Statements
  // printing the entered data and the calculated period from those data
  printf("\nOriginal length: %.2lf m\n", lengthI);
  printf("Original period: %.2lf s\n", orgnPeriod);
  printf("Original temperature: %.2lf C\n", tempI);
  printf("Ending temperature: %.2lf C\n", tempF); 
  
  // calculating the new length of rod due to linear expansion
  // new length of brass
  lengthBrass = linExp(lengthI, coeffBrass, tempI, tempF);
  // new length of steel
  lengthSteel = linExp(lengthI, coeffSteel, tempI, tempF);
  // new length of aluminum
  lengthAl = linExp(lengthI, coeffAl, tempI, tempF);

  // calculating the new  periods for each material 
  // new period for brass
  periodBrass = periodCal(lengthBrass);
  // new period for steel 
  periodSteel = periodCal(lengthSteel);
  // new period for aluminum
  periodAl = periodCal(lengthAl);
  
  // Printing the results from the calculations
  // Brass
  printf("\nBrass rod new length: %.4lf m\n", lengthBrass);
  printf("Brass rod new period: %.4lf s\n", periodBrass);
  // Steel
  printf("\nSteel rod new length: %.4lf m\n", lengthSteel);
  printf("Steel rod new period: %.4lf s\n", periodSteel);
  // Aluminum
  printf("\nAluminum rod new length: %.4lf m\n", lengthAl);
  printf("Aluminum rod new length: %.4lf s\n", periodAl);

  return 0;
}

/******************************************************************************
* Function:    input_length
* Description: Receives a number to calculate from the user
* Parameters:  none 
* Return:      double containing the user's entered number for the length
******************************************************************************/
double input_length(void)
{
  double lengthI;  // The initial length of the rod entered
    
  // Prompt the user and receive the user's response 
  printf("Enter starting length of pendulum (m) -> ");
  scanf("%lf", &lengthI);
  
  return lengthI;
}

/******************************************************************************
* Function:    input_tempI
* Description: Receives a number to calculate from the user
* Parameters:  none
* Return:      double containing the user's entered number for the initial temperature
******************************************************************************/
double input_tempI(void)
{
  double tempI;  // The initial temperature entered

  // Prompt the user and receive the user's response
  printf("Enter the starting temperature (C) -> ");
  scanf("%lf", &tempI);
  
  return tempI;
}

/******************************************************************************
* Function:    input_tempF
* Description: Receives a number to calculate from the user
* Parameters:  none
* Return:      double containing the user's entered number for the final temperature
*******************************************************************************/
double input_tempF(void)
{
  double tempF; // The final temperature

  // Prompt the user and receive the user's response
  printf("Enter the ending temperature (C) -> ");
  scanf("%lf", &tempF);
  
  return tempF;
}

/******************************************************************************
* Function:    periodCal
* Description: calculates the period with any given length of pendulum
* Parameters:  length - the given length of the pendulum
* Return:      period containing the calculated period 
******************************************************************************/
double periodCal(double length)
{
  double period; // the period calculated from the length of pendulum

  // calculation of the period 
  period = 2 * M_PI * sqrt(length / 9.8);

  return period;
}

/******************************************************************************
* Function:    linExp
* Description: Calculates the new length of the pendulum with any material using the initial and final temperatures and average coefficient of linear expansion.
* Parameters:  lengthRod, double, the length of the pendulum
*              coeff, double, the given average coefficient of linear expansion
*              tempI, double, the given initial temperature 
*              tempF, double, the given final temperature
* Return:      data type and description
******************************************************************************/
double linExp(double lengthRod, double coeff, double tempI, double tempF)
{
  double newLength;  // the calculated new length of pendulum
  
  // calculation
  newLength = lengthRod + lengthRod * coeff * (tempF - tempI);

  return newLength;
}
