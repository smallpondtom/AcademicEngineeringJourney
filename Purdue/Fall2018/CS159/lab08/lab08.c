/******************************************************************************
* Assignment:  Lab 08 
* Lab Section: Tuesday, 11:30, Stanley Coulter Hall
* Description: This program is the code for a processor that conducts limit number of algebraic with a function to store the values in multiple registers using binary instruction codes that the user inputs into the program. This program can have an infinite number of inputs but terminates automatically with specific instruction codes and also assists the user to enter proper codes.
* Programmers: Tomoki Koike koike@purdue.edu
*              Lauren Anderson ander867@purdue.edu
*              Luke Murphy murph282@purdue.edu
******************************************************************************/

#include <stdio.h>
#include <math.h>

long long int input(int);
int invalidDigit(long long int, int);
long long int biToDec(long long int);
int calValue1(long long int);
int calValue2(long long int);
int extractBinaryValue2(long long int);
int process(long long int, int, int, int, int *reg1, int *reg2, int *reg3, int *reg4);
void output(int, int, int, int);

int main(void)
{
  long long int code;   //the instruction code inputted by the user 
  int value1;           //the value1 from the instruction code tha tis the middle 4 digits of binary number converted into decimals
  int value2;           //the value2 from the instruction code that is the last 4 digits of binary number converted into decimals
  int binaryValue2;     //the binary number form of value2
  int reg1;             //the value for register 1
  int reg2;             //the value for register 2
  int reg3;             //the value for register 3
  int reg4;             //the value for register 4 
  int index;            //the index or "counter" for the loop in the main   

  // initializing the four registers
  reg1 = 0;   
  reg2 = 0;
  reg3 = 0;
  reg4 = 0;
  
  // initialization
  index = 1;
  
  do 
  {
    //user input
    code = input(index);
    index++;
    
    // figuring out the values for the first instruction code
    value1 = calValue1(code); 
    value2 = calValue2(code);
    
    // taking out the last 4 digit of the instruction code 
    binaryValue2 = extractBinaryValue2(code);
        
    // conducting the computations regarding the first 4 digits of the instruction code
    if (code != -1)
    {
      value1 = process(code, value1, value2, binaryValue2, &reg1, &reg2, &reg3, &reg4);
    }
  } while(code != -1);

  // printing out the results
  output(reg1, reg2, reg3, reg4);

  return 0;
} //main

/******************************************************************************
* Function:    input
* Description: Allows the user to input the instruction code.
* Parameters:  none
* Return:      long long int, the first instruction code which is a binary code
******************************************************************************/
long long int input(int index)
{
  long long int code;  //the inputted  first instruction code
  int last4digits;     //the last four digits of the instruction code
  int first4digits;    //the first four digits of the instruction code
  int factor = 99;     //the factor which determines whether this functions loop continues or not   

  do 
  {
    // user input 
    printf("Enter full instruction code #%d -> ",index);
    scanf("%lld",&code);
    
    // extracting the first and last digits of the instruction code for the following computations
    last4digits = (code + 1000) % 10000; 
    first4digits = (code + 100000000000) / 100000000;
   
    // calling fuction for input validation
    factor = invalidDigit(code, index);
    
    if (factor == 99)
    {
      if (first4digits == 2000 || first4digits == 2001 || first4digits == 2010 || first4digits == 2011 || first4digits == 2100 || first4digits == 2222)
      {
        if (last4digits == 2000 || last4digits == 1100 || last4digits == 1010 || last4digits == 1001)
        {
          //null
        }
        else
        {
          printf("\nInvalid register! Terminating input.\n");
          code = -1;
        }
      }   
    }
  } while(factor != 99);
       
  return code;
} //input

/******************************************************************************
* Function:    invalidDigit 
* Description: this function will find the invalid numbers inside the user given instruction code and print out a error messgage and to make them provide a proper instruction code again 
* Parameters:  code, long long int, the 12 digit instruction code
*              index, int, the index for the loop in the main which determines the entered number of instruction codes 
* Return:      int, the factor which determines to repeat the entering of the same # instruction code 
******************************************************************************/
int  invalidDigit(long long int code, int index)
{
  long long int newCode; //the changed value of the code
  int num = 0;           //the counter as well as the detector for an invalid digit in the instruction code
  int counter = 0;       //counter to optimize the code value for the loop in the first addition operation
  int factor = 99;       //the factor corresponding with the variable "factor"  in the function input 

  while (code != 0) 
  {
    // the procedure below looks at each digit of the code from the smaller ones and finds out if it is other than 0 or 1 
    newCode = code + 111111111111 * pow(10, counter--);
    num = newCode % 10 - 1;

    if (num > 1)
    {
      printf("Instruction #%d contains an invalid digit, please try again.\n" , index);
      code = 0;
      factor++;
    }
    
    //divides code by 10 to do the same procedure on the next digit
    code /= 10;
  }
  return factor;
} //invalidDigit

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
* Function:    extractBinaryValue2
* Description: taking out the last 4 digits of the instruction code that corresponds with value2
* Parameters:  long long int, code, the given instruction code
* Return:      int, the 4 digit binary code for the last 4 digits of the instruction code
******************************************************************************/
int extractBinaryValue2(long long int code)
{
  int binaryValue2; //the binary value of 2

  binaryValue2 = (code + 1000) % 10000;
  return binaryValue2;
} //extractBinaryValue2

/******************************************************************************
* Function:    process
* Description: does all the computation regarding the instruction codes including the algebraic computations and the assigning of registers and the the calculations of the values of the registers
* Parameters:  long long int, code, the instruction code
*              int, value1, the decimal form of the middle 4 digits of the instruction code
*              int, value2, the decimal form of the last 4 digits of the instruction code
*              int, binaryValue2, the binary form of value2
*              int, *reg1, the value of register 1 (passed by address)
*              int, *reg2, the value of register 2 (passed by address)
*              int, *reg3, the value of register 3 (passed by address)
*              int, *reg4, the value of register 4 (passed by address)
* Return:      int, the result of the algebraic computation
******************************************************************************/
int process(long long int code, int value1, int value2, int binaryValue2, int *reg1, int *reg2, int *reg3, int *reg4)
{
  int newValue; //the resulting value of the algebraic computation 
    
  code = (code + 111100000000) / 100000000;
  
  if (code == 1111 || code == 1211)
  {
    newValue = value1 + value2;
    *reg4 = newValue;
  }
  else if (code == 1112)
  {
    newValue = value1 - value2;
    *reg4 = newValue;
  }
  else if (code == 1212)
  {
    newValue = value2 - value1;
    *reg4 = newValue;
  }
  else if (code == 1121 || code == 1221)
  {
    newValue = value1 * value2;
    *reg4 = newValue;
  }
  else if (code == 1122)
  {
    newValue = value1 / value2;
    *reg4 = newValue;
  }
  else if (code == 1222) 
  {
    newValue = value2 / value1;
    *reg4 = newValue;
  }
  else if (code == 2212)
  {
    newValue = value1 % value2;
    *reg4 = newValue;
  }
  else if (code == 2221)
  {
    newValue = value2 % value1;
    *reg4 = newValue;
  } 
  else if (code == 2111 && binaryValue2 == 2000)
  { 
    *reg1 = value1;
  }
  else if (code == 2111 && binaryValue2 == 1100)
  {
    *reg2 = value1;
  }
  else if (code == 2111 && binaryValue2 == 1010)
  {
    *reg3 = value1;
  }
  else if (code == 2111 && binaryValue2 == 1001)
  {
    *reg4 = value1;
  }
  else if (code == 2112 && binaryValue2 == 2000)
  {
    *reg1 += value1;
  }
  else if (code == 2112 && binaryValue2 == 1100)
  {
    *reg2 += value1;
  }
  else if (code == 2112 && binaryValue2 == 1010)
  {
    *reg3 += value1;
  }
  else if (code == 2112 && binaryValue2 == 1001)
  {
    *reg4 += value1;
  }
  else if (code == 2121 && binaryValue2 == 2000)
  {
    *reg1 -= value1;
  }
  else if (code == 2121 && binaryValue2 == 1100)
  {
    *reg2 -= value1;
  }
  else if (code == 2121 && binaryValue2 == 1010)
  {
    *reg3 -= value1;
  }
  else if (code == 2121 && binaryValue2 == 1001) 
  {
    *reg4 -= value1;
  }
  else if (code == 2122 && binaryValue2 == 2000)
  {
    *reg1 *= value1;
  }
  else if (code == 2122 && binaryValue2 == 1100)
  {
    *reg2 *= value1;
  }
  else if (code == 2122 && binaryValue2 == 1010)
  {
    *reg3 *= value1;
  }
  else if (code == 2122 && binaryValue2 == 1001)
  {
    *reg4 *= value1;
  }
  else if (code == 2211 && binaryValue2 == 2000)
  {
    *reg1 /= value1;
  }
  else if (code == 2211 && binaryValue2 == 1100)
  {
    *reg2 /= value1;
  }
  else if (code == 2211 && binaryValue2 == 1010)
  {
    *reg3 /= value1;
  }
  else if (code == 2211 && binaryValue2 == 1001)
  {
    *reg4 /= value1;
  }
  else if (code == 2222 && binaryValue2 == 2000)
  {
    *reg1 %= value1;
  }
  else if (code == 2222 && binaryValue2 == 1100)
  {
    *reg2 %= value1;
  }
  else if (code == 2222 && binaryValue2 == 1010)
  {
    *reg3 %= value1;
  }
  else if (code == 2222 && binaryValue2 == 1001) 
  {
    *reg4 %= value1;
  }
  else 
  {
    //null
  }
  
  return newValue;     
} //process

/******************************************************************************
* Function:    output
* Description: printing out the final results for the values of all registers
* Parameters:  int, reg1, the value of register 1
*              int, reg2, the value of register 2
*              int, reg3, the value of register 3
*              int, reg4, the value of register 4
* Return:      void
******************************************************************************/
void output(int reg1, int reg2, int reg3, int reg4)
{
  printf("\nRegister Values: %d %d %d %d\n", reg1, reg2, reg3, reg4);
  return;
} //output
