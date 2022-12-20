/******************************************************************************
* Assignment:  lab 06 
* Lab Section: Tuesday, 11:30, SC Hall 189
* Description: This program is a processor which only has a limited instruction set and is capable of conducting addition, subtraction,multiplication, and division of two non-negative integer values. Three Binary instruction codes are given to the processor by the user and the processor will do the calculation to output a single non-negative integer value.
* Programmers: Tomoki Koike, koike@purdue.edu
*              Lauren Anderson ander867@purdue.edu
*              Luke Murphy murph282@purdue.edu
******************************************************************************/

#include <stdio.h>
#include <math.h>

long long int input1(void);
long long int input2(void);
long long int input3(void);
long long int biToDec(long long int);
int calValue1(long long int);
int calValue2(long long int);
int process(long long int, int, int);
void output(int);

int main(void)
{
  long long int code1;  //the first instruction code
  long long int code2;  //the second instruction code
  long long int code3;  //the thrid instruction code
  int value1;           //the value1 given from and calculated from the instruction code  
  int value2;           //the value2 given from and calculated from the instruction code

  // the user input 
  code1 = input1();     //calling function for input1 
  code2 = input2();     //calling function for input2
  code3 = input3();     //calling function for input3
  
  // figuring out the values for the first instruction code 
  value1 = calValue1(code1);  //calling function for calValue1
  value2 = calValue2(code1);  //calling function for calValue2
  // Initiate the first algebraic calculation ordered by the instruction code to retrieve the new value1
  value1 = process(code1, value1, value2);  //calling function for process
  // figuring out the value2 for the second instruction code
  value2 = calValue2(code2);                //calling function for calValue2 
  // Initiate the second algebraic calculation ordered by the second instruction code to retrieve the new value1
  value1 = process(code2, value1, value2);  //calling function for process
  // figuring out the value2 for the third instruction code
  value2 = calValue2(code3);                //calling function for calValue2
  // Inititate the third algebraic calculation ordered by the third instruction code to retreive the new value1
  value1 = process(code3, value1, value2);  //calling function for process
  
  // printing out the final result
  output(value1);  //calling function for output
  return 0;

} //main

/******************************************************************************
* Function:    input1
* Description: Allows the user to input the instruction code.
* Parameters:  none
* Return:      long long int, the first instruction code which is a binary code 
******************************************************************************/
long long int input1(void)
{
  long long int code1; //the inputted  first instruction code 
  
  printf("Enter full instruction code #1 -> ");
  scanf("%lld",&code1);
  return code1;
} //input1

/******************************************************************************
* Function:    input2
* Description: Allows the user to input the second instruction code.
* Parameters:  none
* Return:      long long int, the second instruction code which is a binary code
******************************************************************************/
long long int input2(void)
{
  long long int code2; //the inputted second instruction code 
  
  printf("Enter full instruction code #2 -> ");
  scanf("%lld",&code2);
  return code2;
} //input2

/******************************************************************************
* Function:    input3
* Description: Allows the user to input the third instruction code.
* Parameters:  none
* Return:      long long int, the third instruction code which is a binary code
******************************************************************************/
long long int input3(void)
{
  long long int code3; //the inputted third instruction code 

  printf("Enter full instruction code #3 -> ");
  scanf("%lld",&code3);
  return code3;
} //input3

/******************************************************************************
* Function:    calValue1 
* Description: Calculates the decimal value that corresponds with the first four digits of the binary instruction code
* Parameters:  code, long long int, the instruction code inputted by the user
* Return:      int, the decimal value calculated by the function
******************************************************************************/
int calValue1(long long int code)
{
  int value1;  //value1 that is extracted from instruction code and converted to decimals
   
  code = (code % 100000000) / 10000;

  value1 = biToDec(code); 
  return value1;
} //calValue1

/******************************************************************************
* Function:    calValue2
* Description: Calculates the decimal value that corresponds with from the fifth to eighth digits of the binary instruction code 
* Parameters:  code, long long int, the instruction code inputted by the user 
* Return:      int, the decimal value calculated by the function
******************************************************************************/
int calValue2(long long int code)
{
  int value2; //value2 that is extracted from the instruction code and then converted to decimals 
   
  code = code % 10000;

  value2 = biToDec(code);
  return value2;
} //calValue2

/******************************************************************************
* Function:    process
* Description: Conducts a flow of algebraic calculations using if statements and the given values (value1 and value) in which the calculation depends on the digits from the ninth and the twelfth digit of the inputted instruction code. 
* Parameters:  code, long long int, the instruction code which orders what algebraic calculation to do
*              value1, int, the given first value which is used in the calculation
*              value2, int, the given second value which is used in the calculation
* Return:      int, the result of the calculations using the values: value1 and value2 
*******************************************************************************/
int process(long long int code, int value1, int value2)
{
  int newValue; //the calculated new value for value1

  code = (code + 111100000000) / 100000000;
  
  if (code == 1111 || code == 1211)
  {
    newValue = value1 + value2;
  }
  else if (code == 1112)
  {
    newValue = value1 - value2;
  }
  else if (code == 1212)
  {
    newValue = value2 - value1;
  }
  else if (code == 1121 || code == 1221)
  {
    newValue = value1 * value2;
  }
  else if (code == 1122)
  {
    newValue = value1 / value2;
  }
  else
  {
    newValue = value2 / value1;
  }
  return newValue;
} //process

/******************************************************************************
* Function:    biToDec
* Description: Converts the binary code to a decimal number
* Parameters:  biNum, long long int, the binary code that will be converted to a decimal number
* Return:      long long int, the decimal number that was converted from the given binary code 
******************************************************************************/
long long int biToDec(long long int biNum)
{
  long long int decNum; //the decimal number converted by from the binary code 

  decNum = (biNum / 1000 * pow(2,3)) + ((biNum % 1000) / 100 * pow(2,2)) + ((biNum % 100) / 10 * 2) + (biNum % 10);
  return decNum;
} //biToDec

/******************************************************************************
* Function:    output      
* Description: printing out the result
* Parameters:  value1, int, the final calculated value
* Return:      void
******************************************************************************/
void output(int value1)
{
  printf("\nFinal Result: %d\n", value1);
  return;
} //output
