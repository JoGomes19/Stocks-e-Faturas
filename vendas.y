%{
#include "hashtable.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>

void insere_Produto( HashTable, char *, char *, int, int );
void vendaPossivel(char *,int );

HashTable tabelaProdutos;
char *ref;
char *nome;
int valor;
int quantidade;
int totalVendas = 0;
int totalFatura = 0;
int totalLinha;
int fatura = 1;
int totalIVA = 0;
char* cliente;


%}

%union
{
  int vari;
  char *vars;
}

//Simbolos Terminais
%token ERRO
%token <vars> id str
%token <vari> num
%token STOCK FATURA  VENDAS NIF2P NIB2P CLIENTE		// VER DEFINICAO DE NIF2P NO FICHEIRO .l  

//Simbolo de Inicio 
%start Vendas

%%


Vendas : STOCK Stock Faturas {
                              printf("Valor total de vendas: %d€\n",totalVendas);
                              printf("Valor total de imposto pago(IVA): %d€\n",totalIVA);
		                      printf("\n");
    			              printf("############## STOCK FINAL ################\n\n");
    			              printHashTable(tabelaProdutos);}
       ;

Stock : Entrada			
      | Stock ';' Entrada
      ;

Entrada :  RefProd '-' Desc '-' ValUnit '-' Quant	{insere_Produto(tabelaProdutos,ref,nome,valor,quantidade);}
							
	;


Faturas : Fatura	
	| Faturas Fatura
	;

Fatura : FATURA Cabec VENDAS Corpo {printf("Total da fatura do cliente %s -->  %d€\n\n",cliente,totalFatura ); fatura++; totalFatura =0;} // no final de cada fatura o total volta a zero
       ;

Cabec : IdFat IdForn CLIENTE IdClie
      ;

IdFat : id
      ;

IdForn : Nome Morada NIF2P NIF NIB2P NIB  // NIF: ----> NIF2P != NIF ---> SIMBOLO RECURSIVO DEFINIDO EM BAIXO (VER DEFINIÇAO DA GRAMATICA)
       ;				  // NIB: ----> NIB2P != NIB ---> SIMBOLO RECURSIVO DEFINIDO EM BAIXO (VER DEFINIÇAO DA GRAMATICA)	

IdClie : Nome Morada NIF2P NIF 
       ;

Nome : str {cliente = strdup($1);}
     ;

NIF : str
    ;

Morada : str
       ;

NIB : str
    ;

Corpo : Linha '.'       {
                         if (get_HashTable(tabelaProdutos,ref) && getQuantidade(tabelaProdutos,ref) >= quantidade){
                            printf("Com produto %s fizemos %d€\n",getDesc(tabelaProdutos,ref),totalLinha);
                          };
                        }
      | Corpo Linha '.' {
                         if (get_HashTable(tabelaProdutos,ref) && getQuantidade(tabelaProdutos,ref) >= quantidade){
                            printf("Com produto %s fizemos %d€\n",getDesc(tabelaProdutos,ref),totalLinha);
                          };
                        }



Linha : RefProd '|' Quant	{if (get_HashTable(tabelaProdutos,ref)==NULL){printf("O produto com referencia %s não se encontra em Stock.\n",ref);}
				else {vendaPossivel(ref,quantidade);}}
      ;

RefProd : id {ref = strdup($1);}
	;

Desc : str	{nome = strdup($1);}
     ;

ValUnit : num	{valor = ($1);}
	;

Quant : num	{quantidade =($1);}
      ;




%%

#include "lex.yy.c"

void insere_Produto( HashTable tabelaProdutos, char *refProduto, char *descricao, int valor, int quantidade){
  table existe = get_HashTable(tabelaProdutos, refProduto);
  if(existe!=NULL) {
                        char *aux = (char*)malloc(sizeof(aux)+1);
                  } 
  if(existe==NULL) 
      {
          tabelaProdutos=addHashTable(tabelaProdutos, refProduto, descricao, valor, quantidade);
      }
}

void vendaPossivel(char *ref,int quantidade){
	if (getQuantidade(tabelaProdutos,ref)-quantidade < 0)
        printf("Não temos quantidade suficiente de %s para vender a quantidade requerida.\n",getDesc(tabelaProdutos,ref));
	else{
        setQuantidade(tabelaProdutos,ref,quantidade);
        totalLinha  = getValor(tabelaProdutos,ref)*quantidade;
        totalIVA    += totalLinha* 0.23; 
        totalFatura += totalLinha;
        totalVendas += totalLinha; 
    }
}

int yyerror(char *s){
    printf("error %s\n",s);

}

int main(){
  tabelaProdutos = createHashTable(0);
       printf("Start compiler:\n");
    yyparse();
       printf("End compiler\n");
    return 0;
}


