#ifndef SYN_ENG_H
#define SYN_ENG_H

#include<bits/stdc++.h>
using namespace std;

#include<string>

ofstream logFile;
#include "1705087_Symbol_Table.h"

#define ERROR_VAL popVal(error)//"$ERROR$" //
#define SYMBOL_TABLE_SIZE 30
#define ERROR_VALUE "ERROR_VALUE"



//FILE *logFile;
ofstream errorFile;
ofstream  parserFile;

extern int line_count;
extern int error_count;
int syntaxErrors = 0;

extern FILE *yyin;
extern char *yytext;


string variable_type;
bool flagFun = false;
string return_type="NULL";
string func_current="NULL";
string peremeter ="";



void yyerror(const char *s) {
	//cout << ">> " << "line no " << line_count << ": " << string(s) + " < " + yytext + ":=>:" + lookAheadBuf + " >"<< endl;
	//pushVal(error, ERROR_VAL + lookAheadBuf);
	//errorRule = true;
	//lookAheadBuf = yytext;
	//cout << "Error found "<<endl;
	
}

int yyparse();
int yylex();

symbolTable *table = new symbolTable(SYMBOL_TABLE_SIZE);

string toString(auto &i)
{
	stringstream ss;
	ss << i;
	return ss.str();
}

int countWord(string str)
{
	
	    int c=0;
	    
	    istringstream ss(str);

	    string word ; 
	  
	    while (ss >> word) 
	    {
	    	c++;
	    }

	return c;
}

int countCWord(string aa)
{
	
	int c=0;
	    
	 for(int i=0;i<aa.length();i++)
	{
		if(aa[i]==',')
		c++;
		
	} 

	return c;
}



bool isNumber(const string& str)
{
    for (char const &c : str) {
        if (isdigit(c) == 0) return false;
    }
    return true;
}

void logWriteLine(const string &s)
{
	logFile << "At line no: " << line_count <<" "<<s<< endl << endl;
	//fprintf(logFile,"At line no: %d %s\n\n",line_count,s);
}

void logWrite(const string &s)
{
	logFile <<s<< endl << endl;
	//fprintf(logFile,"%s\n\n",s);
}

void logWriteRule( const string &rule, const string &rule2) 
{
	logFile << "At line no: " << line_count <<" "<<rule + ": " + rule2<< endl << endl;
	
}

void printError(const string &msg)
{
	syntaxErrors++;
	errorFile << "Error(SYM) at line no " << line_count << ": " << msg << endl << endl;
	logFile << "Error(SYM) at line no " << line_count << ": " << msg << endl << endl;
}

void insertVarEarly(string id , string type )
{
	if(variable_type=="void")
	{
		printError( "Variable type can't be void ");
	}
	else
	{
		if(table->current->searchHash(id,false))
		{		
			printError( "Variable "+ id +" already declared before");
		}
		else{
		
			table->insertScope(id, type);
			symbolInfo* temp = table->current->searchHashAddress(id);
			temp->setidType("Variable");
			temp->setreturnType(variable_type);
			
			//cout<<"# Variable "<<temp->getName()<<" RET "<<variable_type<<" ID "<<id<<" type "<<type<<endl;
			}
	}
	
}

void insertArrayEarly(string id , string type , string size )
{
	if(variable_type=="void")
	{
		printError( "Array type can't be void ");
	}
	else
	{
		if(table->current->searchHash(id,false))
		{		
			printError( " Array "+ id +" already declared before");
		}
		else{
		
			table->insertScope(id, type);
			symbolInfo* temp = table->current->searchHashAddress(id);
			temp->setidType("Array");
			temp->setreturnType(variable_type);
			
			temp->setarrayIndex(stoi(size));
			
			if(!isNumber(size))
			{
				printError( "Array size must be integer");
			}
			
			//cout<<"#Array "<<temp->getName()<<" RET "<<variable_type<<" ID "<<id<<" type "<<type<<" size "<<size<<endl;
			}
	}
	
}


void insertFunEarly(string ret , string id,string pere,int mode)
{
				
	if(table->current->searchHash(id,false))
	{
		if(mode==0) // defination
		{
			printError("Multiple Declaration of Funtion");
		}
		else //declaration
		{
			symbolInfo* temp = table->current->searchHashAddress(id);
			
			if(temp->getarrayIndex()) 
			{
				printError("Multiple Declaration of Funtion");
			}
			else if(temp->getreturnType().compare(ret) != 0) 
			{
				printError("Mismatch of Funtion Return Type");
			}
			else if(countWord(temp->getparameterList()) != countWord(pere))
			{
				printError("Parameter List quantity mismatch");
			}

			else if(temp->getparameterList().compare(pere))
			{	
			
				   string aa = temp->getparameterList();
				    string bb = pere;
				    
				    string s1 = "";
				
				    for(int i=0;i<aa.length();i++)
					{
						if(aa[i]!=',')
						s1=s1+aa[i];
						else
						s1=s1+" "+aa[i]+" ";
					}
				 	aa=s1;	
				 	
				    s1 = "";
				
				    for(int i=0;i<bb.length();i++)
					{
						if(bb[i]!=',')
						s1=s1+bb[i];
						else
						s1=s1+" "+bb[i]+" ";
					}
				 	aa=s1;		
			 	
			 				
				    istringstream ss(aa);
				    istringstream s2(bb);
  
				    string word , word2; 
				  
				    while (ss >> word&&s2 >> word2) 
				    {
				    	if(word.compare(word2))
				    	{
				    		printError("Argument \" "+word +" \" mismatch with \" " +word2 +" \" In Parameter List ");
				    	}
				    }
			}
			
			temp->setarrayIndex(404);

		}
	
	}
	else
	{
	
		table->insertScope(id, "ID");
		symbolInfo* temp = table->current->searchHashAddress(id);
		temp->setidType("Funtion");
		temp->setreturnType(ret);
		return_type = ret ;
		temp->setparameterList(pere);
		temp->setarrayIndex(mode);
		//cout<<"# Funtion "<<temp->getName()<<" RET "<<ret<<" ID "<<id<<" PERE "<<pere<<endl;
	
	}
	
	logFile <<"DATA Entered"<< endl << endl;
}



void enterScope()
{
	logFile <<"Scope Entered"<< endl << endl;
	table->enterScope();
}

void exitScope()
{
	logFile <<"Scope Exited"<< endl << endl;
	table->printAllScope();
	table->exitScope();
	
}


#endif // SYN_ENG_H
