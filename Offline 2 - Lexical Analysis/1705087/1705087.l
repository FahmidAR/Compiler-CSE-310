%option noyywrap

%x COMMENT_SINGLE
%x COMMENT_MULTI
%x STRING_STATE
%x QUOTE

%{
#include<bits/stdc++.h>
using namespace std;
#include<string>
#include<stdio.h>
#include<stdlib.h>

#include "1705087_Lex_Engine.h"

%}

WHITESPACE [ \t\f\r\v]+ 
LETTER [a-zA-Z]
LETTERU [a-zA-Z_]
DIGIT [0-9]
DIGITS {DIGIT}+
NEWLINE \r?\n
NOT_NEWLINE [^{NEWLINE}]
NOT_NEWLINE_OFI [^\n\\\"]]
ALL {NEWLINE}|{NOT_NEWLINE}

INTEGER_LITERALS {DIGITS}
FLOAT_LITERALS ({DIGIT})*(\.?{DIGITS})(E[+-]?{DIGITS})?
CHARACTER_LITERALS ('{NOT_NEWLINE}')
CHARACTER_LITERALS_E ('\\{NOT_NEWLINE}')

IDENTIFIER {LETTERU}({LETTERU}|{DIGIT})*

TOO_DEC {DIGIT}*(\.|{DIGIT})+
ILL_NUMBER ({DIGIT})*(\.?{DIGITS})(E[+-]?{FLOAT_LITERALS})+

INV_CHAR_SEQ {DIGITS}({LETTERU}|{DIGIT})*
INV_CHAR_LITERALS ('.{2,}')
UNF_CHAR_LITERALS ('{NOT_NEWLINE}|'\\'|'\\{NOT_NEWLINE})
EMPTY_CHAR ('')

NEWLINE_COMMENT (\\{NEWLINE})
SLASH_Q (\\\")
SLASH [\\]
Q \"

HALF_STRING ([^"\\\r\n]|{SLASH}{ALL})*
FULL_STRING {HALF_STRING}\"



%%
 
["] { startSTRING(); BEGIN STRING_STATE; }
<STRING_STATE>{FULL_STRING} { getSTRING(); BEGIN INITIAL; }
<STRING_STATE>{HALF_STRING} { handleERRORS("Unfinished string"); line_count++; BEGIN INITIAL; }
<STRING_STATE>{NEWLINE} { handleERRORS("Unfinished string"); BEGIN INITIAL; }


"//" { startSTRING(); BEGIN COMMENT_SINGLE; }

<COMMENT_SINGLE>{NEWLINE_COMMENT} {addSTRINGE(); line_count++;}
<COMMENT_SINGLE>{NEWLINE} { endSTRINGC(); line_count++; BEGIN INITIAL; }
<COMMENT_SINGLE>{NOT_NEWLINE} { addSTRING(); }

"/*" { startSTRING(); BEGIN COMMENT_MULTI; } 

<COMMENT_MULTI>{NEWLINE} { addSTRINGEE(); line_count++;}
<COMMENT_MULTI>"*/" { endSTRINGCM(); BEGIN INITIAL; }
<COMMENT_MULTI><<EOF>> { handleERRORC("Unfinished comment");  BEGIN INITIAL; }
<COMMENT_MULTI>{NOT_NEWLINE} { addSTRING(); }

{WHITESPACE} {}

{INTEGER_LITERALS} { handleINT(); }

{FLOAT_LITERALS} { handleFLOAT(); }

{EMPTY_CHAR} { 	handleERROR("Empty character constant error"); }

{UNF_CHAR_LITERALS} { 	handleERROR("Unterminated character"); }
{CHARACTER_LITERALS} { handleCHAR(); }
{CHARACTER_LITERALS_E} { handleCHAR(); }

{NEWLINE} {line_count++;}

"if" 		|

"for" 		|

"do" 		|

"int" 		|

"float" 	|

"void" 	|

"switch" 	|

"default" 	|

"else" 	|

"while" 	|

"break" 	|

"char" 	|

"double" 	|

"return"	|

"case" 	|

"continue" 	{
			keywordHandle();
	        }


"*"|"/"|"%"		     |

"++"|"--"		     |

"+"|"-"                     |
		
"<"|"<="|">"|">="|"=="|"!=" |

"="			     |
	
"&&"|"||"	             |
					
"&"|"|"|"^"                 |

"<<"|">>"                   |
					
"!"			     |
					
"("			     |
								
")"			     |								

"{"			     |
								
"}"			     |
								
"["			     |								

"]"			     |
							
","			     |								

";"   {
			keywordOP();
      }
      
{IDENTIFIER} { handleIdentifier(); }	

{TOO_DEC} { 	handleERROR("Too many decimal point "); }

{ILL_NUMBER} { 	handleERROR("Ill formed number "); }

{INV_CHAR_SEQ} { 	handleERROR("Invalid Suffix on numeric constant or invalid prefix on "); }

{INV_CHAR_LITERALS} { 	handleERROR("Multi character constant error "); }
		
{ALL} { handleERROR("Unrecognized character"); }

<<EOF>> {
		getEOF();
		fprintf(logout,"\nTotal Line Number: %d\nTotal Errors: %d\n",line_count,error_count); 
		return 0;
	}
		

%%

int main(int argc,char *argv[]){
	
	if(argc!=2){
		printf("Please provide input file name and try again\n");
		return 0;
	}
	
	FILE *fin=fopen(argv[1],"r");
	if(fin==NULL){
		printf("Cannot open specified file\n");
		return 0;
	}
	
	logout= freopen ("1705087_log.txt","w+",stdout);
	
	//logout= fopen("1705087_log.txt","a+");
	tokenout= fopen("1705087_token.txt","w");

	yyin= fin;
	yylex();
	fclose(yyin);
	fclose(tokenout);
	fclose(logout);
	return 0;
}
