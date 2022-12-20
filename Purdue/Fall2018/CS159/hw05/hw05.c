/******************************************************************************
* Assignment:  hw 05
* Lab Section  Tuesday, 11:30, SC Hall 
* Description: This program uses an user input which is a integer and rotates the number to figure out the maximum and minimum number that can be formed by the number in the digits of the given integer.
* Programmers: Tomoki Koike koike@purdue.edu
******************************************************************************/
#include <stdio.h>
#include <math.h>

//function declarations 
long long int userInput(void);
int loopCounter(long long int);
long long int rotater(long long int, long long int);
void valRegister(long long int, long long int, long long int *minReg, long long int *maxReg);
void output(long long int, long long int);

int main(void)
{
  //local declarations 
  long long int inputInt;  //the user input 
  long long int minReg = 1; //the register for the minimum value
  long long int maxReg = 1; //the register for the maximm value 
  long long int rotInt; //the rotated input
  int counter; //the limit of the for loop
  int n; //the counter for the for loop

  //statements
  //accept user input
  do
  {
    inputInt = userInput();
  } while(inputInt <=  0);
  
  //find the counter for how many times we want to conduct the loop below
  counter = loopCounter(inputInt);
  
  //initialize the registers
  minReg = inputInt;
  maxReg = inputInt; 

  //loop that rotates the input and then assigns the value to a register with the values of the minimum and the maximum
  for (n=1; n <= counter; n++)
  {
    if (n == 1)
    {
      //function that rotates the input 
      rotInt = rotater(inputInt, inputInt);
      //function that assigns the rotated value to a register
      valRegister(inputInt, rotInt, &minReg, &maxReg);
    }
    else
    { 
      rotInt = rotater(rotInt, inputInt);
      valRegister(inputInt, rotInt, &minReg, &maxReg);
    }
  }
  
  //output
  output(minReg, maxReg);
  return 0;
} //main

/******************************************************************************
* Function:    input 
* Description: user input integer
* Parameters:  void
* Return:      int, the user input 
******************************************************************************/ 
long long int userInput(void)
{
  long long int input; //the user input 

  printf("\nEnter integer to rotate -> ");
  scanf("%lld", &input);
  
  if (input <= 0)
  {
    printf("\nError! Positive integers only!!\n");
  }

  return input;
} //userInput

/******************************************************************************
* Function:    function name
* Description: brief description of what the function does
* Parameters:  variable1 name, data type, and description
*              variable2 name, data type, and description
* Return:      data type and description
******************************************************************************/
int loopCounter(long long int input)
{
  int counter = 0; //the counter for how many times we want to conduct the loop in the main
  while (input)
  {
    input /= 10;
    counter++;
  }
  --counter;

  return counter;
}

/******************************************************************************
* Function:    rotater
* Description: rotates the input 
* Parameters:  long long int, input, the user input
*              long long int, minRegister, register for the minimum value
*              long long int, maxRegister, register for the maximum value
* Return:      long long int, rotInput
******************************************************************************/
long long int rotater(long long int input, long long int originalInput)
{
  int multiplier1 = 0;   //the multiplier used in the modulus
  int multiplier2 = 0;   //the multiplier for original value
  long long int rotInt; //the rotated input
  long long int saveInput; //variable to save the orignal input
  int firstDigit; //the first digit of the rotated value
  //int firstDigitCal; //statement which calculates the first digit
  
  //save the original input value 
  saveInput = input;
 
  //get the number of digits for the original input
  while (originalInput)
  {
    originalInput /= 10;
    multiplier2++;
  }

  //gets the multiplier to extract the number in the largest digit for the looping input
  while (input)
  {
    input /= 10;
    multiplier1++;
  }
  
  //adjust the multiplier to make it equal to the number of digits in the input 
  --multiplier1;
  --multiplier2;
  //restore the original value of the input 
  input = saveInput;
   
  //calculation for the first digit
  firstDigit = (input / (long long int)pow(10, multiplier1));
  
  //rotates the input
  if (multiplier1 == multiplier2)
  {
    rotInt = (input % (long long int)pow(10, multiplier1)) * 10  + (input / (long long int)pow(10, multiplier1));
  }
  else 
  {
    rotInt = input * 10;
  }
  
  return rotInt;
} //rotater

/******************************************************************************
* Function:    valRegister
* Description: stores the minimum and maximum values for each iteration in a register and updates it whenever there is a smaller or larger value
* Parameters:  input, long long int, the original input value
*              rotInt, long long int, the newest rotated value
*              *minReg, long long int, the minimum number register
*              *maxReg, long long int, the maximum number register
* Return:      void
******************************************************************************/
void valRegister(long long int input, long long int rotInt, long long int *minReg, long long int *maxReg)
{
  if (rotInt < input)
  {
    if (rotInt < *maxReg)
    {
      *maxReg = rotInt;
    }
  }
  else if (rotInt > input) 
  {
    if (rotInt > *minReg)
    {
      *minReg = rotInt;
    }
  }
  else 
  {
    //null (remains unchanged) 
  }
  return;
} //valRegister

/******************************************************************************
* Function:    output
* Description: prints out the final outputs of the program
* Parameters:  minReg, long long int, the finalized minimum register
*              maxReg, long long int, the finalized maximum register
* Return:      void
******************************************************************************/
void output(long long int minReg, long long int maxReg)
{
  printf("\nLargest value generated: %lld\n", minReg);
  printf("Smallest value generated: %lld\n", maxReg);
  return;
} //output
