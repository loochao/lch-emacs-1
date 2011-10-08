#include <iostream>
#include <vector>

using namespace std;
int main()
{
  const int array_size = 12;
  vector<int> int_array;

  for ( int ix = 0; ix < array_size; ix++ )
    {
      cout << "Please input integers" << endl;
      cin >> int_array[ix];
    }

  int sum = 0;
  for ( int ix = 0; ix < 12; ix++ )
    {
      sum = sum + int_array[ix];
    }
  float avg = sum/12;
  cout << "sum is"
       << sum
       << "\n"
       << "average is"
       << avg
       << "\n";
}
