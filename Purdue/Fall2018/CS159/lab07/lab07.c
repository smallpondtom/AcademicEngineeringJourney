/******************************************************************************
* Assignment:  either Lab 7 
* Lab Section: Tuesday, 11:30, Stanley Coulter Hall
* Description: This program is the code for a processor that conducts limit number of algebraic with a function to store the values in multiple registers using binary instruction codes that the user inputs into the program.
* Programmers: Tomoki Koike koike@purdue.edu
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
int extractBinaryValue2(long long int);
int process(long long int, int, int, int, int *reg1, int *reg2, int *reg3, int *reg4);
void output(int, int, int, int);

int main(void)
{
  long long int code1;  //the first instruction code
  long long int code2;  //the second instruction code
  long long int code3;  //the thrid instruction code
  int value1;           //the value1 from the instruction code tha tis the middle 4 digits of binary number converted into decimals
  int value2;           //the value2 from the instruction code that is the last 4 digits of binary number converted into decimals
  int binaryValue2;     //the binary number form of value2
  int reg1;             //the value for register 1
  int reg2;             //the value for register 2
  int reg3;             //the value for register 3
  int reg4;             //the value for register 4 
  
  // initializing the four registers
  reg1 = 0;   
  reg2 = 0;
  reg3 = 0;
  reg4 = 0;

  // the user input
  code1 = input1();     //calling function for input1
  code2 = input2();     //calling function for input2
  code3 = input3();     //calling function for input3
  
  // figuring out the values for the first instruction code
  value1 = calValue1(code1); 
  value2 = calValue2(code1); 
  // taking out the last 4 digit of the instruction code 
  binaryValue2 = extractBinaryValue2(code1);
  // conducting the computations regarding the first 4 digits of the instruction code
  value1 = process(code1, value1, value2, binaryValue2, &reg1, &reg2, &reg3, &reg4);

  // figuring out the values for the second instruction code
  value1 = calValue1(code2); 
  value2 = calValue2(code2);
  // taking out the last 4 digits of the instruction code 
  binaryValue2 = extractBinaryValue2(code2);
  // conducting the computations regarding the first 4 digits of the instruction code 
  value1 = process(code2, value1, value2, binaryValue2, &reg1, &reg2, &reg3, &reg4);
 
  // figuring out the values for the third instruction code
  value1 = calValue1(code3);
  value2 = calValue2(code3);
  // taking out the last 4 digits of the instruction code
  binaryValue2 = extractBinaryValue2(code3);
  // conducting the computations regarding the first 4 digits of the instruction code 
  value1 = process(code3, value1, value2, binaryValue2, &reg1, &reg2, &reg3, &reg4);

  // printing out the results
  output(reg1, reg2, reg3, reg4);

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
  else 
  {
    *reg4 %= value1;
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
