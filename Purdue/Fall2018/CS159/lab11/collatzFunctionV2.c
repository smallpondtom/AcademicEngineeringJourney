/******************************************************************************
* Function:    collatz
* Description: This fucntion converts the given elements in the array and counts the number of conversion for each element and makes an array consisting of the counts for each element.
* Parameters:  array, int, the user input array
* Return:      void
******************************************************************************/
void collatz(int array[])
{
  //Declarations
  int element;      // the i-th element in the array
  int count;        // counter for # of conversions
  int i;            // counter for the for loop

  //Statements
  for (i = 0; i < 20; i++)
  {
    // defining the i-th element in the given array
    element = array[i];

    // initializing the "count" so that it resets to zero for each of the for loop iteration
    count = 0;

    /* The Collatz Conjecture is a theory that any number can
     * be converted to one by using two ways of conversion: 
     * when the number is "A" and if mod(A)=0 we do the 
     * conversion of A/2, and if mod(A)=1 then we do the 
     * conversion of 3A+1. By repeating these two methods A 
     * will eventually become 1. */

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
    array[i] = count;
  }
  return;
}
