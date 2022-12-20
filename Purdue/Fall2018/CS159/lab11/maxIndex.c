/******************************************************************************
* Function:    findMax
* Description: This function finds the index within the array of the element with the largest number of conversions
* Parameters:  array, int, the given array
* Return:      int, the index with the maximum value
******************************************************************************/
int findMax(int array[]);
{
  // Declarations
  int element;  //the i-th element in the given array
  int i;        //the counter for the for loop
  int max;      //the minimum   
  int maxIndex; //the minimum index

  // Statements
  for (i = 0; i <= 18; i++)
  {
    element1 = array[i];
    element2 = array[i+1];
    if (i == 1)
    {
      if (element1 > element2)
      {
        max = element1;
        minIndex = i;
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
}


  
}
