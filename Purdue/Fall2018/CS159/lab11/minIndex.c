/******************************************************************************
* Function:    findMin
* Description: This function finds the index within the array of the element with the smallest number of conversions
* Parameters:  array, int, the given array
* Return:      int, the index with the minimum value
******************************************************************************/
int findMin(int array[]);
{
  // Declarations
  int element;  //the i-th element in the given array
  int i;        //the counter for the for loop
  int min;      //the minimum   
  int minIndex; //the minimum index

  // Statements
  for (i = 0; i <= 18; i++)
  {
    element1 = array[i];
    element2 = array[i+1];
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
}


  
}
