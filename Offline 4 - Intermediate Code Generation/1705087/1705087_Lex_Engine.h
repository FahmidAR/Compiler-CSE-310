#ifndef LEX_ENG_H
#define LEX_ENG_H

//extern FILE *logoutFile;
//extern FILE *errorFile;

#include<bits/stdc++.h>
using namespace std;
#include<string>
#include<string>

extern ofstream logFile;

#include "1705087_Symbol_Table.h"
#include "y.tab.h"

#define SYBLOTABLE_SIZE 7


extern ofstream logFile;
extern ofstream errorFile;
extern ofstream parserFile;
extern char *yytext;

int line_count=1;
int error_count=0;
string temp = "";

extern symbolTable *table;

string StringToUpper(string strToConvert)
{
    std::transform(strToConvert.begin(), strToConvert.end(), strToConvert.begin(), ::toupper);

    return strToConvert;
}

string ReplaceString(std::string subject, const std::string& search,
                          const std::string& replace) {
    size_t pos = 0;
    while ((pos = subject.find(search, pos)) != std::string::npos) {
         subject.replace(pos, search.length(), replace);
         pos += replace.length();
    }
    return subject;
}

void replaceAll(std::string& str, const std::string& from, const std::string& to) {
    if(from.empty())
        return;
    size_t start_pos = 0;
    while((start_pos = str.find(from, start_pos)) != std::string::npos) {
        str.replace(start_pos, from.length(), to);
        start_pos += to.length(); // In case 'to' contains 'from', like replacing 'x' with 'yx'
    }
}

bool replace(std::string& str, const std::string& from, const std::string& to) {
    size_t start_pos = str.find(from);
    if(start_pos == std::string::npos)
        return false;
    str.replace(start_pos, from.length(), to);
    return true;
}


string StringToParse(string strToConvert)
{
    /*strToConvert = ReplaceString(strToConvert,"\\n", "\n");
    strToConvert = ReplaceString(strToConvert,"\\t", "\t");
    strToConvert = ReplaceString(strToConvert,"\\\'", "\'");
    strToConvert = ReplaceString(strToConvert,"\\\"", "\"");
    strToConvert = ReplaceString(strToConvert,"\\0","\0");
    strToConvert = ReplaceString(strToConvert,"\\\n","");*/

    //replaceAll(strToConvert,"\\n", "\n");
    replaceAll(strToConvert,"\\t", "\t");
    replaceAll(strToConvert,"\\\'", "\'");
    replaceAll(strToConvert,"\\\"", "\"");
    replaceAll(strToConvert,"\\0","\0");
    //replaceAll(strToConvert,"\\\n","");

    while(replace(strToConvert,"\\n", "\n"))
    {
        //line_count++;
    }
    while(replace(strToConvert,"\\r", "\n"))
    {
        //line_count++;
    }
    while(replace(strToConvert,"\\\n",""))
    {
        line_count++;
    }
    while(replace(strToConvert,"\\\r",""))
    {
        line_count++;
    }

    return strToConvert;
}


void startSTRING()
{
    temp = "";
}

void addSTRING()
{
     temp = temp.append(yytext);
    //temp = temp + yytext ;
    //cout<<temp.data()<<endl;
}

void addSTRINGE()
{
     temp = temp.append("\\\n");
}

void addSTRINGEE()
{
     temp = temp.append("\n");
}


void endSTRING()
{
    string yytextU = "STRING";
    string parseU = StringToParse(temp.data());

    //fprintf(tokenout,"<%s,%s>",yytextU.data(),parseU.data());
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme \"%s\" found --> <%s,%s>\n\n",line_count,yytextU.data(),temp.data(),yytextU.data(),parseU.data());

}

void getSTRING()
{
    string yytextU = "STRING";
    string parseU = StringToParse(yytext);

    //fprintf(tokenout,"<%s,\"%s>",yytextU.data(),parseU.data());
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme \"%s\ found --> <%s,\"%s>\n\n",line_count,yytextU.data(),yytext,yytextU.data(),parseU.data());

}

void endSTRINGC()
{
    string yytextU = "COMMENT";
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme //%s found\n\n",line_count,yytextU.data(),temp.data());

}

void endSTRINGCM()
{
    string yytextU = "COMMENT";
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme /*%s*/ found\n\n",line_count,yytextU.data(),temp.data());

}

void keywordHandle()
{
    string yytextU = StringToUpper(yytext);

    //fprintf(tokenout,"<%s>",yytextU.data());
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n\n",line_count,yytextU.data(),yytext);

    //yylval.symbolValue = new SymbolInfo(yytext,yytextU.data());


}

void handleINT()
{
    string yytextU = "CONST_INT";

    //fprintf(tokenout,"<%s,%s>",yytextU.data(),yytext);
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n\n",line_count,yytextU.data(),yytext);
    //if(s.insertScope(yytext,yytextU.data()))
    //{s.printAllScope();}
    //else { fprintf(logout,"\n"); }

    yylval.symbData = new symbolInfo(yytext,yytextU.data(),"int");
}

void handleFLOAT()
{
    string yytextU = "CONST_FLOAT";

    //fprintf(tokenout,"<%s,%s>",yytextU.data(),yytext);
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n\n",line_count,yytextU.data(),yytext);
    //if(s.insertScope(yytext,yytextU.data()))
    //{s.printAllScope();}
    //else { fprintf(logout,"\n"); }

    yylval.symbData = new symbolInfo(yytext,yytextU.data(),"float");
}

void handleCHAR()
{
    string yytextU = "CONST_CHAR";
    string parseU = StringToParse(yytext);

    //fprintf(tokenout,"<%s,%s>",yytextU.data(),parseU.data());
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found --> <%s,%s>\n\n",line_count,yytextU.data(),yytext,yytextU.data(),parseU.data());
    //if(s.insertScope(yytext,yytextU.data()))
    //{s.printAllScope();}
    //else { fprintf(logout,"\n"); }

    yylval.symbData = new symbolInfo(yytext,yytextU.data(),"char");
}

void handleIdentifier()
{
    string yytextU = "ID";

    //fprintf(tokenout,"<%s,%s>",yytextU.data(),yytext);
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n\n",line_count,yytextU.data(),yytext);
    //if(s.insertScope(yytext,yytextU.data()))
    //{s.printAllScope();}
    //else { fprintf(logout,"\n"); }

    yylval.symbData = new symbolInfo(yytext,yytextU.data());
}

void handleERROR(string messErr)
{
    errorFile << "Error(LEX) at line no "<< line_count <<" : "<< messErr.data() <<" "<< yytext << endl << endl;
    error_count++;
}

void handleERRORS(string messErr)
{
    errorFile << "Error(LEX) at line no "<< line_count <<" : "<< messErr.data() <<" \" "<< yytext << endl << endl;

    error_count++;
}

void handleERRORC(string messErr)
{
    errorFile << "Error(LEX) at line no "<< line_count<<" : "<< messErr.data() <<" \\* "<< temp.data() << endl << endl;

    error_count++;
}



void keywordOP()
{
    string yytextU = "ADDOP";


    if(!(strcmp(yytext,"++")))
    {
        yytextU = "INCOP";
    }
    else if(!(strcmp(yytext,"--")))
    {
    	yytextU = "DECOP";
    }
    else if((!(strcmp(yytext,"*")))||(!(strcmp(yytext,"/")))||(!(strcmp(yytext,"%"))))
    {
        yytextU = "MULOP";
    }
    else if((!(strcmp(yytext,"<")))||(!(strcmp(yytext,"<=")))||(!(strcmp(yytext,">")))||(!(strcmp(yytext,">=")))||(!(strcmp(yytext,"==")))||(!(strcmp(yytext,"!="))))
    {
        yytextU = "RELOP";
    }
    else if(!(strcmp(yytext,"=")))
    {
        yytextU = "ASSIGNOP";
    }
    else if((!(strcmp(yytext,"&&")))||(!(strcmp(yytext,"||"))))
    {
        yytextU = "LOGICOP";
    }
    else if(!(strcmp(yytext,"!")))
    {
        yytextU = "NOT";
    }
    else if((!(strcmp(yytext,"<<")))||(!(strcmp(yytext,">>"))))
    {
        yytextU = "SHIFTOP";
    }
    else if((!(strcmp(yytext,"&")))||(!(strcmp(yytext,"|")))||(!(strcmp(yytext,"^"))))
    {
        yytextU = "BITOP";
    }
    else if(!(strcmp(yytext,"(")))
    {
        yytextU = "LPAREN";
    }
    else if(!(strcmp(yytext,")")))
    {
        yytextU = "RPAREN";
    }
    else if(!(strcmp(yytext,"{")))
    {
        yytextU = "LCURL";
    }
    else if(!(strcmp(yytext,"}")))
    {
        yytextU = "RCURL";
    }
    else if(!(strcmp(yytext,"[")))
    {
        yytextU = "LTHIRD";
    }
    else if(!(strcmp(yytext,"]")))
    {
        yytextU = "RTHIRD";
    }
    else if(!(strcmp(yytext,",")))
    {
        yytextU = "COMMA";
    }
    else if(!(strcmp(yytext,";")))
    {
        yytextU = "SEMICOLON";
    }

    //fprintf(tokenout,"<%s,%s>",yytextU.data(),yytext);
    //fprintf(logout,"Line no %d: TOKEN <%s> Lexeme %s found\n\n",line_count,yytextU.data(),yytext);
    /*
    if(!(strcmp(yytext,"{")))
    {
        s.enterScope();
    }
    else if(!(strcmp(yytext,"}")))
    {
        s.exitScope();
    }*/
    yylval.symbData = new symbolInfo(yytext,yytextU.data());
}

void getEOF()
{
    //cout<<"We are at END OF FILE "<<endl;
    //s.printAllScope();
}
#endif // LEX_ENG_H


