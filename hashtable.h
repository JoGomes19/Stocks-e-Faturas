#ifndef HASHTABLE_H
#define HASHTABLE_H

typedef struct hashtable *HashTable;
typedef struct node *table;


HashTable createHashTable(const unsigned int capacity);
void destroyHashTable(HashTable h);
HashTable addHashTable(HashTable h,char *key, char *desc, int valor, int quantidade);
table get_HashTable(HashTable hashtbl, char *key);
int getEndereco(const HashTable h, char *key);
void setInicializacao(const HashTable h, char *key);
int getInicializacao(const HashTable h, char *key);
char* getDesc(const HashTable h, char *key);
int getValor(const HashTable h, char *key);
void setQuantidade(const HashTable h, char *key,int quantidade);
void printHashTable(HashTable h);
int getQuantidade(const HashTable h, char *key);


#endif
