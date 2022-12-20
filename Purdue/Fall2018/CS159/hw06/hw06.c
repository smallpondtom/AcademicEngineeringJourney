/******************************************************************************
* Assignment:  hw06
* Lab Section: 11:30, Tuesday, SC Hall
* Description: This program is designed to configure the lights in a dorm whether is turned on or if it is turned off with certain parameters. This accepts an user input of the user determining the room number that the RA goes through the rooms to turn on or off the room lights.
* Programmers: Tomoki Koike, koike@purdue.edu
*******************************************************************************/
#include <stdio.h>
#include <math.h>
#define SIZE 21

void initial_config(int []);
int inputRoom(int);
void switchOp(int, int [], int);
void output(int [], int);

int main(void)
{
  // Declarations
  int lightConfig[SIZE]; // light config
  int ct = 1;            // counter
  int roomNum;           // the user entered room number

  // Statements
  initial_config(lightConfig);
  
  do 
  {
    roomNum = inputRoom(ct);
    if (roomNum != -1)
    {
      switchOp(roomNum, lightConfig, ct); 
      ct++;
    }
  } while (roomNum != -1);

  printf("\n");
  output(lightConfig, ct - 1);
  printf("\n");
  return 0;

} // main

/******************************************************************************
* Function:    initial_config
* Description: This function prints out the initial configuration of the room lights.
* Parameters:  array, int, the initial configuration 
* Return:      void
******************************************************************************/
void initial_config(int array[])
{ 
  int i; // counter for the loop 

  printf("Enter light status for 21 rooms -> ");
  for (i = 0; i  < SIZE; i++)
  {
    scanf("%d", &array[i]);
  }
  
  return;
} // initial_config

/******************************************************************************
* Function:    inputRoom 
* Description: accepts the user input of the starting room number of the north route and south route.
* Parameters:  ct, int, the counter 
* Return:      int, the room number
******************************************************************************/
int inputRoom(ct)
{
  int roomNum; // the user entered room number
  
  if ((ct % 2) == 1)
  {
    do 
    {
      printf("Enter starting room for traveling north -> ");
      scanf("%d", &roomNum);

      if (roomNum % 2 == 0)
      {
        printf("\nError! Enter odd room numbers only!\n\n");
      }
    } while ((roomNum != -1) && ((roomNum + 1) % 2)); 
  }
  else if ((ct % 2) == 0)
  {
    do
    {
      printf("Enter starting room for traveling south -> ");
      scanf("%d", &roomNum);

      if (roomNum % 2 == 1)
      {
        printf("\nError! Enter even room numbers only!\n\n");
      }
    } while ((roomNum != -1) && (roomNum % 2));
  }
  return roomNum;
}  = csvread("M2_Data_Calibration_CoolingNoisy.csv");
tempCol = data(:,2);
timeCol = data(:,1);// inputRoom

/******************************************************************************
* Function:    switchOp
* Description: This is the function of the array operation that turns on or off the lights   
* Parameters:  roomNum, int, the user entered room number
*              array, int, the array with the light configuration
*              ct, int, the counter 
* Return:      
******************************************************************************/
void switchOp(int roomNum, int array[], int ct)
{
  int index;  // the index of the array
  // redefining the roomNum as an array
  index = roomNum % 100;

  if ((ct % 2) == 1)
  {
    while (index < SIZE)
    {
      if (array[index] == 1)
      {
        array[index] = 0;
        index += 2;
      }
      else
      {
        array[index] = 1;
        index += 2;
      }
    }
  }
  else if ((ct % 2) == 0)
  {
    while (index >= 0)
    {
      if (array[index] == 1)
      {
        array[index] = 0;
        index -= 2;
      }
      else
      {
        array[index] = 1;
        index -= 2;
      }
    }
  }
  return;
} // switchOp

/******************************************************************************
* Function:    output 
* Description: prints out the output results of the program
* Parameters:  array, int, the light configuration
*              RApass, int, the number of RA passes
* Return:      void
******************************************************************************/
void output(int array[], int RApass)
{
  int i; // counter
  
  printf("Total number of RA passes: %d\n", RApass);
  printf("Final Configuration: ");
  for (i = 0; i < SIZE; i++)
  {
    printf("%d ", array[i]);
  }
  return;
} // output
