bison -d -y -v 1705087.y
echo '### 1705087  y.tab.h created ###'
g++-8 -w -c -o y.o y.tab.c

echo '### 1705087  warning removed ###'
flex 1705087.l

echo '### 1705087  flex file compiled into c file ###'
g++-8 -w -c -o l.o lex.yy.c

echo '### 1705087  flex C file compiled machine language ###'
g++-8 -o parser.out y.o l.o -lfl	

echo '### 1705087 output file genarated ###'
./parser.out $1	

echo '### 1705087  Input file parsed Succesfully ###'	
