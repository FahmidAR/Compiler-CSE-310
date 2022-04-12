%option noyywrap

%x COMMENT_SINGLE
%x COMMENT_MULTI
%x STRING_STATE
%x QUOTE

%{
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
<STRING_STATE>{FULL_STRING} { getSTRING(); BEGIN INITIAL; return STRING;}
<STRING_STATE>{HALF_STRING} { handleERRORS("Unfinished string"); line_count++; BEGIN INITIAL; }
<STRING_STATE>{NEWLINE} { handleERRORS("Unfinished string"); BEGIN INITIAL; }


"//" { startSTRING(); BEGIN COMMENT_SINGLE; }

<COMMENT_SINGLE>{NEWLINE_COMMENT} {addSTRINGE(); line_count++;}
<COMMENT_SINGLE>{NEWLINE} { endSTRINGC(); line_count++; BEGIN INITIAL; return COMMENT; }
<COMMENT_SINGLE>{NOT_NEWLINE} { addSTRING(); }

"/*" { startSTRING(); BEGIN COMMENT_MULTI; } 

<COMMENT_MULTI>{NEWLINE} { addSTRINGEE(); line_count++;}
<COMMENT_MULTI>"*/" { endSTRINGCM(); BEGIN INITIAL; return COMMENT; }
<COMMENT_MULTI><<EOF>> { handleERRORC("Unfinished comment");  BEGIN INITIAL; return COMMENT; }
<COMMENT_MULTI>{NOT_NEWLINE} { addSTRING(); }

{WHITESPACE} {}

{INTEGER_LITERALS} { handleINT(); return CONST_INT; }

{FLOAT_LITERALS} { handleFLOAT(); return CONST_FLOAT;}

{EMPTY_CHAR} { 	handleERROR("Empty character constant error"); }

{UNF_CHAR_LITERALS} { 	handleERROR("Unterminated character"); }
{CHARACTER_LITERALS} { handleCHAR(); return CONST_CHAR;}
{CHARACTER_LITERALS_E} { handleCHAR(); return CONST_CHAR;}

{NEWLINE} {line_count++;}


"if" 				{return IF;}

"for" 				{return FOR;}

"do" 				{return DO;}

"int" 				{return INT;}

"float" 			{return FLOAT;}

"void" 			{return VOID;}

"switch" 			{return SWITCH;}

"default" 			{return DEFAULT;}

"else" 			{return ELSE;}

"while" 			{return WHILE;}

"break" 			{return BREAK;}

"char" 			{return CHAR;}

"double" 			{return DOUBLE;}

"return"			{return RETURN;}

"case" 			{return CASE;}

"continue"			{return CONTINUE;}

"println"   			{return PRINTLN;}


"*"|"/"|"%"		     { keywordOP(); return MULOP;} 

"++"		             { keywordOP(); return INCOP;} 

"--"		    	     { keywordOP(); return DECOP;} 

"+"|"-"                     { keywordOP(); return ADDOP;} 
		
"<"|"<="|">"|">="|"=="|"!=" { keywordOP(); return RELOP;} 

"="			     { keywordOP(); return ASSIGNOP;} 
	
"&&"|"||"	             { keywordOP(); return LOGICOP;} 
					
"&"|"|"|"^"                 { keywordOP(); return BITOP;} 

"<<"|">>"                   { keywordOP(); return SHIFTOP;} 
					
"!"			     { keywordOP(); return NOT;} 


					
"("			{return LPAREN;}

")"			{return RPAREN;}

"{"			{return LCURL;}

"}"			{return RCURL;}

"["			{return LTHIRD;}

"]"			{return RTHIRD;}

","			{return COMMA;}

";"		        {return SEMICOLON;}
      
{IDENTIFIER} { handleIdentifier();  return ID; }	

{TOO_DEC} { 	handleERROR("Too many decimal point "); return CONST_FLOAT; }

{ILL_NUMBER} { 	handleERROR("Ill formed number "); return CONST_FLOAT;}

{INV_CHAR_SEQ} { 	handleERROR("Invalid Suffix on numeric constant or invalid prefix on "); return CONST_CHAR; }

{INV_CHAR_LITERALS} { 	handleERROR("Multi character constant error "); return CONST_CHAR; }
		
{ALL} { handleERROR("Unrecognized character"); }

<<EOF>> {
		getEOF();
		//fprintf(logoutFile,"\nTotal Line Number: %d\nTotal Errors: %d\n",line_count,error_count); 
		//errorFile<<"Lex succesfully returned token from whole file "<<endl;
		return 0;
	}
		

%%

