#include <iostream>

using namespace std;

int main()
{
  int a(0);

  cout << "Please input an integer. \n";
  cin >> a;
  switch (a)
    {
    case 0:
      cout << "You are a pig!\n"; break;
    case 1:
      cout << "You are baobao\n";
    case 2:
      cout << "You are laoyao\n"; break;
    case 3:
      cout << "You are loochao\n"; break;
    default:
      cout << "Don't input blindly!\n"; break;
    }
}
