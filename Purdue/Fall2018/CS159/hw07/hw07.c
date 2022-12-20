/******************************************************************************
* Assignment:  hw07
* Lab Section: Tuesday,11:30, SC Hall
* Description: This programs is designed to accept two user input arrays and find out the unique values within the dataset and also the unique values across both set of data. The program outputs those values as arrays individually.
* Programmers: Tomoki Koike, koike@purdue.edu
********************************************************************************/
#include <stdio.h>
#include <math.h>
#define SIZE 30

// funcion delclarations
int inputData1(int[]);
int inputData2(int[]);
void combine(int [], int[], int [], int, int);
void sort(int [], int);
void uniqueData(int [], int);
void output(int[], int[], int[], int, int);

int main(void)
{
  // local declarations
  int enterArray1[SIZE] = {0}; // user input array 1
  int enterArray2[SIZE] = {0}; // user input array 2
  int combinedArray[SIZE * 2] = {0}; // the combined array 
  int len1; // length of the first array
  int len2; // length of the second array 

  // statements
  // Accept user input
  len1 = inputData1(enterArray1);
  len2 = inputData2(enterArray2);
  // combine the two arrays
  combine(enterArray1, enterArray2, combinedArray, len1, len2);
  // conduct sorting of the array 
  sort(enterArray1, len1);
  sort(enterArray2, len2);
  sort(combinedArray, (len1 + len2));
  // find out the unique data in the three arrays
  uniqueData(enterArray1, len1);
  uniqueData(enterArray2, len2);
  uniqueData(combinedArray, (len1 + len2));
  // print out the final outputs
  printf("\n");
  output(combinedArray, enterArray1, enterArray2, len1, len2);

  return 0; 
} // main

/******************************************************************************
* Function:    inputData1
* Description: Accepts the first data set of the user input array
* Parameter:   array[], int, the predefined array
* Return:      int, the length of the user input array
 ******************************************************************************/
int inputData1(int array[])
{
  int i = 0;       // counter
  int element = 1; // user input

  printf("Enter data set #1 -> ");
  while (i < SIZE && element != EOF)
  {
    scanf("%d", &array[i]);
    element = array[i];
    i++;
  }
  if (array[SIZE-1] != -1)
  {
    i++;
  }

  return --i;
} // inputData1

/******************************************************************************
* Function:    inputData2
* Description: Accepts the first data set of the user input array
* Parameter:   array[], int, the predefined array
* Return:      int, the length of the user input array
******************************************************************************/
int inputData2(int array[])
{
  int i = 0;       // counter
  int element = 1; // user input

  printf("Enter data set #2 -> ");
  while (i < SIZE && element != EOF)
  {
    scanf("%d", &array[i]);
    element = array[i];
    i++;
  }
  if (array[SIZE - 1] != -1)
  {
    i++;
  }
  return --i;

} // inputData2

/******************************************************************************
* Function:    combine
* Description: Combines the two data sets into one array
* Parameters:  array1[], int, the first data set
*              array2[], int, the second data set
*              combinedArray[], int, the combined array predefined
*              len1, int, the length of the first data set
*              len2, int, the length of the second data set 
* Return:      void
******************************************************************************/
void combine(int array1[], int array2[], int combinedArray[], int len1, int len2)
{
  int i; // counter
  int n; // counter

  for (i = 0; i < len1; i++)
  {
    combinedArray[i] = array1[i];
  }
  for (n = 0; n < len2; n++)
  {
    combinedArray[len1 + n] = array2[n];
  }

  return;
} // combine

/******************************************************************************
* Function:    sort
* Description: Operates insertion sort
* Parameters:  array[], int, one of the arrays
*              len, int, the length of the array
* Return:      void
******************************************************************************/
void sort(int array[], int len)
{
  int i; // counter
  int j; // counter
  int temp; // temporary value to be sorted

  for (i = 1; i < len; i++)
  {
    temp = array[i];
    j = i - 1;
    while (temp < array[j] && j >= 0)
    {
      array[j + 1] = array[j];
      j--;
    }
    array[j + 1] = temp;
  }

  return;
}

/******************************************************************************
* Function:    uniqueData
* Description: manipulates the array to show the unique data in the set
* Parameters:  array[], int, one of the arrays
*              len, int, the lenght of the array
* Return:      void
******************************************************************************/
void uniqueData(int array[], int len)
{
  int i = 0; // counter
  int ct = 0; // counter

  while (i < (len - 1))
  {
    if (array[i] == array[i + 1])
    {
      ct = i;
      while (array[ct] == array[ct + 1])
      {
        array[ct] = 0;
        ct++;
      } 
      array[ct] = 0;
      i = ct + 1;
    }
    else
    {
      i++;
    }
  }

  return;
} // uniqueData

/******************************************************************************
* Function:    output
* Description: Prints out the final outputs
* Parameters:  uniqArray[], int, the array including the values of the uncommonly unique elements
*              holdFreq1[], int, the held frequency count array of data set one
*              holdFreq2[], int, the held frequency count array of data set two
*              len1, int, the length of the first data set
*              len2, int, the length of the second data set
* Return:      void
******************************************************************************/
void output(int uniqArray[], int array1[], int array2[], int len1, int len2)
{
  int i;    // counter
  int n;     // counter
  int ct;    // counter
  int p = 0;  // counter
  int q = 0; // counter
  int r = 0; // counter

  printf("Unique data within set #1: ");
  for (i = 0; i < len1; i++)
  {
    if (array1[i] > 0)
    {
      printf("%d ", array1[i]);
    }
    else
    {
      p++;
    }
  }
  if (p >= len1)
  {
    printf("None.");
  }
  printf("\nUnique data within set #2: ");
  for (n = 0; n < len2; n++)
  {
    if (array2[n] > 0)
    {
      printf("%d ", array2[n]);
    }
    else
    {
      q++;
    }
  }
  if (q >= len2)
  {
    printf("None.");
  }
  printf("\nData found only once across both sets: ");
  for (ct = 0; ct < len1 + len2; ct++)
  {
    if (uniqArray[ct] > 0)
    {
      printf("%d ", uniqArray[ct]);
    }
    else
    {
      r++;
    }
  }
  if (r >= len1 + len2)
  {
    printf("None.");
  }
  printf("\n");

  return;
} // output
