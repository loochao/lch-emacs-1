/* Algorithm::QuickSort, recursive implementation */
/* Author: Ankit Solanki ( http://simulacra.in ) */

#include <iostream>
#include <cstdlib>
#include <ctime>
#define ARRAYSIZE 10

using namespace std;

void randomInput(unsigned int*, unsigned int);
void quickSort(unsigned int*, unsigned int, unsigned int);
int verifySort(unsigned int*, unsigned int);
unsigned int partition(unsigned int*, unsigned int, unsigned int, unsigned int);
void swap(unsigned int*, unsigned int, unsigned int);
void printArray(unsigned int*, unsigned int);

unsigned int swaps;
unsigned int compares;

int main(int argc, char **argv)
{
  unsigned int inputArray[ARRAYSIZE];
  cout << "Creating a random array with " << ARRAYSIZE << " random elements." 
       << endl;
  randomInput(inputArray, ARRAYSIZE);

  cout << "Random array elements." << endl;
  printArray(inputArray, ARRAYSIZE);

  cout << "Performing quicksort." << endl;
  quickSort(inputArray, 0, ARRAYSIZE);

  cout << "Verifying that the array is sorted: ";
  if (verifySort(inputArray, ARRAYSIZE)) {
    cout << " verified." << endl;
  } else {
    cout << " ERROR! The sort was not properly performed." << endl;
  }
   
  cout << "Sorted array elements." << endl;
  printArray(inputArray, ARRAYSIZE);

  cout << "Number of swaps: " << swaps << ", Number of comparisions: " 
       << compares << endl;

  return 0;
}

void randomInput(unsigned int* array, unsigned int size) {
  srand(time(0));
  for(unsigned int i = 0; i < size; i++) {
    array[i] = rand() % 10000;
  }
  return;
}

void quickSort(unsigned int* array, unsigned int left, unsigned int right) {
  
  // if the array has more one (or zero) elements, it is already sorted
  if (right <= left + 1) {
    return;
  }
  compares++;

  // pick a pivot element
  unsigned int pivot = (right + left) / 2;

  /* Partition the list. This function accomplishes three things:
      1. The pivot element is put in its final place in the array
      2. All elements with value less than the pivot element are put to
         the left of it.
      3. All elements with values greatar than the pivot elemnet are 
         put to the right of it.
  */
  unsigned int newPivot = partition(array, left, right, pivot);

  // call quicksort recursively on each side
  quickSort(array, left, newPivot);
  quickSort(array, newPivot + 1, right);
}

unsigned int partition(unsigned int* array, unsigned int left, unsigned int right, unsigned int pivot) {
  unsigned int value = array[pivot];

  // move pivot to the end of the array
  swap(array, pivot, right - 1);

  unsigned int storeindex = left;
  for (unsigned int i = left; i < right - 1; i++) {
    compares++;
    if (array[i] <= value) {
      swap(array, i, storeindex);
      storeindex++;
    }
  }

  swap(array, storeindex, right - 1);

  return storeindex;
}

void swap(unsigned int* array, unsigned int pos1, unsigned pos2) {
  unsigned int temp = array[pos1];
  array[pos1] = array[pos2];
  array[pos2] = temp;
  swaps++;
}

int verifySort(unsigned int* array, unsigned int size) {
  int sorted = 1;

  for (unsigned int i = 0; i < size - 1 && sorted; i++) {
    if (array[i] > array[i + 1]) {
      sorted = 0;
    }
  }

  return sorted;
}

void printArray(unsigned int* array, unsigned int size)
{
  for (unsigned int i = 0; i < size; i++) {
    cout << array[i] << '\t';
  }

  cout << endl;
  return;
}
