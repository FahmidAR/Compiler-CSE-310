#ifndef AHM_ENG_H
#define AHM_ENG_H

#define DEBUGL 0

ofstream asmFile;
ofstream  asmOpFile;

int labelCount=0;
int tempCount=0;

string dataCode = "";

string newLabel() {
	string lb = "L";
	char b[5];
	sprintf(b, "%d", labelCount);
	labelCount++;
	lb += b;
	return lb;
}


string newTemp() {
	string t = "t";
	char b[3];
	sprintf(b, "%d", tempCount );
	tempCount++;
	t += b;
	dataCode = dataCode+t+" dw ? \n";
	return t;
}

string optASM(string code)
{
 	string optCode=code;
 	
 	
 	
 	
 	return  optCode;
}

	

string funcDefASM(string funName , string statementCode)
{
	if(funName == "main")
	{
		return (string)"\n"+funName+(string)" proc \n"
		+(string)"mov ax , @data\nmov ds , ax"
		+statementCode
		+funName+(string)"label: \n"
		+(string)"mov ah , 4ch \n"
		+(string)"int 21h \n\n"
		+funName+(string)" endp \n";
		
    
	}
	else
	{
		return (string)"\n"+funName+(string)" proc \n"
		+statementCode
		+funName+(string)"label: \n"
		+(string)"ret \n\n"
		+funName+(string)" endp \n\n";
	}
	
}

string printCODE()
{

return (string)"hexToDec proc\n"
"\n"
"; bx as input\n"
"\n"
"cmp bx , 0\n"
"jge pos\n"
"neg bx\n"
"\n"
"mov ah , 2\n"
"mov dl , 45\n"
"int 21h\n"
"\n"
"\n"
"\n"
"pos:\n"
"\n"
"xor cx , cx\n"
"\n"
"mov ax , bx\n"
"\n"
"hex:\n"
"\n"
"mov dx , 0\n"
"\n"
"mov bx , 10\n"
"\n"
"div bx\n"
"\n"
"add dx , 48\n"
"mov bx , ax\n"
"\n"
"push dx\n"
"inc cx\n"
"\n"
";mov ah , 2\n"
";mov dx , dx\n"
";int 21h\n"
"\n"
"mov ax , bx\n"
"cmp al , 0\n"
"jnz hex\n"
"\n"
"mov ah , 2\n"
"\n"
"output:\n"
"\n"
"pop dx\n"
"int 21h\n"
"loop output\n"
"\n"
"ret\n"
"hexToDec endp\n\n";

}

void  writeAllCode(string codeAll) {

	 
	
	string opCode = optASM(codeAll);

	asmFile << ".model small\r\n";
	asmFile << "\n.stack 100h\r\n";
	asmFile << "\n.data\r\n\n" << dataCode;
	asmFile << "\n.code\r\n\n" << codeAll+printCODE();
	asmFile << (string)"\r\n" ;
	asmFile << "end main";


	asmOpFile << ".model small\r\n";
	asmOpFile << "\n.stack 100h\r\n";
	asmOpFile << "\n.data\r\n\n" << dataCode;
	asmOpFile << "\n.code\r\n\n\n" << opCode+printCODE();
	asmOpFile << (string)"\r\n" ;
	asmOpFile << "end main";
}

void asmWrite(const string &s)
{
	asmFile <<s<< endl << endl;
	//fprintf(logFile,"%s\n\n",s);
}

void asmWriteRule( const string &rule) 
{
	asmFile << "; At line no: " << line_count <<" : "<<rule << endl << endl;
	
}


#endif // AHM_ENG_H
