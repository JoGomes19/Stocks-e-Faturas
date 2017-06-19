%{	
#include "y.tab.h"
#include "hashtable.h"	
%}


%%


"." 			{ return '.'; }
";" 			{ return ';'; }
"-"			    { return '-'; }
"|"			    { return '|'; }





(?i:STOCK)  			{ return STOCK;     }
(?i:CLIENTE)  			{ return CLIENTE;   }
(?i:FATURA)  			{ return FATURA;    }
(?i:VENDAS)  			{ return VENDAS;    }
(?i:NIF:)  			{ return NIF2P;     }
(?i:NIB:)  			{ return NIB2P;     }




L?\"(\\.|[^\\"])*\"		{ 
			  yylval.vars = strdup(yytext);
			  return str;
			}

[a-zA-Z_][a-zA-Z0-9_]*		{
			  yylval.vars = strdup(yytext); 
			  return id;
			}
			
[ \t]			;
[+-]?[0-9]+      { yylval.vari=atoi(yytext); return(num);}			


.			{return ERRO;}

.|\n		{;}

%%

int yywrap() 
{
	return 1;
}
