/******************************************************************************
* Assignment:  Lab #11
* Lab Section: Tuesday, 11:30, SC189
* Description: Program accepts 20 integers from user and places them into an array. The program then follows the Collatz Conjecture and finds how many conversions are required to reach the value one. The program then prints the original array, Collatz Conjecture array and the indices of the max and min conversion values.
* Programmers: Tomoki Koike koike@purdue.edu
*              Madison Green green326@purdue.edu
*              Daniel Cinal dcinal@purdue.edu
******************************************************************************/
#include <stdio.h>
#include <math.h>
#include <stdlib.h>

#define INPUT 20

// function declarations
void getData(int []);
void calc(int [], int []);
int findMin(int []);
int findMax(int[]);
void print(int [], int [], int, int);

int main(void)
{
  // function declarations 
  int inputList[INPUT];   // user defined array
  int collatz[INPUT];     // collatz manipulated array
  int minVal;             // calculated minimum value of collatz manipulated 
  // array
  int maxVal;             // calculated maximum value of collatz manipulated 
  // array

  // function calls
  getData(inputList);
  calc(inputList, collatz);
  minVal = findMin(collatz);
  maxVal = findMax(collatz);
  print(inputList, collatz, minVal, maxVal);

  // return
  return 0;
    
} // main

/******************************************************************************
 * Function:    getData
 * Description: funtion prompts user to enter twenty integers and then places
 *              values into an array
 * Parameters:  input, int, the user input array
 * Return:      N/A
 ******************************************************************************/
void getData(int input[])
{
  // local declarations
  int i;       // counter for for loop

  // statements
  printf("Enter 20 integers -> ");
  for (i = 0; i < INPUT; i++)
  {
    scanf("%d", &input[i]);
  }
  printf("\n");

  // return
  return;

} // getData

/******************************************************************************
 * Function:    calc
 * Description: This fucntion converts the given elements in the array and counts the number of conversion for each element and makes an array consisting of the counts for each element.
 * Parameters:  array, int, the user input array
 * Return:      int, the array for the count of collatz conversion
 ******************************************************************************/
void calc(int array[], int collatz[])
{
  //Declarations
  int element;      // defines the i-th element in the given array
  int count;        // initializes the "count"
  int i;            // counter for for loop

  //Statements
  for (i = 0; i < 20; i++)
  {
    // defining the i-th element in the given array
    element = array[i];

    // initializing the "count" so that it resets to zero for each of the for loop iteration
    count = 0;

    /* The Collatz Conjecture is a theory that any number can be converted to one by using
     * two ways of conversion: when the number is "A" and if mod(A)=0 we do the conversion
     * of A/2, and if mod(A)=1 then we do the conversion of 3A+1. By repeating these two
     * methods A will eventually become 1.*/
    while (element != 1)
    {
      if (element % 2 == 0)
      {
        element /= 2;
        count++;
      }
      else
      {
        element = 3 * element + 1;
        count++;
      }
    } 
    collatz[i] = count;
  }
  return;
    
} // calc

/******************************************************************************
 * Function:    print
 * Description: function accepts all desired outputs and presents them in 
 *              the required format
 * Parameters:  input, int, user defined array
 *              collatz, int, collatz manipulated array
 *              minVal, int, calculated minimum value of collatz manipulated 
 *              array
 *              maxVal, int, calculated maximum value of collatz manipulated 
 *              array
 * Return:      N/A
 ******************************************************************************/
void print(int input[], int collatz[], int minVal, int maxVal)
{
  // local declarations
  int i;        // counter for for loop

  // statements
  printf("Data as input by user: ");
  for(i = 0; i < INPUT; i++)
  {
    printf("%d ", input[i]);
  }
  printf("\n");
  printf("Number of conversions: ");
  for(i = 0; i < INPUT; i++)
  {
    printf("%d ", collatz[i]);
  }
  printf("\n");
  printf("Index of smallest conversions: %d\n", minVal);
  printf("Index of largest conversions: %d\n", maxVal);

  // return
  return;
    
} // print

/******************************************************************************
 * Function:    findMin
 * Description: This function finds the index within the array of the element 
 *              with the smallest number of conversions
 * Parameters:  array, int, the given array
 * Return:      int, the index with the minimum value
 ******************************************************************************/
int findMin(int array[])
{
  // Declarations
  int element1;     //the i-th element in the given array
  int element2;     //the second i-th element in the given array
  int i;            //the counter for the for loop
  int min;          //the minimum   
  int minIndex;     //the minimum index

  // Statements
  for (i = 0; i <= 18; i++)
  {
    element1 = array[i];
    element2 = array[i + 1];
    if (i == 1)
    {
      if (element1 > element2)
      {
        min = element2;
        minIndex = i + 1;
      }
      else if (element1 < element2)
      {
        min = element1;
        minIndex = i;
      }
    }
    else 
    {
      if (min > element2)
      {
        min = element2;
        minIndex = i + 1;
      }
    }
  }
  return minIndex;
    
} // findMin

/******************************************************************************
 * Function:    findMax
 * Description: This function finds the index within the array of the element 
 *              with the largest number of conversions
 * Parameters:  array, int, the given array
 * Return:      int, the index with the maximum value
 ******************************************************************************/
int findMax(int array[])
{
  // Declarations
  int element1;     //the i-th element in the given array
  int element2;     // the second i-th element in the given array
  int i;            //the counter for the for loop
  int max;          //the minimum   
  int maxIndex;     //the minimum index

  // Statements
  for (i = 0; i <= 18; i++)
  {
    element1 = array[i];
    element2 = array[i + 1];
    if (i == 1)
    {
      if (element1 > element2)
      {
        max = element1;
        maxIndex = i;
      }
      else if (element1 < element2)
      {
        max = element2;
        maxIndex = i + 1;
      }
    }
    else 
    {
      if (max < element2)
      {
        max = element2;
        maxIndex = i + 1;
      }
    }
  }
  return maxIndex;
    
} // findMax
