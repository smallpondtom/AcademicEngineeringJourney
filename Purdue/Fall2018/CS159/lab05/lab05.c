
/******************************************************************************
* Assignment:  LAB 05
* Lab Section: Tuesday, 11:30 am, SC Hall 189
* Description: verbose description of what the program does
* Programmers: Tomoki Koike koike@purdue.edu
*              Lauren Anderson ander867@purdue.edu
******************************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

int input(void); // gathers input number from use
int randomGen(int, int); // generates random number
int scale(int, int); // scales random numbers
int selectAngle(int); // generates loft angle
double travelTime(int, double); // calculates ball travel time
double travelDistance(double, double, double); // calculates ball distance
int rank1Gen(int, int, int); // calculates rank for golfer 1
int rank2Gen(int, int, int); // calculates rank for golfer 2
int rank3Gen(int, int, int); // calculates rank for golfer 3
double distanceHole(int, double); // calculates distance from hole

int main ()
{
  // declarations
  int seed;            //the seed for the random number
  int clubNum1;        //the random club # from 1 to 3 
  int clubNum2;        //the random club # from 1 to 3
  int clubNum3;        //the random club # from 1 to 3
  int scaleDistance;   //the random distance from 300 to 500 (m)
  int randAngles1;     //the generated random angles #1  
  int randAngles2;     //the generated random angles #2
  int randAngles3;     //the generated random angles #3
  int randVel1;        //the generated random velocity #1
  int randVel2;        //the generated random velocity #2
  int randVel3;        //the generated random velocity #3
  double time1;        //the travel time of golfer 1
  double time2;        //the travel time of golfer 2
  double time3;        //the travel time of golfer 3
  double distance1;    //the travel distance of golfer 1
  double distance2;    //the travel distance of golfer 2
  double distance3;    //the travel distance of golfer 3
  double fromHole1;    //the distance from the hole of golfer 1
  double fromHole2;    //the distance from the hole of golfer 1
  double fromHole3;    //the distance from the hole of golfer 1
  int rank1;           //the rank of golfer1
  int rank2;           //the rank of golfer2
  int rank3;           //the rank of golfer3  

  //Statements
  //user inputs random seed with input() 
  seed = input();
  srand(seed);

  //generates random distance from 300m to 500m
  scaleDistance =  randomGen(300, 500);
  printf("\nDistance to the hole: %d m\n", scaleDistance);
  
  //generates the random values for the first golfer
  clubNum1 = randomGen(1,3);  //random club number
  randAngles1 = selectAngle(clubNum1); //the random angle
  randVel1 = randomGen(40, 60);
  
  //generates the random values for the second golfer 
  clubNum2 = randomGen(1,3);  //random club number
  randAngles2 = selectAngle(clubNum2); //the random angle
  randVel2 = randomGen(40, 60);

  //generates the random values for the third golfer 
  clubNum3 = randomGen(1,3);  //random club number
  randAngles3 = selectAngle(clubNum3); //the random angle
  randVel3 = randomGen(40, 60);

  //printing details #1
  printf("\nGolfer  Club  Loft Angle  Velocity\n");
  printf("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n");
  printf("  1:%7d%9d%10d m/s\n", clubNum1, randAngles1, randVel1);
  printf("  2:%7d%9d%10d m/s\n", clubNum2, randAngles2, randVel2 );
  printf("  3:%7d%9d%10d m/s\n", clubNum3, randAngles3, randVel3 );
  printf("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n");
 
  //calculating the travel times
  time1 = travelTime(randVel1, randAngles1);
  time2 = travelTime(randVel2, randAngles2);
  time3 = travelTime(randVel3, randAngles3);
 
  //calculating the travel distance
  distance1 = travelDistance(randVel1, randAngles1, time1);
  distance2 = travelDistance(randVel2, randAngles2, time2);
  distance3 = travelDistance(randVel3, randAngles3, time3);
  
  //calculating the distance from hole
  fromHole1 = distanceHole(scaleDistance, distance1);
  fromHole2 = distanceHole(scaleDistance, distance2);
  fromHole3 = distanceHole(scaleDistance, distance3);

  //calculating the ranks of each golfer
  rank1 = rank1Gen(fromHole1, fromHole2, fromHole3);
  rank2 = rank2Gen(fromHole1, fromHole2, fromHole3);
  rank3 = rank3Gen(fromHole1, fromHole2, fromHole3);
  
  //printing details #2
  printf("Golfer   Time     Travel Distance   Distance From Hole  Rank\n");
  printf("-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=-=\n");
  printf("  1:%8.2lf s %12.1lf m %17.1lf m %9d \n", time1, distance1, fromHole1, rank1);
  printf("  2:%8.2lf s %12.1lf m %17.1lf m %9d \n", time2, distance2, fromHole2, rank2);
  printf("  3:%8.2lf s %12.1lf m %17.1lf m %9d \n", time3, distance3, fromHole3, rank3);    
  
  return 0;
}

/******************************************************************************
* Function:     input
* Description: gathers input number from user
* Parameters:  void
* Return:      int, gathers input from user for the seed
******************************************************************************/
int input(void)
{
  int seed; // seed from input of user for random number generation
  printf("Enter a seed -> ");
  scanf("%d", &seed);
 
  return seed;
} // input
 
/******************************************************************************
* Function:    randomGen
* Description: generates random number
* Parameters:  num1, int, minimum number for scale
*              num2, int, maximum number for scale
* Return:      int, gathers min and max and uses scale function to scale values
******************************************************************************/
int randomGen(int num1, int num2)
{
  int scaleNum; // scale of numbers for random number generation
  scaleNum = scale(num1, num2);
  return scaleNum;
} // randomGen

/******************************************************************************
* Function:    scale
* Description: scales numbers for random generation
* Parameters:  from, int, smallest number for scale
*              to, int, largest number for scale
* Return:      int, scales numbers in between min and max range
******************************************************************************/
int scale(int from, int to)
{ 
  int range; // range of numbers for scale
  range = to - from + 1;
  return rand() % range + from;
} // scale

/******************************************************************************
* Function:    selectAngle
* Description: generates loft angle
* Parameters:  clubNum, int, club number
* Return:      int, generates random angle for specfic club number
******************************************************************************/
int selectAngle(int clubNum)
{
  int scaleAngle; // angle of lofted golf ball
 
  scaleAngle = randomGen(8 + (clubNum - 1) * 5 , 13 + (clubNum - 1) * 5);

  return scaleAngle;
} // selectAngle

/******************************************************************************
* Function:    travelTime
* Description: calculates time of travel of golf ball
* Parameters:  randomVel, int, velocity of ball
*              scaleAngle, double, angle of ball
* Return:      double, calculates time of travel using velocity and angle of ball
******************************************************************************/
double travelTime(int randomVel, double scaleAngle)
{
  float g = 9.8; //acceleration of gravity
  double time;    //the travel time 
  
  time = 2 * randomVel * sin(scaleAngle / 180 * M_PI) / g;
  // calculated time traveled of golf ball
  return time;
} // travelTime

/******************************************************************************
* Function:    travelDistance
* Description: calculates the traveled distance of the golf ball
* Parameters:  randomVel, double, velocity of ball
*              scaleAngle, double, angle of ball
*              travelTime, double, travel time of ball
* Return:      double, calculates traveled distance using velocity, angle and time
******************************************************************************/
double travelDistance(double randomVel, double scaleAngle, double travelTime)
{
  double travelDistance = randomVel * cos(scaleAngle / 180 * M_PI) * travelTime;  // calculated traveled distance
  return travelDistance;
} // travelDistance

/******************************************************************************
* Function:    rank1Gen
* Description: generates the rank of golfer 1
* Parameters:  distance1, int, distance of golf ball 1 from hole
*              distance2, int, distance of golf ball 2 from hole
*              distance3, int, distance of golf ball 3 from hole
* Return:      int, calculates rank of golfer 1 based off of distances from hole of each golf ball
******************************************************************************/
int rank1Gen(int fromHole1, int fromHole2, int fromHole3)
{
  int rank1; // rank of golfer 1 calculation
  rank1 = (fromHole1 / (fromHole2 + 1) + fromHole1 / (fromHole3 + 1) + 1);
  return rank1;
} // rank1Gen

/******************************************************************************
* Function:    rank2Gen
* Description: generates the rank of golfer 2
* Parameters:  distance1, int, distance of golf ball 1 from hole
*              distance2, int, distance of golf ball 2 from hole
*              distance3, int, distance of golf ball 3 from hole
* Return:      int, calculates rank of golfer 2 based off of distances from hole of each golf ball
******************************************************************************/
int rank2Gen(int fromHole1, int fromHole2, int fromHole3)
{
  int rank2; // rank of golfer 2 calculation
  rank2 = (fromHole2 / (fromHole3 + 1) + fromHole2 / (fromHole1 + 1) + 1);
  return rank2;
} // rank2Gen

/******************************************************************************
* Function:    rank3Gen
* Description: generates the rank of golfer 3
* Parameters:  distance1, int, distance of golf ball 1 from hole
*              distance2, int, distance of golf ball 2 from hole
*              distance3, int, distance of golf ball 3 from hole
* Return:      int, calculates rank of golfer 3 based off of distances from hole of each golf ball
******************************************************************************/
int rank3Gen(int fromHole1, int fromHole2, int fromHole3)
{
  int rank3; // rank of golfer 3 calculation
  rank3 = (fromHole3 / (fromHole2 + 1) + fromHole3 / (fromHole1 + 1) + 1);
  return rank3;
} // rank3Gen

/******************************************************************************
* Function:    distanceHole
* Description: calculates distance from hole the golf ball is
* Parameters:  scaleDistance, int, total distance
*              distance, double, distance traveled
* Return:      double, calculates distance from whole using total distance minus distance traveled
******************************************************************************/
double distanceHole(int scaleDistance, double distance)
{
  double distanceFromHole; // calculated distance from hole variable

  distanceFromHole = scaleDistance - distance;
  return distanceFromHole;
} // distanceHole
