#include <iostream>
#include <fstream>

using namespace std;
int main()
{
  int ival = 1024;
  int *pi;

  pi = &ival;
  //  cout << *pi << "\t" << pi << endl;

  ofstream outfile("loochao.tex", ios_base::app);

    if ( ! outfile )
      cerr << "Oops! Unable to save session data!\n" ;

    // else
    //   outfile << "loochao" <<  *pi << endl;

    ifstream infile("loochao.tex");
    string name;
    while(infile >> name)
      {
        cout << name << endl;
      }

}
