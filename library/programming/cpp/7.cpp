#include <iostream>
#include <string>

using namespace std;
int main()
{
  string word;
  const int min_size = 4;
  while (cin >> word)
    {
      if( word.size() < min_size )
        continue;

      cout << word << "\n";
    }
}
