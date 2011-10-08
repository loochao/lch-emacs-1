#include <iostream>
#include <string>
using namespace std;
int main()
{
  int value;
  int total_times;
  int correct_times;
  string username;
  float ratio;
  char next;
  bool test = true;
  cout << "Please input your name: \n";
  cin >> username;

  while(test)
    {
      cout << "2 and 3 are consecutive \n";
      cout << "what's the next value?\n";
      cin >> value;
      total_times++;

      if(value == 5)
        {
          correct_times++;
          cout << "That's correct!\n";
        }
      else
        {
          cout << "You are wrong\n";
        }

      cout << "Once more? Y/N\n";
      cin >> next;
      if(next == 'Y' || next == 'y')
        test = true;
      else
        {
        test = false;
        ratio = correct_times/total_times;
        cout << ratio <<"\n";
        }
    }
  return 0;
}
