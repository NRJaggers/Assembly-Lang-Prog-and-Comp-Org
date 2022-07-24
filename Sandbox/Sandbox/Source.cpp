1 //main.cpp - lists runtime parameters passed to main upon entry - command line
4 //
5 // main is passed two parameters:
6 // 1. an int containing the number of command line arguments which follow.
7 // the first command line argument will always be the path+program name.
8 // arguments 2-n are the user-entered arguments.
9 // 2. an array of char pointers, each pointing to a c-string containing a command line argument.
10 // 3. an array of char pointers, each pointing to a c-string containing an environmental variable.
11 //
12 using namespace std;
13 #include <string>
14 #include <iostream>
15
16 int main(int inputCount, char ** arg1, char ** arg2)
17 {
18 cout << "inputCount " << inputCount << endl;
19 string s1=arg1[0];
20 string s2=arg1[1];
21 cout <<"first two command line args" << endl;
22 cout << s1 << endl << s2 << endl;
23 s1=arg2[0];
24 s2=arg2[1];
25 cout <<"first two env vars" << endl;
26 cout << s1 << endl << s2 << endl;
27
28 return 0;
29 }
30
