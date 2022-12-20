
/******************************************************************************
* Assignment:  either Lab # or Homework #
* Lab Section: the day, time, and location of your lab meeting
* Description: verbose description of what the program does
* Programmers: fullname1 login1@purdue.edu
*              fullname2 login2@purdue.edu
*              fullname3 login3@purdue.edu
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
  long long int input;
  int digit1;
  int digit2;
  int digit3;
  int digitCount1;
  int digitCount2;
  int digitCount3;
  int comboCount;


  // Statements
  //the user input of the value
  input = inputValue();
  //the user input of the digits to find in the given value 
  digit1 = inputDigit();
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
* Return:      long long int, the user input
******************************************************************************/ 
long long int inputValue(void)
{
  long long int input; //the user input 
  
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
* Function:    function name
* Description: brief description of what the function does
* Parameters:  variable1 name, data type, and description
*              variable2 name, data type, and description
* Return:      data type and description
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
* Function:    function name
* Description: figures out what digit number the input is
* Parameters:  variable1 name, data type, and description
*              variable2 name, data type, and description
* Return:      data type and description
******************************************************************************/
/*int counter(long long int input)
{
  while (input)
  {
    input /= 10;
    counter++;
  }
  --counter;
  return counter;
}*/

/******************************************************************************
* Function:    function name
* Description: brief description of what the function does
* Parameters:  variable1 name, data type, and description
*              variable2 name, data type, and description
* Return:      data type and description
******************************************************************************/
int comboCounter(long long int input, int digit1, int digit2, int digit3, int digitCount2, int digitCount3)
{
  long long int  inputSaver1; //variable to save the input
  //long long int  inputSaver2;
  int firstDigit = 0; //the number of the smallest digit calculated from the modulus operation
  int comboCount = 0; //the counter for the number of combos
  //int n;
  //int m;
  
  /*
  printf("firstDigit=%d",firstDigit);

  for (n = 1; n <= digitCount3; n++)
  {
    printf("n=%d",n);
    while (firstDigit != digit3);
    {
      firstDigit = input % 10;
      input /= 10;
      inputSaver1 = input;
      printf("firstDigit:%d, input:%lld", firstDigit, input);
      if (firstDigit == digit3)
      {
        for (m = 1; m <= digitCount2; m++)
        {
          printf("m=%d",m);
          firstDigit = 0;
          while (firstDigit != digit2);
          {
            firstDigit = input % 10;
            input /= 10;
            inputSaver2 = input;
            printf("firstDigit:%d, input:%lld", firstDigit, input);
            if (firstDigit == digit2)
            {
              while (input)
              {
                firstDigit = input % 10;
                input /= 10;
                printf("firstDigit:%d, input:%lld", firstDigit, input);
                if (firstDigit == digit1)
                {
                  comboCount++;
                  printf("combo count: %d", comboCount);
                }
              }
            }
            firstDigit = digit2;
            input = inputSaver2;
          }  
        }
      }
      firstDigit = digit3;
      input = inputSaver1;
    }  
  }
  */
  int n;
  int m;
  long long int inputSaver2;
  
  for (n = 1; n <= digitCount3; n++)
  {
    do 
    {
      firstDigit = input % 10;
      input /= 10;
    } while(firstDigit != digit3);
    inputSaver1 = input;
    printf("inputSaver = %lld\n", inputSaver1);
    printf("input = %lld, firstDigit = %d\n", input, firstDigit);
    for (m =1; m <= digitCount2; m++)
    {
      do 
      {
        firstDigit = input % 10;
        input /= 10;
        printf("input = %lld, firstDigit = %d\n", input, firstDigit);
 
      } while(firstDigit != digit2);
      inputSaver2 = input;
      do
      {
        firstDigit = input % 10;
        input /= 10;
        printf("input = %lld, firstDigit = %d\n", input, firstDigit);
      } while(firstDigit != digit1);
      comboCount++;
      printf("combo: %d", comboCount);
      while (input)
      {
        firstDigit = input % 10;
        input /= 10;
        printf("input = %lld, firstDigit = %d\n", input, firstDigit);
        if (firstDigit == digit1)
        {
          comboCount++;
          printf("combo: %d\n",comboCount);
        }
      }
      input = inputSaver2;
      printf("inputSaver2 = %lld\n",input);
     
    }
    input = inputSaver1;
    printf("inputSaver1 = %lld\n", input);
  }
    
  return comboCount;
} //comboCounter
