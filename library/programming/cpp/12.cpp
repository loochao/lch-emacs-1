#include <iostream>

using namespace std;

bool fib_elem(int, int &);
int main()
{
  cout << "please input the position you want to calculate \n" << endl;
  int pos;
  cin >> pos;

  int elem;
  if ( fib_elem(pos, elem) )
    cout << "element #" << pos
         << " is " << elem << endl;
  else
    cout << "Sorry, could not calculate element # "
         << pos << endl;

  return 0;
}

bool fib_elem(int pos, int &elem)
{
  if( pos<=0 || pos>1024)
    { elem=0; return false; }

  elem = 1;
  int n_2 = 1, n_1 =1;

  for ( int ix = 3; ix <= pos; ++ix )
    {
      elem = n_2 + n_1;
      n_2 = n_1; n_1 = elem;
    }

  cout << elem;
  return true;
}
