#include <iostream>
#include <vector>

using namespace std;
int main()
{
  const int seq_size = 12;
  vector<int> pell_seq( seq_size );

  pell_seq[ 0 ] = 1;
  pell_seq[ 1 ] = 2;

  for ( int ix = 2; ix < seq_size; ix ++)
    pell_seq[ ix ] = pell_seq[ ix -1] + pell_seq [ ix -2 ];

  cout << "The first " << seq_size << " in the pell series: \n\t";
    for( int ix = 0; ix < seq_size; ix++)
      cout << pell_seq[ ix ] << ' ';

    cout << "\n";

}
