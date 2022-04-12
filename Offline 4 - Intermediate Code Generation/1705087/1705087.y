%{
#ifndef SYMTABLE
#define SYMTABLE
#include "1705087_Syn_Engine.h"
#include "1705087_AHM_Engine.h"
#endif // SYMTABLE

%}


%union{
symbolInfo* symbData;
}

%token IF SWITCH  CASE DEFAULT ELSE  FOR DO WHILE RETURN BREAK CONTINUE

%token INCOP DECOP ASSIGNOP NOT SHIFTOP

%token LPAREN RPAREN LCURL RCURL LTHIRD RTHIRD COMMA SEMICOLON

%token PRINTLN STRING COMMENT

%token VOID INT DOUBLE CHAR FLOAT

%token <symbData>ID CONST_INT CONST_FLOAT CONST_CHAR ADDOP MULOP LOGICOP RELOP BITOP

%type <symbData>type_specifier expression logic_expression rel_expression simple_expression term unary_expression 

%type <symbData>factor variable declaration_list statement statements program unit func_declaration func_definition

%type <symbData>parameter_list compound_statement var_declaration expression_statement argument_list arguments

%type <symbData>invalid_condition 

%nonassoc lower_else
%nonassoc ELSE


%%



start: program
		{
				logWriteRule("start","program");
				logWrite($1->getName());
				
				string codeALL =";1705087-Fahmid\n"+$1->getCode();
				
				if(error_count==0)
				{
					if(syntaxErrors==0)
					{
						writeAllCode(codeALL);
					}
				}
				
		}
	;

program: program unit
		{
				logWriteRule("program","program unit");
				logWrite($1->getName()+" "+$2->getName()+"\n");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"\n");
			        
			        $$->setCode( $1->getCode()+$2->getCode()+"\n");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
		}
	| unit
		{
				logWriteRule("program","unit");
				logWrite($1->getName()+"\n");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+"\n");
			        
			        $$->setCode( $1->getCode()+"\n");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
		}
	;

unit: var_declaration
		{
				logWriteRule("unit","var_declaration");
				logWrite($1->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        
			        $$->setCode( $1->getCode()+"\n");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
		}
     | func_declaration
		{
				logWriteRule("unit","func_declaration");
				logWrite($1->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        
			        $$->setCode( $1->getCode()+"\n");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
		}
     | func_definition
		{
				logWriteRule("unit","func_definition");
				logWrite($1->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        
			        $$->setCode( $1->getCode()+"\n");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
		}
     ;

func_declaration: type_specifier ID LPAREN  parameter_list RPAREN SEMICOLON
			{
				peremeter = $4->getName();
				insertFunEarly($1->getName(),$2->getName(),$4->getName(),0);
			

				logWriteRule("func_declaration","type_specifier ID LPAREN parameter_list RPAREN SEMICOLON");
				logWrite($1->getName()+" "+$2->getName()+"("+$4->getName()+")"+";");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"("+$4->getName()+")"+";");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			}
		| type_specifier ID LPAREN  RPAREN SEMICOLON
			{
				
				insertFunEarly($1->getName(),$2->getName(),"",0);

				logWriteRule("func_declaration","type_specifier ID LPAREN RPAREN SEMICOLON");
				logWrite($1->getName()+" "+$2->getName()+"("+")"+";");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"("+")"+";");
			        
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			}
		|type_specifier ID LPAREN parameter_list RPAREN error {
			

			printError("missing semicolon in func_declaration");
			logWriteRule("func_declaration","type_specifier ID LPAREN parameter_list RPAREN error");
			logWrite($1->getName()+" "+$2->getName()+"("+$4->getName()+")");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"("+$4->getName()+")");
			        
			}
		|type_specifier ID LPAREN RPAREN error{
		
			
			printError("missing semicolon after func_declaration");
			logWriteRule("func_declaration","type_specifier ID LPAREN RPAREN error");
			logWrite($1->getName()+" "+$2->getName()+"("+")");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"("+")");
			}
		;

func_definition: type_specifier ID LPAREN parameter_list RPAREN{
							
			
			flagFun = true ;
			func_current = $2->getName(); 
			//cout<<func_current<<endl;
			peremeter = $4->getName();
										
			insertFunEarly($1->getName(),$2->getName(),$4->getName(),404);
							
			} compound_statement
			{
			
				logWriteRule("func_definition","type_specifier ID LPAREN parameter_list RPAREN compound_statement");
				logWrite($1->getName()+" "+$2->getName()+"("+$4->getName()+") \n"+$7->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"("+$4->getName()+") \n"+$7->getName());
			        
			        $$->setCode( funcDefASM($2->getName(),$7->getCode())+"\n");
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			        
			}
			| type_specifier ID LPAREN RPAREN {
				
				
				flagFun = true ;
				func_current = $2->getName(); 
				//cout<<func_current<<endl;				
				insertFunEarly($1->getName(),$2->getName(),"",404);
				
				} compound_statement
			{
				
				logWriteRule("func_definition","type_specifier ID LPAREN RPAREN compound_statement");
				logWrite($1->getName()+" "+$2->getName()+"() \n"+$6->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"() \n"+$6->getName());
			        
			        $$->setCode( funcDefASM($2->getName(),$6->getCode())+"\n");
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			        
			}
 		;


parameter_list: parameter_list COMMA type_specifier ID
			{
					variable_type = $3->getName(); 
					//insertVarEarly($4->getName(),$4->getType());
					
					logWriteRule("parameter_list","parameter_list COMMA type_specifier ID");
					logWrite($1->getName()+" , "+$3->getName()+" "+$4->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName()+" , "+$3->getName()+" "+$4->getName());
			        	
			        	//dataCode += $4->getName()+func_current+" dw ? \n";
			        	
			        	
			}
		| parameter_list COMMA type_specifier
			{
					logWriteRule("statements","parameter_list COMMA type_specifier");
					logWrite($1->getName()+" , "+$3->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName()+" , "+$3->getName());
			}
 		| type_specifier ID
			{
					//insertVarEarly($2->getName(),$2->getType());

					logWriteRule("parameter_list","type_specifier ID");
					logWrite($1->getName()+" "+$2->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName()+" "+$2->getName());
			        	
			        	//dataCode += $2->getName()+func_current+" dw ? \n";
			}
		| type_specifier
			{

					logWriteRule("parameter_list","type_specifier");
					logWrite($1->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName());
			}
		| parameter_list COMMA error ID {

					printError("missing type in parameter_list");
					logWriteRule("statement","parameter_list COMMA error ID");
					logWrite($1->getName()+" , "+ERROR_VALUE+$4->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName()+" , "+ERROR_VALUE+$4->getName());
			}
		| error ID{
		   	
			   		printError("missing type in parameter");
					logWriteRule("parameter_list","error ID");
					logWrite(ERROR_VALUE+(string)" "+$2->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName(ERROR_VALUE+(string)" "+$2->getName());
				
			}
		;


compound_statement: LCURL {
				enterScope();
				if(flagFun == false)
				{
				//printError("peremeter not funtion ");
				//insertVarEarly($2->getName(),$2->getType());
				}
				else
				{
				//printError("peremeter funtion "+peremeter);
				flagFun=false;
				
				string s1 = "";
				
			    	for(int i=0;i<peremeter.length();i++)
				{
					if(peremeter[i]!=',')
					{
					s1=s1+peremeter[i];				
					}
					else
					s1=s1+" "+peremeter[i]+" ";
				}
			 	peremeter=s1;	
				
				istringstream ss(peremeter);
  
				string word , word1 ; 
				  
				if(peremeter!="")
				{
					while (ss >> word && ss >> word1) 
					{
						if(!word.compare(","))
						{
							word = word1;
							ss>>word1;
						}
						variable_type = word ;
						dataCode += word1+func_current+" dw ? \n";
						insertVarEarly(word1,"ID");
					
					}
					peremeter="";
				}
				
				}
			}
			statements RCURL
			{
			   	      
					logWriteRule("compound_statement","LCURL statements RCURL");
					
					logWrite("{\n"+$3->getName()+"}");
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName("{\n"+$3->getName()+"}");
			        	//cout<<$$->getName()<<endl;
			        	
			        	$$->setCode( $3->getCode()+"\n");
			        	
			        	if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getCode());
					}
			        	
			        	 //cout<<$3->getCode()<<endl;

					exitScope();
			}
 		  | LCURL {
 		  		enterScope();
				if(flagFun == false)
				{
				//printError("peremeter not funtion ");
				//insertVarEarly($2->getName(),$2->getType());
				}
				else
				{
				//printError("peremeter funtion "+peremeter);
				flagFun=false;
				
				string s1 = "";
				
			    	for(int i=0;i<peremeter.length();i++)
				{
					if(peremeter[i]!=',')
					s1=s1+peremeter[i];
					else
					s1=s1+" "+peremeter[i]+" ";
				}
			 	peremeter=s1;
				
				
				istringstream ss(peremeter);
  
				string word , word1 ; 
				
				if(peremeter!="")
				{
					while (ss >> word && ss >> word1) 
					{
						if(!word.compare(","))
						{
							word = word1;
							ss>>word1;
						}
						variable_type = word ;
						dataCode += word1+func_current+" dw ? \n";
						insertVarEarly(word1,"ID");
					
					}
					peremeter="";
				}
				
				
				}
 		  	} RCURL
			{
			   
					logWriteRule("compound_statement","LCURL RCURL");
					logWrite("{}");
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName("{}");

					exitScope();
			}
 		  ;

var_declaration: type_specifier declaration_list SEMICOLON
 			{

					logWriteRule("var_declaration","type_specifier declaration_list SEMICOLON");
					logWrite($1->getName()+" "+$2->getName()+";");
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName()+" "+$2->getName()+";");

			}
			|type_specifier declaration_list error{

					printError("missing semicolon after var_declaration");
					logWriteRule("var_declaration","type_specifier declaration_list error");
					logWrite($1->getName()+" "+$2->getName());
	   	
	   				$$ = new symbolInfo("","");
			        	$$->setName($1->getName()+" "+$2->getName());

				
				}
		 ;

type_specifier: INT
			{

				logWriteRule("type_specifier","INT");
				logWrite("int");
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName("int");
			        
			        variable_type = "int" ;
				
			}
 		| FLOAT
			{

				logWriteRule("type_specifier","FLOAT");
				logWrite("float");
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName("float");
			        
			        variable_type = "float" ;
			}
 		| VOID
			{

				logWriteRule("type_specifier","VOID");
				logWrite("void");
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName("void");
			        
			        variable_type = "void" ;
			}
 		;

declaration_list: declaration_list COMMA ID
			{
				
				insertVarEarly($3->getName(),$3->getType());
		   	
		   	       logWriteRule("declaration_list","declaration_list"); 
		   	       logWrite($1->getName()+" , "+$3->getName());
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" , "+$3->getName());
			        
			        dataCode += $3->getName()+func_current+" dw ? \n";
			        
			}
 		  | declaration_list COMMA ID LTHIRD CONST_INT RTHIRD
			{
				
				insertArrayEarly($3->getName(),$3->getType(),$5->getName());

				logWriteRule("declaration_list","declaration_list COMMA ID LTHIRD CONST_INT RTHIRD");
				logWrite($1->getName()+" , "+$3->getName()+"["+$5->getName()+"]");
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" , "+$3->getName()+"["+$5->getName()+"]");
			        
			        dataCode += $3->getName()+" dw "+$5->getName()+" dup(?) \n";
			}
 		  | ID
			{
			
				insertVarEarly($1->getName(),$1->getType());
			
				logWriteRule("declaration_list","ID");
				logWrite($1->getName());
				
				$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        
			        dataCode += $1->getName()+func_current+" dw ? \n";
				
			}
 		  | ID LTHIRD CONST_INT RTHIRD
			{
				insertArrayEarly($1->getName(),$1->getType(),$3->getName());

				logWriteRule("declaration_list","ID LTHIRD CONST_INT RTHIRD");
				logWrite($1->getName()+"["+$3->getName()+"]");
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName($1->getName()+"["+$3->getName()+"]");
			        
			        dataCode += $1->getName()+" dw "+$3->getName()+" dup(?) \n";

			}
		| ID LTHIRD error RTHIRD{

					printError("missing integer index in array declaration ");
					logWriteRule("declaration_list","ID LTHIRD error RTHIRD");
					logWrite($1->getName()+"["+"error value"+"]");
		   	
		   			$$ = new symbolInfo("","");
			                $$->setName($1->getName()+"["+"error value"+"]");
			}
		| declaration_list COMMA ID LTHIRD error RTHIRD	{

					printError("missing integer index in array declaration ");
					logWriteRule("declaration_list","declaration_list COMMA ID LTHIRD error");
					logWrite($1->getName()+","+$3->getName()+"["+ERROR_VALUE+"]");
		   	
		   			$$ = new symbolInfo("","");
			                $$->setName($1->getName()+","+$3->getName()+"["+ERROR_VALUE+"]");
					
			}
 		  ;

statements: statement
			{
				
				logWriteRule("statements","statement");
			        logWrite($1->getName()+"\n");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+"\n");
			        
			        $$->setCode ($1->getCode() +"\n");
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			}
	   | statements statement {
		   	
				logWriteRule("statements","statement");
			        logWrite($1->getName()+" "+$2->getName()+"\n");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName()+" "+$2->getName()+"\n");
			        
			        $$->setCode( $1->getCode()+$2->getCode()+"\n");
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
		 	}
	   ;

statement: var_declaration
			{
			
				logWriteRule("statement","var_declaration");
				logWrite($1->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			}
	  | expression_statement
			{
			
				logWriteRule("statement","expression_statement");
				logWrite($1->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        
			        $$->setCode( $1->getCode()+"\n");
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			        
			       // cout<<$1->getCode()<<endl;
			        
			        
			}
	  | compound_statement
			{
				
				logWriteRule("statement","compound_statement");
				logWrite($1->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        
			        $$->setCode( $1->getCode()+"\n");
			        if(DEBUGL)
			        {
			        	logWrite((string)"debug asm : \n"+$$->getCode());
			        }
			        
			        //cout<<$1->getCode()<<endl;
			        
			        
			}
	  | FOR LPAREN expression_statement expression_statement expression RPAREN statement
			{
			
				logWriteRule("statement","FOR LPAREN expression_statement expression_statement expression RPAREN statement");
				logWrite((string)"for("+$3->getName()+$4->getName()+$5->getName()+(string)")"+$7->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"for("+$3->getName()+$4->getName()+$5->getName()+(string)")"+$7->getName());
			        
			        string label=newLabel();
			        string label2=newLabel();
			        
			        string temp =(string)"; line no : "+toString(line_count)+(string)" rule : for \n"
			        +$3->getCode()
			        +(string)label2+(string)":\n" 
			        +$4->getCode()+
			        (string)"mov ax , "+$4->getAVAR()+(string)"\n"+
				(string)"cmp ax , 0\n"+
				(string)"je "+(string)label+(string)"\n"+
				$7->getCode()+$5->getCode()+
				(string)"jmp "+(string)label2+(string)"\n"+
				(string)label+(string)":\n" ;
				
				$$->setCode(temp);
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"for asm :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
			}
	  | IF LPAREN expression RPAREN statement %prec lower_else

			{
			
				logWriteRule("statement","IF LPAREN expression RPAREN statement");
				logWrite((string)"if("+$3->getName()+(string)")"+$5->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"if("+$3->getName()+(string)")"+$5->getName());
			        
			        
			        string label=newLabel();
			        
			        string temp =(string)"; line no : "+toString(line_count)+(string)" rule : if  \n"
			        +$3->getCode()
			        +(string)"mov ax, "+$3->getAVAR()+(string)"\n"+
				(string)"cmp ax , 0\n"+
				(string)"je "+(string)label+(string)"\n"+
				$5->getCode()+
				(string)label+(string)":\n";
				
				$$->setCode(temp);
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"if asm :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
				
			}
	  | IF LPAREN expression RPAREN statement ELSE statement
			{
				
				logWriteRule("statement","IF LPAREN expression RPAREN statement ELSE statement");
				logWrite((string)"if("+$3->getName()+(string)")"+$5->getName()+(string)"else"+$7->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"if("+$3->getName()+(string)")"+$5->getName()+(string)"else"+$7->getName());
			        
			        string label=newLabel();
			        string label2=newLabel();
			        
			        string temp =(string)"; line no : "+toString(line_count)+(string)" rule : if-else \n"
			        +$3->getCode()
			        +(string)"mov ax , "+$3->getAVAR()+(string)"\n"+
				(string)"cmp ax , 0\n"+
				(string)"je "+(string)label+(string)"\n"+
				$5->getCode()+
				(string)"je "+(string)label2+(string)"\n"+
				(string)label+(string)":\n"+
				$7->getCode() +
				(string)label2+(string)":\n";
				
				$$->setCode(temp);
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"if else asm :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
				
			}
	  | WHILE LPAREN expression RPAREN statement
			{
				
				logWriteRule("statement","WHILE LPAREN expression RPAREN statement");
				logWrite((string)"while("+$3->getName()+(string)")"+$5->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"while("+$3->getName()+(string)")"+$5->getName());
			        
			        string label=newLabel();
			        string label2=newLabel();
			        
			        string temp =(string)"; line no : "+toString(line_count)+(string)" rule : while \n"
			        +(string)label2+(string)":\n" +$3->getCode()+
			        (string)"mov ax , "+$3->getAVAR()+(string)"\n"+
				(string)"cmp ax , 0\n"+
				(string)"je "+(string)label+(string)"\n"+
				$5->getCode()+
				(string)"jmp "+(string)label2+(string)"\n"+
				(string)label+(string)":\n" ;
				
				$$->setCode(temp);
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"while asm :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
			}
	  | PRINTLN LPAREN ID RPAREN SEMICOLON
			{
				
				logWriteRule("statement","PRINTLN LPAREN ID RPAREN SEMICOLON");
				logWrite((string)"printf("+$3->getName()+(string)")"+(string)";");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"printf("+$3->getName()+(string)")"+(string)";");
			        
			        string temp =(string)"; line no : "+toString(line_count)+(string)" rule : print \n"
			        +(string)"mov bx , "+$3->getName()+func_current+(string)"\n"
			        +(string)"call hexToDec \n"
			        +(string)"mov ah , 2 \n"
			        +(string)"mov dx , 10\n"
			        +(string)"int 21h \n\n"
			        +(string)"mov ah , 2 \n"
			        +(string)"mov dx , 13\n"
			        +(string)"int 21h \n";

			        
			        $$->setCode(temp);
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"print asm :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
			}
	   | RETURN expression SEMICOLON
	   		{
				
				//
				if(return_type!="NULL" &&(return_type!=$2->getreturnType()) )
				{
					printError("Wrong return type of the funtion");
					return_type="NULL";
				}
			
				logWriteRule("statement","RETURN expression SEMICOLON");
				logWrite("return"+$2->getName()+";");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName("return"+$2->getName()+";");
			        
			        string return_type="NULL";
			        
			        string temp =(string)"; line no : "+toString(line_count)+(string)" rule : print \n"
			        +$2->getCode()
			        +(string)"mov cx , "+$2->getAVAR()+(string)"\n"
			        +(string)"jmp "+func_current+(string)"label \n";
			        
			        $$->setCode(temp);
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"return :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
			}
  	   | RETURN expression error
  	       {
			
				logWriteRule("statement","RETURN expression error");
				logWrite((string)"return"+$2->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"return"+$2->getName());
		}
	    | PRINTLN LPAREN ID RPAREN error
	    {
	    			printError("missing semicolon after print function ");
				logWriteRule("statement","PRINTLN LPAREN ID RPAREN error");
				logWrite((string)"printf("+$3->getName()+(string)")");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"printf("+$3->getName()+(string)")");
				
	    }
	    | error ELSE statement{
		
				printError("proper syntax not maintained before else as else without if ");
				logWriteRule("statement","error ELSE statement");
				logWrite(ERROR_VALUE+(string)" else "+$3->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName(ERROR_VALUE+(string)" else"+$3->getName());
		}
	    | IF invalid_condition statement %prec lower_else
	        {
			
				printError("proper syntax not maintained in if else ");
				logWriteRule("statement","IF LPAREN error RPAREN statement");
				logWrite("if"+$2->getName()+$3->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName("if"+$2->getName()+$3->getName());
		}
	    | IF invalid_condition statement ELSE statement{
			
				printError("proper syntax not maintained in if else ");
				logWriteRule("statement","IF LPAREN error RPAREN statement ELSE statement");
				logWrite((string)"if"+$2->getName()+$3->getName()+(string)"else"+$5->getName());
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"if"+$2->getName()+$3->getName()+(string)"else"+$5->getName());
		}
	  
	  ;
	  
invalid_condition: LPAREN error RPAREN 
				{ 
				
				printError("proper syntax not maintained inside condition");
				logWriteRule("invalid_condition","LPAREN error RPAREN");
				logWrite((string)"("+ERROR_VALUE+(string)")");
	   	
	   			$$ = new symbolInfo("","");
			        $$->setName((string)"("+ERROR_VALUE+(string)")");
				};

expression_statement: SEMICOLON
				{
				
					logWriteRule("expression_statement","SEMICOLON");
					logWrite(";");
	   	
		   			$$ = new symbolInfo("","");
					$$->setName(";");
				}
			| expression SEMICOLON {
					
					logWriteRule("expression_statement","expression SEMICOLON");
					logWrite($1->getName()+";");
	   	
		   			$$ = new symbolInfo("","");
					$$->setName($1->getName()+";");
					
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR()) ;
					// cout<<$1->getCode()<<endl;
					if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getCode());
					}
				}
			| expression error {
			
					printError("missing seniclon after expression");
					logWriteRule("expression_statement","expression error");
					logWrite($1->getName()+ERROR_VALUE);
	   	
		   			$$ = new symbolInfo("","");
					$$->setName($1->getName()+ERROR_VALUE);
			}
			;

variable: ID
			{
				
				symbolInfo* temp = table->lookupAllScope($1->getName());
				string ret = "";
				
				if (temp == nullptr ) 
				{
					printError($1->getName() + " doesn't exist or declared before");
				} 
				else if (temp->getidType()!="Variable")
				{
				if (temp->getidType()=="Array")
				{
					printError($1->getName() + " is an array without an index");
				}
				else 
				{
					printError($1->getName() + " is not a variable ");
				}
				 
				 	//printError("Oh no "+ret );
				 	
				}
				
				if(temp != nullptr)
				{
					ret = temp->getreturnType();
				}
				
			
				logWriteRule("variable","ID");
				logWrite($1->getName());
				
				$$ = new symbolInfo("","");
			        $$->setName($1->getName());
			        $$->setreturnType(ret);
			        //printError($1->getName()+" Oh no "+$$->getreturnType() );
			        
			        $$->setAVAR($1->getName()+func_current) ;
			        
				 	
			       
				
			}
	 | ID LTHIRD expression RTHIRD
	 		{
			
				
				string ret = "";
				
				symbolInfo* temp = table->current->searchHashAddress($1->getName());
				
				if (temp == nullptr ) 
				{
					printError("Array "+ $1->getName() + " doesn't exist or declared before");
				} 
				else if (temp->getidType()!="Array")
				{
					printError($1->getName() + " is not declared as a array");
				}
				else if ($3->getreturnType()!="int")
				{
					printError($1->getName() + " index must be integer ");
				}
				else if (temp->getarrayIndex()<stoi($3->getName()))
				{
					printError( " index is out of range ");
				}
				else
				{
				 	ret = temp->getreturnType();
				 	
				}
				

			
				logWriteRule("variable","ID LTHIRD expression RTHIRD");
				logWrite($1->getName()+(string)"["+$3->getName()+(string)(string)"]");
		   	
		   		$$ = new symbolInfo("","");
			        $$->setName($1->getName()+(string)"["+$3->getName()+(string)"]");
			        $$->setreturnType($1->getreturnType());
			        $$->setreturnType(ret);
			        
			        
			        string tempS =(string)"; line no : "+toString(line_count)+(string)" rule : array index \n"
			        +$3->getCode()
			        +(string)"mov bx, "+$3->getAVAR() +(string)"\n"
			        +"add bx, bx\n";
			        
				$$->setAVAR($1->getName()) ;
				$$->setCode(tempS);
				
				
				
					
			        if(DEBUGL)
			        {
			        	logWrite((string)"array index asm :"+$$->getCode());
			        	asmWrite($$->getCode());
			        }
			}
	 ;

expression: logic_expression
				{

					
					logWriteRule("expression","logic_expression");
					logWrite($1->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName());
					$$->setreturnType($1->getreturnType());
					
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR());
					if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getAVAR());
					}
					
					// cout<<$1->getCode()<<endl;
				}
	   | variable ASSIGNOP logic_expression
		 		{
					
					if ($1->getreturnType() == "void" || $3->getreturnType() == "void")
					{
						printError("Assign Operation on void type");
					}
					else if ($1->getreturnType()=="int" && $3->getreturnType() !="int")
					{
						printError(" Assigning non integer value");
						$$->setreturnType("int");
					}
					else if ($1->getreturnType()=="float"&& $3->getreturnType() !="float")
					{
						printError("Warning Assigning non float value");
						syntaxErrors--;
						$$->setreturnType("float");
					}
					else
					{
						 $$->setreturnType($1->getreturnType());
					}

					logWriteRule("expression","variable ASSIGNOP logic_expression");
					logWrite($1->getName()+(string)"="+$3->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName()+(string)"="+$3->getName());
					
					string temp ="";
					
					symbolInfo* tempSym = table->lookupAllScope($1->getName());
					
					//cout<<$1->getName()<<endl;
					
					if(tempSym == nullptr || tempSym->getidType() =="Array")
					{
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : array assain \n"
						+$3->getCode()+$1->getCode()
						+(string)"mov ax , "+$3->getAVAR()+(string)"\n"
						+(string)"mov "+$1->getAVAR()+(string)"[bx] , ax \n";
					}
					else
					{
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : assain \n"
						+$3->getCode()+$1->getCode()
						+(string)"mov ax , "+$3->getAVAR()+(string)"\n"
						+(string)"mov "+$1->getAVAR()+(string)" , ax \n";
					}
					
					
					$$->setCode(temp);
					$$->setAVAR($1->getAVAR());
						
					if(DEBUGL)
					{
						logWrite((string)"assain asm :"+$$->getCode());
						asmWrite($$->getCode());
					}
					
					
					
				}
	   ;

logic_expression: rel_expression
				{
					
					logWriteRule("logic_expression","rel_expression");
					logWrite($1->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName());
					$$->setreturnType($1->getreturnType());
					
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR());
					if(DEBUGL)
					{
						logWrite((string)"assain logi :"+$$->getAVAR());
						asmWrite($$->getCode());
					}
				}
		 | rel_expression LOGICOP rel_expression
		 		{
		 		
		 			if ($1->getreturnType() == "void" || $3->getreturnType() == "void")
					{
						printError("Assign Operation on void type");
					}
					
					if ($1->getvarType() != $3->getvarType()) 
					{
					 	printError("Comparision between two different types not allowed");
					}
					
					
					logWriteRule("logic_expression","rel_expression LOGICOP rel_expression");
					logWrite($1->getName()+" "+$2->getName()+" "+$3->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName()+" "+$2->getName()+" "+$3->getName());
					$$->setreturnType($1->getreturnType());
					
					string labelEnd = newLabel();
					string labelFalse = newLabel();
					string tc = newTemp();
					string temp ="";
					
					
					if ($2->getName() == "&&") {
					
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : logi AND \n"
						+$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+(string)"cmp ax , 0\n"
						+(string)"je "+(string)labelFalse+(string)"\n"
						+(string)"mov ax , "+$3->getAVAR()+(string)"\n"
						+(string)"cmp ax , 0\n"
						+(string)"je "+(string)labelFalse+(string)"\n"
						+(string)"mov "+tc+(string)" , 1 \n"
						+(string)"jmp "+(string)labelEnd+(string)"\n"
						+(string)labelFalse+(string)":\n"
						+(string)"mov "+tc+(string)" , 0 \n" 
						+(string)labelEnd+(string)":\n";
						
					
						
					
					}
					else if ($2->getName() == "||"){
					
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : logi OR \n"
						+$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+(string)"cmp ax , 0\n"
						+(string)"jne "+(string)labelFalse+(string)"\n"
						+(string)"mov ax , "+$3->getAVAR()+(string)"\n"
						+(string)"cmp ax , 0\n"
						+(string)"jne "+(string)labelFalse+(string)"\n"
						+(string)"mov "+tc+(string)" , 0 \n"
						+(string)"jmp "+(string)labelEnd+(string)"\n"
						+(string)labelFalse+(string)":\n"
						+(string)"mov "+tc+(string)" , 1 \n" 
						+(string)labelEnd+(string)":\n";
					
					}
					
					
					$$->setCode(temp);
					$$->setAVAR(tc);
						
					if(DEBUGL)
					{
						logWrite((string)"assain logi :"+$$->getCode());
						asmWrite($$->getCode());
					}
				}
		 ;

rel_expression: simple_expression
			{
					logWriteRule("rel_expression","simple_expression");
					logWrite($1->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName());
					$$->setreturnType($1->getreturnType());
					
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR());
					
					if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getAVAR());
					}
			}
		| simple_expression RELOP simple_expression
				{
					
					if ($1->getreturnType() == "void" || $3->getreturnType() == "void")
					{
						printError("Relational Operation on void type");
					}
					
					if ($1->getvarType() != $3->getvarType()) 
					{
					 	printError("Comparision between two different types not allowed");
					}

					logWriteRule("rel_expression","simple_expression RELOP simple_expression");
					logWrite($1->getName()+" "+$2->getName()+(string)" "+$3->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName()+" "+$2->getName()+(string)" "+$3->getName());
					$$->setreturnType($1->getreturnType());
					
					string labelEnd = newLabel();
					string labelTrue = newLabel();
					string tc = newTemp();
					string tempRel ="";
					string temp ="";
					
					if ($2->getName() == "<") {
						tempRel = "jl ";
					} else if ($2->getName() == "==") {
						tempRel = "jle ";
					} else if ($2->getName() == "!=") {
						tempRel = "jne ";
					} else if ($2->getName() == ">") {
						tempRel = "jg ";
					} else if ($2->getName() == ">=") {
						tempRel = "jge ";
					} else if ($2->getName() == "<=") {
						tempRel = "jle ";
					}
					
					temp =(string)"; line no : "+toString(line_count)+(string)" rule : rel op \n"
					        +$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+(string)"mov bx , "+$3->getAVAR()+(string)"\n"
						+(string)"cmp ax , bx\n"
						+tempRel+(string)labelTrue+(string)"\n"
						+(string)"mov "+tc+(string)" , 0 \n"
						+(string)"jmp "+(string)labelEnd+(string)"\n"
						+(string)labelTrue+(string)":\n"
						+(string)"mov "+tc+(string)" , 1 \n" 
						+(string)labelEnd+(string)":\n";
						
					$$->setCode(temp);
					$$->setAVAR(tc);
						
					if(DEBUGL)
					{
						logWrite((string)"rel op asm :"+$$->getCode());
						asmWrite($$->getCode());
						 
					} 
				}
		;

simple_expression: term
				{
					logWriteRule("simple_expression","term");
					logWrite($1->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName());
					$$->setreturnType($1->getreturnType());
					
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR());
					if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getAVAR());
					}
				}
		  | simple_expression ADDOP term
				{
				
				
				
					if ($1->getreturnType() == "void" || $3->getreturnType() == "void")
					{
						printError("Add Operation on void type");
					}
					
					

					logWriteRule("simple_expression","simple_expression ADDOP term");
					logWrite($1->getName()+(string)" "+$2->getName()+(string)" "+$3->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName()+(string)" "+$2->getName()+(string)" "+$3->getName());
					$$->setreturnType($1->getreturnType());
					
					string tc = newTemp();
					string temp ="";
					string tempOP ="";
					
					if ($2->getName() == "+") {
						tempOP = "add";
					} else if ($2->getName() == "-") {
						tempOP = "sub ";
					} 
					
					temp =(string)"; line no : "+toString(line_count)+(string)" rule : add sub op \n"
						+$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+(string)"mov bx , "+$3->getAVAR()+(string)"\n"
						+tempOP+(string)" ax , bx\n"
						+(string)"mov "+tc+(string)" , ax \n";
					
					$$->setCode(temp);
					$$->setAVAR(tc);
						
					if(DEBUGL)
					{
						logWrite((string)"add sub op asm :"+$$->getCode());
						asmWrite($$->getCode());
					} 
				
					
				}
		  ;

term:	unary_expression
				{
					logWriteRule("term","unary_expression");
					logWrite($1->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName());
					$$->setreturnType($1->getreturnType());
					
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR());
					
					if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getAVAR());
					}
					
					
				}
     | term MULOP unary_expression
		 		{
				
				
					if ($1->getreturnType() == "void" || $3->getreturnType() == "void")
					{
						printError("Relational Operation on void type");
					}
					
					if($2->getName() == "%")
					{
						if (!($1->getreturnType() == "int" && $3->getreturnType() == "int"))
						{
							//printError("Meu "+(string)$1->getreturnType()+"Both operand of Modulus operator must be int "+(string)$3->getreturnType());
							printError("Both operand of Modulus operator must be int ");
						}
						if($3->getName() == "0")
						{
							printError("Seocond operand of modulus operator can't be zero ");
						}
					}
		

					logWriteRule("term","term MULOP unary_expression");
					logWrite($1->getName()+(string)" "+$2->getName()+" "+$3->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName()+(string)" "+$2->getName()+" "+$3->getName());
					$$->setreturnType($1->getreturnType());
					
					string tc = newTemp();
					string temp ="";
					string tempOP ="";
					
					if ($2->getName() == "*") {
						tempOP = "mul";
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : mul op \n"
						+$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+(string)"mov bx , "+$3->getAVAR()+(string)"\n"
						+tempOP+(string)" bx\n"
						+(string)"mov "+tc+(string)" , ax \n";
					} else if ($2->getName() == "/") {
						tempOP = "div ";
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : div op \n"
						+$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+tempOP+$3->getAVAR()+(string)"\n"
						+(string)"mov "+tc+(string)" , ax \n";
					} 
					else if ($2->getName() == "%") {
						tempOP = "div ";
						temp =(string)"; line no : "+toString(line_count)+(string)" rule : reminder op \n"
						+$1->getCode()+$3->getCode()
						+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
						+tempOP+$3->getAVAR()+(string)"\n"
						+(string)"mov "+tc+(string)" , dx \n";
					} 
					
					
					$$->setCode(temp);
					$$->setAVAR(tc);
						
					if(DEBUGL)
					{
						logWrite((string)"mul div rim asm :"+$$->getCode());
						asmWrite($$->getCode());
					} 
				}
     ;

unary_expression: ADDOP unary_expression
				{

					
					if ($2->getreturnType() == "void")
					{
						printError("Unaray Operation on void type");
					}


					logWriteRule("unary_expression","ADDOP unary_expression");
					logWrite($1->getName()+(string)" "+$2->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName()+(string)" "+$2->getName());
					$$->setreturnType($2->getreturnType());
					
					
					if ($1->getName() == "+") {
						
						$$->setAVAR($2->getAVAR());
							
						if(DEBUGL)
						{
							logWrite((string)"unary add op asm :"+$$->getCode());
							asmWrite($$->getCode());
						} 
					} else if ($1->getName() == "-") {
					
						string tc = newTemp();
						
						string temp =(string)"; line no : "+toString(line_count)+(string)" rule : unary sub op \n"
						+$2->getCode()
						+(string)"mov ax , "+$2->getAVAR()+(string)"\n"
						+(string)"not ax \n"
						+(string)"add ax , 00000001B \n"
						+(string)"mov "+tc+(string)" , ax \n";
					
						$$->setCode(temp);
						$$->setAVAR(tc);
							
						if(DEBUGL)
						{
							logWrite((string)"unary sub op asm :"+$$->getCode());
							asmWrite($$->getCode());
						} 
					} 
					
					
				}
		 | NOT unary_expression
		 		{
				
					
					if ($2->getreturnType() == "void")
					{
						printError("Unaray Operation on void type");
					}

					logWriteRule("unary_expression","NOT unary_expression");
					logWrite((string)"!"+(string)" "+$2->getName());
				
					$$ = new symbolInfo("","");
					$$->setName((string)"!"+(string)" "+$2->getName());
					$$->setreturnType($2->getreturnType());
					
					string tc = newTemp();
						
					string temp =(string)"; line no : "+toString(line_count)+(string)" rule : unary not op \n"
					+$2->getCode()
					+(string)"mov ax , "+$2->getAVAR()+(string)"\n"
					+(string)"not ax \n"
					+(string)"mov "+tc+(string)" , ax \n";
				
					$$->setCode(temp);
					$$->setAVAR(tc);
						
					if(DEBUGL)
					{
						logWrite((string)"unary not asm :"+$$->getCode());
						asmWrite($$->getCode());
					} 
				}
		 | factor
		 		{

					logWriteRule("unary_expression","factor");
					logWrite($1->getName());
				
					$$ = new symbolInfo("","");
					$$->setName($1->getName());
					$$->setreturnType($1->getreturnType());
					
					//printError($1->getName()+" "+$1->getreturnType() + " meu meu");
					$$->setCode( $1->getCode()+"\n");
					$$->setAVAR($1->getAVAR());
					
					if(DEBUGL)
					{
						logWrite((string)"debug asm : \n"+$$->getAVAR());
					}
							
				}
		 ;

factor: variable
		{
			
			logWriteRule("factor","variable");
			logWrite($1->getName());
				
			$$ = new symbolInfo("","");
			$$->setName($1->getName());
			$$->setreturnType($1->getreturnType());
			
			//cout<<$$->getName()<<endl;
			
			symbolInfo* tempSym = table->lookupAllScope($1->getName());
				
				
				
			if(tempSym == nullptr || tempSym->getidType() =="Array")
			{
				$$->setAVAR($1->getName());
				//cout<<$1->getName()<<endl;
				
				if(DEBUGL)
				{
					logWrite((string)"got array asm :"+$$->getCode());
					asmWrite($$->getCode());
				} 
			}
			else
			{
				$$->setAVAR($1->getAVAR());
				//cout<<$1->getAVAR()<<endl;
			}
			
			
			
		}
	| ID LPAREN argument_list RPAREN
		{   
			string ret ="";
			string codeTemp ="";
			
			if(table->lookupAllScope($1->getName())!= nullptr)
			{
			 	symbolInfo* temp = table->lookupAllScope($1->getName());	
			 	
		
			 	
			 	ret = temp->getreturnType();
			 	
			 	//printError(temp->getreturnType() + " meu ");
			 	
			 	
			 	int m = countCWord(temp->getparameterList());
				int n = countCWord($3->getName());
				int l=m-n;
				
				//cout<<m<<" "<<n<<" "<<l<<endl;
				
				//printError(temp->getparameterList());
				
				//printError($3->getName() );
			
				if(temp->getidType()!="Funtion")
				{
					printError(temp->getName() + " is not a function");
				}
				else if(!temp->getarrayIndex())
				{
					printError(temp->getName() + " does not have a body");
				}
				else if(m!=n)
				{
					printError("Parameter List quantity mismatch");
				}
				else 
				{
				    string aa = temp->getparameterList();
				    string bb = $3->getName();
				    
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
				 	bb=s1;	
				
				
				    istringstream ss(temp->getparameterList());
				    istringstream s2($3->getName());
				    
				   
  
				    string word , word1 , word2; 
				  
				    while (ss >> word && ss >> word1 && s2 >> word2) 
				    {
				    	if(1)
				    	{
				    		if(!word.compare(","))
				    		{
				    			word = word1;
				    			ss>>word1;
				    		}
				    		if(!word2.compare(","))
				    		{
				    			s2>>word2;
				    		}
				    	}
				    	 
				    //printError("Halum");
				    	
				    	codeTemp = codeTemp + "mov ax , " +word2+func_current+"\nmov "+word1+temp->getName()+" , ax \n";
				    	
				    	if(table->lookupAllScope(word2)!= nullptr)
				    	{
				    		
					    	symbolInfo* temp = table->lookupAllScope(word2);
					    	
					    	
					    	if(!isNumber(word2))
				    		{
					    	if(word.compare(temp->getreturnType())!=0 )
					    	{
					    		printError("peremeter \" "+word2 +" \" should be \" " +word +" \" type ");
					    	}
					    	}
					    	else if(word!="int")
					    	{
					    		printError("peremeter \" "+word2 +" \" should be int type ");
					    	}
					    	//printError("Halum");
					 
				    	}
				    	else
				    	{
				    		//printError("Halum");
				    		if(isNumber(word2))
				    		{
				    			if(word.compare("int")!=0)
				    			printError("peremeter \" "+word2 +" \" should be \" "+word +" \" type ");
				    		}
				    		else if(word.compare("float")!=0)
				    		{
				    			printError("peremeter \" "+word2 +" \" should be \" int \" type ");
				    		}
				    		//printError("Halum");
				    		
				    	}
				    	//printError("Halum");
				    
				    	
				    }
				}
			}
			else
			{
				printError("Function " + $1->getName() + " doesn't exist");
			}

			logWriteRule("factor","ID LPAREN argument_list RPAREN");
			logWrite($1->getName()+(string)"("+$3->getName()+(string)")");
				
			$$ = new symbolInfo("","");
			$$->setName($1->getName()+(string)"("+$3->getName()+(string)")");
			
			string tc=newTemp();
			string tempu = "mov "+tc+" , cx\n";
			
			$$->setCode( codeTemp+(string)"\ncall "+$1->getName()+"\n"+tempu);
			$$->setAVAR(tc);
			
			//$$->setCode($1->getCode()+$3->getCode());
			
			
			$$->setreturnType(ret);
			 //printError($$->getreturnType() + " meu ");
			 //printError($$->getName() + " meu ");
			 
			 if(DEBUGL)
			{
				logWrite((string)"debug asm : \n"+$$->getCode());
			}
			
		}
	| LPAREN expression RPAREN
		{

			logWriteRule("factor","LPAREN expression RPAREN");
			logWrite((string)"("+$2->getName()+(string)")");
				
			$$ = new symbolInfo("","");
			$$->setName((string)"("+$2->getName()+(string)")");
			$$->setreturnType($2->getreturnType());
			
			$$->setCode($2->getCode());
			$$->setAVAR($2->getAVAR());
			
			if(DEBUGL)
	        	{
			        	logWrite((string)"debug asm : \n"+$$->getCode());
		        }	
		}
	| CONST_INT
		{
			
			logWriteRule("factor","CONST_INT");
			logWrite($1->getName());
				
			$$ = new symbolInfo("","");
			$$->setName($1->getName());
			$$->setreturnType("int");
			
			string tc = newTemp();
				
			string temp =(string)"mov ax , "+$1->getName()+(string)"\n"
			+(string)"mov "+tc+(string)" , ax \n";
		
			$$->setCode(temp);
			$$->setAVAR(tc);
			
			if(DEBUGL)
			{
				logWrite((string)"const int asm :"+$$->getCode());
				asmWrite($$->getCode());
			} 
			
			
		}
	| CONST_FLOAT
		{	
			logWriteRule("factor","CONST_FLOAT");
			logWrite($1->getName());
				
			$$ = new symbolInfo("","");
			$$->setName($1->getName());
			$$->setreturnType("float");
			
			$$->setAVAR($1->getName());
			
			string tc = newTemp();
				
			string temp =(string)"mov ax , "+$1->getName()+(string)"\n"
			+(string)"mov "+tc+(string)" , ax \n";
		
			$$->setCode(temp);
			$$->setAVAR(tc);
			
			if(DEBUGL)
			{
				logWrite((string)"const float asm :"+$$->getCode());
				asmWrite($$->getCode());
			} 
		}
	| variable INCOP
		{
			logWriteRule("factor","variable INCOP");
			logWrite($1->getName()+"++");
				
			$$ = new symbolInfo("","");
			$$->setName($1->getName()+"++");
			$$->setreturnType($1->getreturnType());
			
			
			string temp ="";
			
			symbolInfo* tempSym = table->lookupAllScope($1->getName());
				
				
				
			if(tempSym == nullptr || tempSym->getidType() =="Array")
			{
				temp =(string)"; line no : "+toString(line_count)+(string)" rule : inc array op \n"
				+$1->getCode()
				+(string)"mov ax , "+$1->getAVAR()+(string)"[bx] \n"
				+(string)"inc ax\n"
				+(string)"mov "+$1->getAVAR()+(string)"[bx] , ax \n";
				$$->setAVAR($1->getAVAR());
			}
			else
			{
				string tc = newTemp();
				temp =(string)"; line no : "+toString(line_count)+(string)" rule : inc op \n"
				+$1->getCode()
				+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
				+(string)"mov "+tc+(string)" , ax \n"
				+(string)"inc ax\n"
				+(string)"mov "+$1->getAVAR()+(string)" , ax \n";
				$$->setAVAR(tc);
			}
			
			
			
			$$->setCode(temp);
			
				
			if(DEBUGL)
			{
				logWrite((string)"inc op asm :"+$$->getCode());
				asmWrite($$->getCode());
			} 
		}
	| variable DECOP
		{
			$$ = new symbolInfo("","");
			logWrite($1->getName());

			logWriteRule("factor","variable DECOP");
			logWrite($1->getName()+"--");
				
			$$ = new symbolInfo("","");
			$$->setName($1->getName()+"--");
			$$->setreturnType($1->getreturnType());
			
			
			string temp ="";
			
			symbolInfo* tempSym = table->lookupAllScope($1->getName());
				
				
				
			if(tempSym == nullptr || tempSym->getidType() =="Array")
			{
				temp =(string)"; line no : "+toString(line_count)+(string)" rule : dec array op \n"
				+$1->getCode()
				+(string)"mov ax , "+$1->getAVAR()+(string)"[bx] \n"
				+(string)"dec ax\n"
				+(string)"mov "+$1->getAVAR()+(string)"[bx] , ax \n";
				$$->setAVAR($1->getAVAR());
			}
			else
			{
				string tc = newTemp();
				temp =(string)"; line no : "+toString(line_count)+(string)" rule : dec op \n"
				+$1->getCode()
				+(string)"mov ax , "+$1->getAVAR()+(string)"\n"
				+(string)"mov "+tc+(string)" , ax \n"
				+(string)"dec ax\n"
				+(string)"mov "+$1->getAVAR()+(string)" , ax \n";
				$$->setAVAR(tc);
			}
			
			
			
			$$->setCode(temp);
			
				
			if(DEBUGL)
			{
				logWrite((string)"dec op asm :"+$$->getCode());
				asmWrite($$->getCode());
			} 
		}
	| ID LPAREN argument_list error {
		
				
			printError("missing ) after Id expression");
			logWriteRule("factor","ID LPAREN argument_list errorr");
			logWrite($1->getName()+(string)"("+$3->getName());
			
			$$ = new symbolInfo("","");
			$$->setName($1->getName()+(string)"("+$3->getName());
			
			if(table->lookupAllScope($1->getName())!=nullptr)
			{
			 	symbolInfo* temp = table->lookupAllScope($1->getName());	
			 	
			 	$$->setreturnType(temp->getreturnType());
			}
		}
	| LPAREN expression error {
		
		
			printError("missing ) after Id expression");
			logWriteRule("factor","LPAREN expression error");
			logWrite((string)"("+$2->getName());
			
			$$ = new symbolInfo("","");
			$$->setName((string)"("+$2->getName());
			$$->setreturnType($2->getreturnType());
		}
	;

argument_list: arguments
					{
						
						logWriteRule("argument_list","arguments");
						logWrite($1->getName());
				
						$$ = new symbolInfo("","");
						$$->setName($1->getName());
						
						//$$->setCode($1->getCode()) ;
					}
			  |
					{
					
						logWriteRule("argument_list","");
						logWrite((string)"");
				
						$$ = new symbolInfo("","");
						$$->setName((string)"");
					}
			  ;

arguments: arguments COMMA logic_expression
					{

						logWriteRule("arguments","arguments COMMA logic_expression");
						logWrite($1->getName()+(string)" , "+$3->getName());
				
						$$ = new symbolInfo("","");
						$$->setName($1->getName()+(string)" , "+$3->getName());
						
						//$$->setCode( $1->getCode() + $3->getCode());
						//$$->setAVAR(fc);
						
					}
	      | logic_expression
					{

						logWriteRule("arguments","logic_expression");
						logWrite($1->getName());
				
						$$ = new symbolInfo("","");
						$$->setName($1->getName());
						
						//$$->setCode( $1->getCode());
						//$$->setAVAR(fc);
					}
					
	      | arguments COMMA error {
					
						printError("missing logic_expression to terminate argument list");
						logWriteRule("arguments","arguments COMMA error");
						logWrite($1->getName()+(string)" , "+ERROR_VALUE);
				
						$$ = new symbolInfo("","");
						$$->setName($1->getName()+(string)" , "+ERROR_VALUE);
				       }
	      ;

%%

int main(int argc,char *argv[])
{

	if((yyin=fopen(argv[1],"r"))==NULL)
	{
		cout<<"Cannot Open Input File."<<endl;
		exit(1);
	}
	
	errorFile.open("error.txt");
	logFile.open("log.txt");
	asmFile.open("asm.txt");
	asmOpFile.open("asm_optimized.txt");
	
	//parserFile.open("parser.txt");
	//freopen("log.txt","w",stdout);
	yyparse();
	
	table->printAllScope();
	
	logFile << "Total Lines : " << line_count << endl << endl;
	logFile << "Total Errors (Syntax/Semantic) : " << syntaxErrors << endl;
	logFile << "Total Errors (Lexical) : " << error_count << endl;
	
	errorFile << "Total Lines : " << line_count << endl << endl;
	errorFile << "Total Errors (Syntax/Semantic) : " << syntaxErrors << endl;
	errorFile << "Total Errors (Lexical) : " << error_count << endl;
	
	
	//errorFile << "Total Warning : " << warnings << endl;

	//table.printAllScope(logFile);
	


	//parserFile.close();
	//fclose(logFile);
	logFile.close();
	errorFile.close();
	asmFile.close();
	asmOpFile.close();

	return 0;
}
