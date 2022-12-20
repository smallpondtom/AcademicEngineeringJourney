/******************************************************************************
* Assignment:  hw04
* Lab Section: Tuesday, 11:30, SC Hall 189
* Description: This program conducts a calculation of a network consisting of five logic gates. The gates are assigned AND, NAND, OR, NOR, XOR, or XNOR by the user and the values 1 and 0 are calculated through the gates to give out a certtain result.
* Programmers: Tomoki Koike koike@purdue.edu        
******************************************************************************/

#include <stdio.h>
#include <math.h>

void instruction(void);
int gate1(void);
int gate2(void);
int gate3(void);
int gate4(void);
int gate5(void);
int processGate1(int);
int processGate2(int);
int processGate3(int, int, int);
int processGate4(int);
int processGate5(int, int, int);
void output(int);

int main(void)
{
  int inputGate1;    //user input for gate 1
  int inputGate2;    //user input for gate 2
  int inputGate3;    //user input for gate 3
  int inputGate4;    //user input for gate 4
  int inputGate5;    //user input for gate 5
  int valueGate1;    //the output of gate 1
  int valueGate2;    //the output of gate 2
  int valueGate3;    //the output of gate 3
  int valueGate4;    //the output of gate 4
  int valueGate5;    //the output of gate 5 (the final result)

  // printing out the very first instructions of the program
  instruction();
  
  // inputs by the user that governs the operations for the gates 
  inputGate1 = gate1();
  inputGate2 = gate2();
  inputGate3 = gate3();
  inputGate4 = gate4();
  inputGate5 = gate5();
  
  // process for the first gate
  valueGate1 = processGate1(inputGate1); 
  // process for the second gate
  valueGate2 = processGate2(inputGate2);
  // process for the third gate
  valueGate3 = processGate3(inputGate3, valueGate1, valueGate2);
  // process for the fourth gate
  valueGate4 = processGate4(inputGate4);
  // process for the fifth gate
  valueGate5 = processGate5(inputGate5, valueGate3, valueGate4);
  
  // print out the result
  output(valueGate5);

  return 0;
} //main

/******************************************************************************
* Function:    instruction  
* Description: printing out the very first instructions for the program
* Parameters:  none
* Return:      void
******************************************************************************/
void instruction(void)
{
  printf("Available gates for network\n");
  printf("\n1. AND\n");
  printf("2. NAND\n");
  printf("3. OR\n");
  printf("4. NOR\n");
  printf("5. XOR\n");
  printf("6. XNOR\n");
  return;
}

/******************************************************************************
* Function:    gate1
* Description: accepts the input for the first gate from the user 
* Parameters:  none
* Return:      int, the integer from 1 to 6 inputted by the user
******************************************************************************/
int gate1(void)
{
  int inputGate1; //input for gate1 
  printf("\nEnter option for gate #1 -> ");
  scanf("%d", &inputGate1);
  return inputGate1;
} // gate1

/******************************************************************************
* Function:    gate2
* Description: accepts the input for the second gate from the user 
* Parameters:  none
* Return:      int, the integer from 1 to 6 inputted by the user
******************************************************************************/
int gate2(void)
{
  int inputGate2; //input for gate 2 
  printf("Enter option for gate #2 -> ");
  scanf("%d", &inputGate2);
  return inputGate2;
} // gate2

/******************************************************************************
* Function:    gate3
* Description: accepts the input for the third gate from the user 
* Parameters:  none
* Return:      int, the integer from 1 to 6 inputted by the user
******************************************************************************/
int gate3(void)
{
  int inputGate3; //input for gate 3
  printf("Enter option for gate #3 -> ");
  scanf("%d", &inputGate3);
  return inputGate3;
} // gate3

/******************************************************************************
* Function:    gate4
* Description: accepts the input for the fourth gate from the user 
* Parameters:  none
* Return:      int, the integer from 1 to 6 inputted by the user
******************************************************************************/
int gate4(void)
{
  int inputGate4; //input for gate 4
  printf("Enter option for gate #4 -> ");
  scanf("%d", &inputGate4);
  return inputGate4;
} // gate4

/******************************************************************************
* Function:    gate5
* Description: accepts the input for the fifth gate from the user 
* Parameters:  none
* Return:      int, the integer from 1 to 6 inputted by the user
******************************************************************************/
int gate5(void)
{
  int inputGate5; //input for gate 5
  printf("Enter option for gate #5 -> ");
  scanf("%d", &inputGate5);
  return inputGate5;
} // gate5

/******************************************************************************
* Function:    processGate1
* Description: logical operation for the first gate 
* Parameters:  inputGate1, the user input for the gate 1 operation
* Return:      int, the calculated result of the locial operation 
******************************************************************************/
int processGate1(int inputGate1)
{
  int outputGate1;  //the output of the logical operator for the first gate
  
  if (inputGate1 == 1)
  {
    outputGate1 = 1 && 0;
    printf("\nEvaluating Gate #1: 1 AND 0 = 0\n");
  }
  else if (inputGate1 == 2) 
  {
    outputGate1 = !(1 && 0);
    printf("\nEvaluating Gate #1: 1 NAND 0 = 1\n");
  }
  else if (inputGate1 == 3)
  {
    outputGate1 = 1 || 0;
    printf("\nEvaluating Gate #1: 1 OR 0 = 1\n");
  }
  else if (inputGate1 == 4)
  {
    outputGate1 = !(1 || 0);
    printf("\nEvaluating Gate #1: 1 NOR 0 = 0\n");
  }
  else if (inputGate1 == 5)
  {
    outputGate1 = 1 != 0;
    printf("\nEvaluating Gate #1: 1 XOR 0 = 1\n");
  }
  else 
  {
    outputGate1 = !(1 != 0);
    printf("\nEvaluating Gate #1: 1 XNOR 0 = 0\n");  
  }
  
  return outputGate1;
}

/******************************************************************************
* Function:    processGate2
* Description: logical operation for the second gate 
* Parameters:  inputGate2, the user input of the gate 2 operation
* Return:      int, the calculated result of the locial operation 
******************************************************************************/
int processGate2(int inputGate2)
{
  int outputGate2;  //the output of the logical operator for the second gate
  
  if (inputGate2 == 1)
  {
    outputGate2 = 1 && 1;
    printf("Evaluating Gate #2: 1 AND 1 = 1\n");
  }
  else if (inputGate2 == 2) 
  {
    outputGate2 = !(1 && 1);
    printf("Evaluating Gate #2: 1 NAND 1 = 0\n");
  }
  else if (inputGate2 == 3)
  {
    outputGate2 = 1 || 1;
    printf("Evaluating Gate #2: 1 OR 1 = 1\n");
  }
  else if (inputGate2 == 4)
  {
    outputGate2 = !(1 || 1);
    printf("Evaluating Gate #2: 1 NOR 1 = 1\n");
  }
  else if (inputGate2 == 5)
  {
    outputGate2 = 1 != 1;
    printf("Evaluating Gate #2: 1 XOR 1 = 0\n");  
  }
  else 
  {
    outputGate2 = !(1 != 1);
    printf("Evaluating Gate #2: 1 XNOR 1 = 1\n");
  }

  return outputGate2;
}

/******************************************************************************
* Function:    processGate3
* Description: logical operation for the third gate 
* Parameters:  inputGate3, the user input of the gate 3 operation
*              valueGate1, the output of the gate 1 operation 
*              valueGate2, the output of the gate 2 operation 
* Return:      int, the calculated result of the locial operation 
******************************************************************************/
int processGate3(int inputGate3, int valueGate1, int valueGate2)
{
  int outputGate3;  //the output of the logical operator for the third gate
  
  if (inputGate3 == 1)
  {
    outputGate3 = valueGate1 && valueGate2;
    printf("Evaluating Gate #3: %d AND %d = %d\n", valueGate1, valueGate2, outputGate3);
  }
  else if (inputGate3 == 2) 
  {
    outputGate3 = !(valueGate1 && valueGate2);
    printf("Evaluating Gate #3: %d NAND %d = %d\n", valueGate1, valueGate2, outputGate3);
  }
  else if (inputGate3 == 3)
  {
    outputGate3 = valueGate1 || valueGate2;
    printf("Evaluating Gate #3: %d OR %d = %d\n", valueGate1, valueGate2, outputGate3);
  }
  else if (inputGate3 == 4)
  {
    outputGate3 = !(valueGate1 || valueGate2);
    printf("Evaluating Gate #3: %d NOR %d = %d\n", valueGate1, valueGate2, outputGate3);
  }
  else if (inputGate3 == 5)
  {
    outputGate3 = valueGate1 != valueGate2;
    printf("Evaluating Gate #3: %d XOR %d = %d\n", valueGate1, valueGate2, outputGate3);    
  }
  else 
  {
    outputGate3 = !(valueGate1 != valueGate2);
    printf("Evaluating Gate #3: %d XNOR %d = %d\n", valueGate1, valueGate2, outputGate3);    
  }

  return outputGate3;
}

/******************************************************************************
* Function:    processGate4
* Description: logical operation for the fourth gate 
* Parameters:  inputGate4, the user input of the gate 4 operation
* Return:      int, the calculated result of the locial operation 
******************************************************************************/
int processGate4(int inputGate4)
{
  int outputGate4;  //the output of the logical operator for the fourth gate
  if (inputGate4 == 1)
  {
    outputGate4 = 0 && 0;
    printf("Evaluating Gate #4: 0 AND 0 = %d\n", outputGate4);   
  }
  else if (inputGate4 == 2) 
  {
    outputGate4 = !(0 && 0);
    printf("Evaluating Gate #4: 0 NAND 0 = %d\n", outputGate4);    
  }
  else if (inputGate4 == 3)
  {
    outputGate4 = 0 || 0;
    printf("Evaluating Gate #4: 0 OR 0 = %d\n", outputGate4);    
  }
  else if (inputGate4 == 4)
  {
    outputGate4 = !(0 || 0);
    printf("Evaluating Gate #4: 0 NOR 0 = %d\n", outputGate4);
  }
  else if (inputGate4 == 5)
  {
    outputGate4 = 0 != 0;
    printf("Evaluating Gate #4: 0 XOR 0 = %d\n", outputGate4);
  }
  else 
  {
    outputGate4 = !(0 != 0);
    printf("Evaluating Gate #4: 0 XNOR 0 = %d\n", outputGate4);    
  }

  return outputGate4;
}

/******************************************************************************
* Function:    processGate5
* Description: logical operation for the fifth gate 
* Parameters:  inputGate5, the user input of the gate 5 operation
*              valueGate3, the output of the gate 3 operation 
*              valueGate4, the output of the gate 4 operation 
* Return:      int, the calculated result of the locial operation 
******************************************************************************/
int processGate5(int inputGate5, int valueGate3, int valueGate4)
{
  int outputGate5;  //the output of the logical operator for the third gate
  
  if (inputGate5 == 1)
  {
    outputGate5 = valueGate3 && valueGate4;
    printf("Evaluating Gate #5: %d AND %d = %d\n", valueGate3, valueGate4, outputGate5);
  }
  else if (inputGate5 == 2) 
  {
    outputGate5 = !(valueGate3 && valueGate4);
    printf("Evaluating Gate #5: %d NAND %d = %d\n", valueGate3, valueGate4, outputGate5);    
  }
  else if (inputGate5 == 3)
  {
    outputGate5 = valueGate3 || valueGate4;
    printf("Evaluating Gate #5: %d OR %d = %d\n", valueGate3, valueGate4, outputGate5);    
  }
  else if (inputGate5 == 4)
  {
    outputGate5 = !(valueGate3 || valueGate4);
    printf("Evaluating Gate #5: %d NOR %d = %d\n", valueGate3, valueGate4, outputGate5);   
  }
  else if (inputGate5 == 5)
  {
    outputGate5 = valueGate3 != valueGate4;
    printf("Evaluating Gate #5: %d XOR %d = %d\n", valueGate3, valueGate4, outputGate5);    
  }
  else 
  {
    outputGate5 = !(valueGate3 != valueGate4);
    printf("Evaluating Gate #5: %d XNOR %d = %d\n", valueGate3, valueGate4, outputGate5);    
  }

  return outputGate5;
}

/******************************************************************************
* Function:    output
* Description: printing out the result 
* Parameters:  valueGate5, int, the output of gate 5 logical operation
* Return:      none
******************************************************************************/
void output(int valueGate5)
{
  printf("\nFinal Result: %d\n", valueGate5);
  return;
}

