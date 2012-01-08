/*Algorithm::Selection Sort*/

#include <iostream>
#include <stdio.h>
#define ARRAYSIZE 10
using namespace std;

unsigned int userInput(unsigned int *);

int main(int argc, char **argv)
{
  unsigned int inputArray[ARRAYSIZE];
  unsigned int inputArraySize, n = 0;
  inputArraySize = userInput(inputArray);
  n = inputArraySize - 1;
  //In Selection Sort we pick up the maximum value in
  //the unsorted part of the array and put it at it
  //rightful place.

  //while loop terminates when n evaluates to 0 i.e. false
  while(n != 0)  {
    unsigned int maxValueIndex = 0;

    //Find the index of max value in the unsorted part of array
    for(unsigned int i = 0; i <= n; i++)  {
      if(inputArray[i] > inputArray[maxValueIndex])  {
        maxValueIndex = i;
      }
    }

    //Swap and put the max value at its rightful place
    unsigned int tmp = inputArray[maxValueIndex];
    inputArray[maxValueIndex] = inputArray[n];
    inputArray[n] = tmp;
    --n;
  }
  
  // Print the output
  for(unsigned int i = 0; i < inputArraySize; i++)  {
    std::cout << inputArray[i] << '\t';
  }
  return 0;
}

unsigned int userInput(unsigned int *inputArray)
{
  unsigned int inputArraySize = 0;
  cout << "Enter list of number and have them sorted."
       << "(Enter ZERO to terminate input)" << endl;
  /* Take input from user */
  for(inputArraySize = 0; inputArraySize < ARRAYSIZE; inputArraySize++)  {
    cout << "Enter a number :(" << inputArraySize + 1 << ") :" << endl;
    cin >> inputArray[inputArraySize];
    if(inputArray[inputArraySize] == 0)  {
      break;
    }
  }
  return inputArraySize;
}
