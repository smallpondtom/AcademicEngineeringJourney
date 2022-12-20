/******************************************************************************
* Assignment:  lab12
* Lab Section: Tuesday, 11:30, SC Hall
* Description: This program will accept data of test scores from two classes and based on the maximum value of total test score and the minimum number of students the program will select test scores and sum them up so that the final value does not surpass the maximum value. The outputs will be the sorted test scores and the total of scores along with the number of student test scores are used to generate the total. 
* Programmers: Tomoki Koike, koike@purdue.edu
*              Madison Green, green326@purdue.edu
*              Daniel Cinal, dcinal@purdue.edu
******************************************************************************/
#include <stdio.h>
#include <math.h>
#define SIZE 30

// function declarations
int inputData1(int []);
int inputData2(int []);
int input3(void);
int input4(int, int);
int compare_length_short(int, int);
int compare_length_long(int, int);
void sort(int [], int);
int cal_total(int [], int [], int, int, int*, int, int);
void output(int [], int [], int, int, int, int, int, int);

int main(void)
{
  // local declarations 
  int array1[SIZE] = {0}; // array of team 1
  int array2[SIZE] = {0}; // array of team 2 
  int len1; // length of array1
  int len2; // length of array2
  int max; // the maximum test score
  int student_min; // the minimum number of student scores
  int members = 0; // counter
  int teamTotal; // team total
  
  // statements 
  // accept the user inputs of two class arrays 
  len1 = inputData1(array1);
  len2 = inputData2(array2);
  // accept user inputs of the maximum test score 
  // and the minimum number of test scores
  max = input3();
  student_min = input4(len1, len2);
  printf("\n");
  // sorting the arrays 
  sort(array1, len1);
  sort(array2, len2);
  // calculating the team total the number of student scores
  teamTotal = cal_total(array1, array2, max, student_min, &members, len1, len2);
  // printing out the final outputs 
  output(array1, array2, len1, len2, teamTotal, members, student_min, max);

  return 0;
} // main

/******************************************************************************
* Function:    inputData1
* Description: The first user input of test scores of class one
* Parameters:  array[], int, predefined array of test scores 
* Return:      int, the length of the array with non-zero values
******************************************************************************/
int inputData1(int array[])
{
  int i = 0;       // counter
  int element = 1; // user input

  printf("Enter student math scores for class #1 -> ");
  while (i < SIZE && element != EOF)
  {
    scanf("%d", &array[i]);
    element = array[i];
    i++;
  }
  if (array[SIZE - 1] != -1 && array[SIZE - 1] != 0)
  {
    i++;
  }

  return --i;
} // inputData1

/******************************************************************************
* Function:    inputData2
* Description: The first user input of test scores of class two
* Parameters:  array[], int, predefined array of test scores 
* Return:      int, the length of the array with non-zero values
******************************************************************************/
int inputData2(int array[])
{
  int i = 0;       // counter
  int element = 1; // user input

  printf("Enter student math scores for class #2 -> ");
  while (i < SIZE && element != EOF)
  {
    scanf("%d", &array[i]);
    element = array[i];
    i++;
  }
  if (array[SIZE - 1] != -1 && array[SIZE - 1] != 0)
  {
    i++;
  }

  return --i;
} // inputData2

/******************************************************************************
* Function:    compare_length_short
* Description: Outputs the shorter length which are the outputs of the two input functions 
* Parameters:  len1, int, length of the first array
*              len2, int, length of the second array 
* Return:      int, the shorter length
******************************************************************************/
int compare_length_short(int len1, int len2)
{
  int shorter; // shorter length 
  
  if (len1 > len2)
  {
    shorter = len2;
  }
  else 
  {
    shorter = len1;
  }

  return shorter;
} // compare_length_short

/******************************************************************************
* Function:    compare_length_long
* Description: Outputs the longer length which are the outputs of the two input functions 
* Parameters:  len1, int, length of the first array
*              len2, int, length of the second array 
* Return:      int, the longer length
******************************************************************************/
int compare_length_long(int len1, int len2)
{
  int longer; // shorter length

  if (len1 > len2)
  {
    longer = len1;
  }
  else
  {
    longer = len2;
  }

  return longer;
} // compare_length_long

/******************************************************************************
* Function:    input3
* Description: Accepts the user input of the maximum test total
* Parameters:  void
* Return:      int, the maximum test total
******************************************************************************/
int input3(void)
{
  int max; // the set team total

  do
  {
    printf("Enter maximum team test total -> ");
    scanf("%d", &max);
    if (max <= 0)
    {
      printf("\nError! Team test total must be positive!!\n\n");
    }
  } while (max <= 0);
  return max;
} // input3

/******************************************************************************
* Function:    input4 
* Description: Accepts the user input of the minimum number of student scores that must be used for the sum
* Parameters:  len1, int, the length of the first array 
*              len2, int, the length of the second array 
* Return:      int, the minimum number of test scores 
******************************************************************************/
int input4(int len1, int len2)
{
  int student_min; // the set team total
  int limit; // the shorter length of the either two classes
  
  // obtains the shorter length of the classes 
  limit = compare_length_short(len1, len2);

  do
  {
    printf("Enter minimum number of students to select from a class -> ");
    scanf("%d", &student_min);
    if (student_min > limit)
    {
      printf("\nError! Number to select cannot exceed %d!!\n\n", limit);
    }
    else if (student_min <= 0)
    {
      printf("\nError! Number to select must be positive!!\n\n");
    }
  } while ( student_min > limit || student_min <= 0);
  return student_min;
} // input4

/******************************************************************************
* Function:    sort
* Description: Conducts insertion sort for the array 
* Parameters:  array[], int, the predefined array 
*              len, int, the length of the array
* Return:      void
******************************************************************************/
void sort(int array[], int len)
{
  int i;  // counter
  int j;  // counter 
  int temp; // temporary element 

  for (i = 1; i < len; i++)
  {
    temp = array[i];
    j = i - 1;
    while (temp > array[j] && j >= 0)
    {
      array[j + 1] = array[j];
      j--;
    }
    array[j + 1] = temp;
  }

  return;
} // sort

/******************************************************************************
* Function:    cal_total 
* Description: Calculates the total test score depending on the maximum limit and the minimum limit of students 
* Parameters:  sorted_array1[], int, the sorted first array 
*              sorted_array[], int, the sorted second array
*              max, int, the maximum test score
*              student_min, int, the minimum number test scores 
*              *counter, int, the counter that counts the number of students scores used for the calculation which is passed by address
*              len1, int, the length of the first array
*              len2, int, the length of the second array
* Return:      int, the calculated total
******************************************************************************/
int cal_total(int sorted_array1[], int sorted_array2[], int max, int student_min, int *counter, int len1, int len2)
{
  int team_total = 0; // the team total
  int hold1; // the value holder for the team total
  int hold2; // another value holder for team total 
  int i = 0; // counter
  int ct = student_min; // counter
  int element1; // the i-th element in array one
  int element2; // the i-th element in array two
  int longer; // longer length

  // find longer length
  longer = compare_length_long(len1, len2);

  for (i = 0; i < student_min; i++)  
  {
    team_total += sorted_array1[i];
  }
  for (i = 0; i < student_min; i++)
  {
    team_total += sorted_array2[i];
  }
  *counter += student_min*2; 
  if (team_total <= max)
  {
    // counter (ct) is initialized as student_min
    while (ct < longer)
    {
      element1 = sorted_array1[ct];
      element2 = sorted_array2[ct];
      hold1 = team_total + element1;
      //printf("hold1: %d, hold2: %d\n", hold1,hold2);
      if (hold1 <= max && element1 != EOF && element1 != 0)
      {
        team_total += element1;
        *counter += 1;
      }
      if (hold1 > max)
      {
        ct += longer;
      }
      hold2 = team_total + element2;
      if (hold2 <= max && element2 != EOF && element2 != 0)
      {
        team_total += element2;
        *counter += 1;
      }
      ct++;
    }
  }
  else
  {
    team_total = 0;
  }
  return team_total;        
} //cal_total

/******************************************************************************
* Function:    output
* Description: Prints out the final outputs 
* Parameters:  array1[], int, the first array
*              array2[], int, the second array 
*              len1, int, the length of the first array
*              len2, int, the length of the second array
*              team_total, int, the calculated team total
*              students, int, the number of student scores 
*              student_min, int, the minimum limit of student scores 
*              max, int, the maximum limit of the test score total
* Return:      void
******************************************************************************/
void output(int array1[], int array2[], int len1, int len2, int team_total, int students, int student_min, int max)
{
  int i; // counter
  int ct; // counter

  printf("Class #1 Students Sorted: ");
  for (i = 0; i < len1; i++)
  { 
    printf("%d ", array1[i]);  
  }
  printf("\nClass #2 Students Sorted: ");
  for (ct = 0; ct < len2; ct++)
  {
    printf("%d ", array2[ct]);
  }

  if (team_total != 0)
  {
    printf("\nTeam total: %d", team_total);
    printf("\nTeam members: %d\n", students);
  }
  else 
  {
    printf("\nResult: Cannot create a team with %d members and fewer than %d points.\n", student_min * 2, max);
  }

  return;
} // output 
