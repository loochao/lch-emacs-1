#include <iostream.h>
#define min(a,b) ((a) < (b) ? (a) : (b))

const int size = 10;
int ia[size];

main() {
  int elem_cnt = 0;
  int *p = &ia[0];

  //clount the number of array elements
  while ( min(p++, &ia[size]) != &ia[size] )
    ++elem_cnt;

  cout << "elem_cnt : " << elem_cnt
       << "\texpecting: " << size << endl;
  return 0;
}
