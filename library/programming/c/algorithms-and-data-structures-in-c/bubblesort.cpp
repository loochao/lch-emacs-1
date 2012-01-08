/* Algorithm::BubbleSort */

#include <iostream>

#define ARRAYSIZE 10
using namespace std;

unsigned int userInput(unsigned int *);

int main(int argc, char **argv)
{
  unsigned int inputArray[ARRAYSIZE];
  unsigned int tmp = 0;
  unsigned int inputArraySize = userInput(inputArray);

  //Bubble Algorithm
  for(unsigned int i = 0; i < inputArraySize; i++)  {
    for(unsigned int j = 1; j < (inputArraySize - i); j++)  {
      if(inputArray[j] < inputArray[j - 1])  {
        //swap values
        tmp = inputArray[j];
        inputArray[j] = inputArray[j - 1];
        inputArray[j - 1] = tmp;
      }
    }
  }

  //printing the sorted values
  cout << endl << "After applying bubble sort" << endl;
  for(unsigned int i = 0; i < inputArraySize; i++)  {
    cout << inputArray[i] << "\t";
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
  cout << inputArraySize;
  return inputArraySize;
}
