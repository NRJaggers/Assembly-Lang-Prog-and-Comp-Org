/*;  *************************************************************
;  Student Name : Nathan Jaggers
;  COMSC - 260 Fall 2019
;  Date:11 / 13 / 2019
;  Assignment 07
;  Version of Visual Studio used : 2019
;  Did program compile ? Yes
;  Did program produce correct results ? Yes 
;  Is code formatted correctly including indentation, spacingand vertical alignment ? Yes 
;  Is every line of code commented ? Yes / No
;
;  Estimate of time in hours to complete assignment : 3 hours 20 min
;  In a few words describe the main challenge in writing this program:
;
;  Short description of what program does :
;
;
;  *************************************************************
;  Reminder: each assignment should be the result of your
;  individual effort with no collaboration with other students.
;
;  Reminder: every line of code must be commentedand formatted
;  per the ProgramExpectations.pdf file on the class web site
; *************************************************************
*/

#include <iostream>
#include <iomanip>
#include <fstream>

using namespace std;

const int MAX_SIZE = 60;
const char INDENT[MAX_SIZE] = "     ";

//write C++ prototypes for the following asm functions.
//
//(See HLLInterfaceCpp.cpp for an example of writing a prototype to asm functions)
//Declaring a pointer to a char is:
// char *
//
//  StrNCpyAsm
//     returns: void
//     3 parameters (in order): pointer to a char,pointer to a char, int
       extern "C" void __stdcall StrNCpyAsm(char*, char*, int);
//  StrCatAsm
//     returns: void
//     2 parameters (in order): pointer to a char,pointer to a char
       extern "C" void __stdcall StrCatAsm(char*, char*);
//  StrRemove
//     returns: void
//     3 parameters (in order): pointer to a char,int, int
       extern "C" void __stdcall StrRemove(char*, int, int);
//
//  StrInsertEC
//     returns: void
//     3 parameters (in order): pointer to a char,pointer to a char, int
//       extern "C" void __stdcall StrInsertEC(char*, char*, int);

int main()
{
    //do not change the arrays below
	char str3[MAX_SIZE] = "words,dwords";
	char str4[MAX_SIZE] = {'b','y','t','e','s',0,'&','&','&','&','&','&','&','&','&',0};
	char str5[MAX_SIZE] = {'1','2','3','4','5','6','7',0,'Z','Z','Z','Z','Z','Z','Z','Z','Z',0};
	char str6[MAX_SIZE] = {'A','B','C',0,'X','X','X','X','X','X','X','X','X','X','X','X',0};
	char str7[MAX_SIZE] = {'h','e','l','l','o',0,'@','@','@','@','@','@','@','@','@',0};
    char str8[MAX_SIZE] = {' ','P','a','t',0,'@','@','@','@','@','@','@','@','@',0};
	char str10[MAX_SIZE] = { 'Y','o','u',' ','s','h','o','u','l','d',' ','e','f','f','i','c','i','e','n','t',' ','c','o','d','e',0,'@','@','@','@','@','@','@','@','@',0 };
	char str11[MAX_SIZE] = { 'w','r','i','t','e',' ',0,'@','@','@','@','@','@','@','@','@',0 };
    char str12[MAX_SIZE] = {'C','o','m','m','e','n','t','s',' ','h','e','l','p',' ','h','e','l','p',' ','m','a','k','e',' ','y','o','u','r',' ','c','o','d','e',' ','u','n','d','e','r','s','t','a','n','d','a','b','l','e','.',0,'@','@','@','@','@','@',0};
    char str13[MAX_SIZE] = {'l','u','l','l','a',0,'@','@','@','@','@','@','@','@',0};
    char str14[MAX_SIZE] = {'S','i','n','g',' ','a',' ',0,'@','@','@','@','@','@',0};
    char str15[MAX_SIZE] = {'A','r','n','o','l','d',0,'@','@','@','@','@','@',0};
    char str16[MAX_SIZE] = {'W','h','o',' ','s','a','i','d',' ','I','\'','l','l',' ','b','e',' ','b','a','c','k','?',0,'@','@','@','@',0};
    char str17[MAX_SIZE] = {'T','a','y','l','o','r',' ','S','w','i','f','t',' ','i','s',' ','a',' ','g','o','o','d',' ','c','o','u','n','t','r','y',' ','s','i','n','g','e','r','.',0,'@','@','@','@',0};
    char str18[MAX_SIZE] = {'v','e','r','y',' ',0,'@','@','@','@','@','@',0};
	char str19[MAX_SIZE] = { 'A','s','s','e','m','b','l','y',' ','i','s',' ','m','a','g','i','c','a','l',0,'#','#','#','#','#','#',0 };
	char str20[MAX_SIZE] = { 'P','a','r','t','y','i','n','g',' ','i','s',' ','f','u','n',0,'#','#','#','#','#','#',0 };


    //Output is to a file. 
    //The output file should be in your project directory

    ofstream outfile("outputProg7.txt");

    //Test for successful file opening.
    //If the file does not open print error msg and exit.
    if(!outfile)
    {
        cerr << "File did not open!" << endl;
        cin.get();
        exit(1);
    }

	//program author
	outfile << "Program 7 by Nathan Jaggers." << endl << endl;

	//call StrNCpyAsm to copy str19 to str20 but no more than 8 characters
    //StrNCpyAsm(destination, source, count)
    StrNCpyAsm(str20, str19, 8);
	outfile << "After trying to copy 8 chars from str19 to str20, str20 contains " << endl << endl;
	outfile << INDENT << "str20: " << str20 << endl << endl;

	//call StrNCpyAsm to copy str16 to str15 but no more than 400 characters
    //StrNCpyAsm(destination, source, count)
    StrNCpyAsm(str15, str16, 400);
	outfile << "After trying to copy 400 chars from str16 to str15, str15 contains " << endl << endl;
	outfile << INDENT << "str15: " << str15 << endl << endl;

	outfile << "Before copying to str3, str3 contains" << endl<< endl;

	outfile << INDENT << "str3: " << str3 << endl<< endl;

	//call StrNCpyAsm to copy str4 to str3 but no more than 5 characters
	//(To pass an array to a function just use the name of the array)
    //StrNCpyAsm(destination, source, count)
    StrNCpyAsm(str3, str4, 5);
	outfile << "After trying to copy 5 chars from str4 to str3, str3 contains " << endl << endl;
	outfile << INDENT << "str3: " << str3 << endl<< endl;

	//call StrNCpyAsm to copy str5 to str3 but no more than 8 characters
    //StrNCpyAsm(destination, source, count)
    StrNCpyAsm(str3, str5, 8);
	outfile << "After trying to copy 8 chars from str5 to str3, str3 contains " << endl << endl;
	outfile << INDENT << "str3: " << str3 << endl<< endl;

	//call StrNCpyAsm to copy str6 to str3 but no more than 400 characters
    //StrNCpyAsm(destination, source, count)
    StrNCpyAsm(str3, str6, 400);
	outfile << "After trying to copy 400 chars from str6 to str3, str3 contains " << endl << endl;
	outfile << INDENT << "str3: " << str3 << endl << endl;

	//Call StrCatAsm to append str8 to str7
    //StrCatAsm(destination, source)
    StrCatAsm(str7, str8);
	outfile << "After appending str8 to str7, str7 contains " << endl << endl;
	outfile << INDENT << "str7: " << str7 << endl << endl;

    outfile << "Before removing 5 characters from str12, str12 contains " << endl << endl;
	outfile << INDENT << "str12: " << str12 << endl << endl;

    //Call StrRemove to remove 5 characters from str12 starting at location 9
    //StrRemove(string, location, count)
    StrRemove(str12, 9, 5);
    outfile << "After removing 5 characters from str12, str12 contains " << endl << endl;
	outfile << INDENT << "str12: " << str12 << endl << endl;

  //**************Extra Credit******************

    //Write the extra credit StrInsertEC routine in the asm file and then test it as follows:

    //Only uncomment the following lines if you do the extra credit

    // outfile << "******************EXTRA CREDIT**************" << endl << endl;

	// outfile << "Before inserting str11 into str10, str10 contains " << endl << endl;
	// outfile << INDENT << "str10: " << str10 << endl << endl;

    // //call StrInsertEC to insert str11 into str10 starting at position 11
    // StrInsertEC(str10, str11, 11);
    // outfile << "After inserting str11 into str10, str10 contains " << endl << endl;
	// outfile << INDENT << "str10: " << str10 << endl << endl;

	return 0;


}