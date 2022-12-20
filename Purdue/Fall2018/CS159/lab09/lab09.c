/******************************************************************************
* Assignment:  lab09 
* Lab Section: Tuesday, 11:30 SC hall
* Description: This program is able to tell the number of digits that is entered by the user for a number entered by the user as well as figure out the number of combos able to create with the order of the digits of the number
* Programmers: Tomoki Koike koike@purdue.edu
*              Daniel Cinal dcinal@purdue.edu
*              Madison Green  green326@purdue.edu
******************************************************************************/
#include <stdio.h>
#include <math.h>

long long int inputValue(void);
int inputDigit(void);
void output(int, int, int, int);
int comboCounter(long long int, int, int, int, int, int);

int main(void)
{
  // local Declarations 
  long long int input;       // variable that holds the user inputted integer 
  int digit1;                // variable that holds the user inputted value for digit 1
  int digit2;                // variable that holds the user inputted value for digit 2 
  int digit3;                // variable that holds the user inputted value for digit 3 
  int digitCount1;           // variable that counts number of times digit 1 is in integer 
  int digitCount2;           // variable that counts number of times digit 2 is in integer 
  int digitCount3;           // variable that counts number of times digit 3 is in integer 
  int comboCount;            // variable that counts number of possible arrangements of the integers 

  // Statements
  input = inputValue();             // the uset inputs the integer 
  digit1 = inputDigit();            // the user input of the digits to find in the given value  
  digit2 = inputDigit();
  digit3 = inputDigit();

  printf("enter digit count 1: ");
  scanf("%d", &digitCount1);
  printf("enter digit count 2: ");
  scanf("%d", &digitCount2);
  printf("enter digit count 3: ");
  scanf("%d", &digitCount3);
  
  //generate the number of combos
  comboCount = comboCounter(input, digit1, digit2, digit3, digitCount2, digitCount3);

  //output
  output(digitCount1, digitCount2, digitCount3, comboCount);
  return 0;
} //main

/******************************************************************************
* Function:    inputValue  
* Description: Accepts the use input of the integer value
* Parameters:  void
* Return:      long long int, inputValue, the user inputted integer 
******************************************************************************/ 
long long int inputValue(void)
{
  long long int input;                    //the user input 
  
  do
  {
    printf("Enter integer value -> ");
    scanf("%lld", &input);
  
    if (input < 0)
    {
      printf("\nError! Non_negative values only!!\n");
    }
    else if (input < 100)
    {
      printf("\nError! Minimum integer is 100!\n");
    }
    else 
    {
      //no error
    }
  } while(input < 100);

  return input;
} //inputValue

/******************************************************************************
* Function:    inputDigit 
* Description: the function allows the user to input the digits that will be used 
* Parameters:  none
* Return:      int, digit, the digit that is used in rest of program 
******************************************************************************/
int inputDigit(void)
{
  int digit; //the entered digit to search in the given value
  int n = 1; //counter
  do
  {
    digit = 1; //initialize
    
    if (digit > 0 && digit < 10)
    {
      printf("Enter digit #%d -> ", n);
      scanf("%d", &digit);
    }
    else if (digit <= 0)
    {
      printf("\nError! Digit must be greater than zero!!\n");
    }
    else
    {
      printf("\nError! Digit must be smaller than ten!!\n");
    }
    n++;
  } while (digit <= 0 || digit >= 10);

  return digit;
} //inputDigit

/******************************************************************************
* Function:    output
* Description: prints out the final outputs
* Parameters:  num1count, int, the digit count for the first number 
*              num2count, int, the digit count for the second number
*              num3count, int, the digit count for the third number 
*              numCombos, int, the number of possible combinations of the user input
* Return:      void
******************************************************************************/
void output(int num1count, int num2count, int num3count, int numCombos)
{
  printf("\nDigit Counts: %d %d %d \n", num1count, num2count, num3count);
  printf("Possible Combinations: %d\n", numCombos);
  return;
} //output

/******************************************************************************
* Function:    comboCounter 
* Description: counts the number of combos that each integer can make 
* Parameters:  input, long long int, the user inputted integer
               digit1, int, the user inputted first digit 
               digit2, int, the user inputted second digit 
               digit3, int, the user inputted third digit
               digitCount2, int, the number of times the second digit is in the integer 
               digitCount3, int, the number of times the third digit is in the integer 			   
* Return:      comboCount, int, the number of combinations that the integer can have 
******************************************************************************/
int comboCounter(long long int input, int digit1, int digit2, int digit3, int digitCount2, int digitCount3)
{
  long long int  inputSaver1; //variable to save the input
  //long long int  inputSaver2;
  int firstDigit = 0; //the number of the smallest digit calculated from the modulus operation
  int comboCount = 0; //the counter for the number of combos
  int n;                      // loop update variable 
  int m;                      // loop update variable 
  long long int inputSaver2;  // tracking variable to see possible combos 
  
  for (n = 1; n <= digitCount3; n++)
  {
    do 
    {
      firstDigit = input % 10;      // setting first digit equal to the last digit of the integer 
      input /= 10;                  // removing last digit from the integer 
    } while(firstDigit != digit3);
    inputSaver1 = input;            // setting input saver as the first rotation of the integer 
    printf("inputSaver = %lld\n", inputSaver1);
    printf("input = %lld, firstDigit = %d\n", input, firstDigit);
    for (m =1; m <= digitCount2; m++)
    {
      do 
      {
        firstDigit = input % 10;        // making the first digit the last digit 
        input /= 10;                    // removing a digit from the integer 
        printf("input = %lld, firstDigit = %d\n", input, firstDigit);
 
      } while((firstDigit != digit2) && (firstDigit != 0));
      inputSaver2 = input;
      do
      {
        firstDigit = input % 10;         // making the first digit the last digit 
        input /= 10;                     // removing a digit from the integer 
        printf("input = %lld, firstDigit = %d\n", input, firstDigit);
      } while((firstDigit != digit1) && (firstDigit != 0));
      comboCount++;                      // updating the combo count 
      printf("combo: %d", comboCount);
      while (input)
      {
        firstDigit = input % 10;         // making the first digit the last digit of the integer 
        input /= 10;                     // removing a digit from the integer 
        printf("input = %lld, firstDigit = %d\n", input, firstDigit);
        if (firstDigit == digit1)
        {
          comboCount++;                  // updating the combo count 
          printf("combo: %d\n",comboCount);
        }
      }
      input = inputSaver2;                // tracking the rotations 
      printf("inputSaver2 = %lld\n",input);
     
    }
    input = inputSaver1;                  // tracking the rotations 
    printf("inputSaver1 = %lld\n", input);
  }
    
  return comboCount;
} //comboCounter
