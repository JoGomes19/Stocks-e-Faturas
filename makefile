vendas: lex.yy.c y.tab.c hashtable.o
	gcc  y.tab.c -o vendas hashtable.o

y.tab.c: vendas.y 	
	yacc -d -v vendas.y


hashtable.o: hashtable.c hashtable.h
	gcc  -c hashtable.c


lex.yy.c: vendas.l
	flex vendas.l
