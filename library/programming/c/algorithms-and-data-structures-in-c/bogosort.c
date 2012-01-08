/* Algorithm::Bogosort */

#include <iostream>

#define ARRAYSIZE 10
using namespace std;

unsigned int userInput(unsigned int *);

int main(int argc, char **argv)
{
  unsigned int inputArray[ARRAYSIZE];
  bool sorted = false;
  unsigned int index = 0;
  unsigned int tmp = 0;
  unsigned int iterationNo = 0;
  unsigned int inputArraySize = userInput(inputArray);

  //Bogosort Algorithm
  while(sorted == false)  {
  
    for(unsigned int i = 0; i < inputArraySize; i++)  {
      //Choose a random index with which to swap values
      index = (rand() % (inputArraySize - 1));
      //swap values
      tmp = inputArray[i];
      inputArray[i] = inputArray[index];
      inputArray[index] = tmp;
    }

    sorted = true;
    cout << "Iteration No" << iterationNo++ << endl;

    //Checking if it's sorted
    for(unsigned int i = 0; i < inputArraySize - 1; i++)  {
      if(inputArray[i] > inputArray[i + 1])  {
        sorted = false;
	break;
      }
    }

  }

  //printing the sorted values
  cout << endl << "After applying random sort" << endl;
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
