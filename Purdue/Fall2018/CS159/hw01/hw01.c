
/******************************************************************************
* Assignment:  hw01
* Lab Section: 11:30, Tuesday, SC 189
* Description: This program calculates the eccentricity, surface area, volume,
* and the surface to volume ratio from the enter value of equatorial and polar radius.
* This is the demonstration of a raindrop deformed primarily by the drag force and
* taking the shape of an oblate spheroid.
* Programmers: Tomoki Koike koike@purdue.edu
*              
*              
******************************************************************************/

#include <stdio.h>
#include <math.h>
#define PI 3.141592 //M_PI di not work on my program it would give me an error whenever I compiled the program 

int main (void)
{
  //local Declarations 
  double eqRadius;          //the equatorial radius of the oblate spheroid
  double polRadius;         //the polar radius of the oblate spheroid 
  double eccnt;             //the eccentricity of the oblate spheroid
  double eccntPercent;      //the eccentricity in percentage of the oblate spheroid 
  double area;              //the surface area of the oblate spheroid 
  double vol;               //the volume of the oblate spheroid 
  double area_to_vol;       //the surface area to volume ratio of the oblate spheroid

  //Statements
  printf("\nEnter equatorial radius (mm) ->  ");
  scanf("%lf", &eqRadius);
  printf("Enter polar radius (mm) -> "); 
  scanf("%lf", &polRadius);

  eccnt = sqrt(1 - polRadius * polRadius  / eqRadius /  eqRadius);                                               //the calculation for the eccentricity
  eccntPercent = eccnt * 100;                                                                                    //the calculation to convert eccentricity into percentage
  area = 2 * PI  * eqRadius * eqRadius  + PI * polRadius * polRadius  / eccnt * log((1 + eccnt) / (1 - eccnt));  //the calculation for the surface area
  vol  = 4 * PI * eqRadius * eqRadius * polRadius / 3;                                                           //the calculation for the volume 
  area_to_vol  = area / vol;                                                                                     //the calculation for the surface area to volume ratio

  printf("\nEccentricity: %1.2lf%%", eccntPercent);
  printf("\nSurface area: %.3lf mm^2 ", area);
  printf("\nVolume: %.3lf mm^3 ", vol);
  printf("\nSurface-to-Volume ratio: %.3lf\n", area_to_vol);

  return 0; 

}  //main

