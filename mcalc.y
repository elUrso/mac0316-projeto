/* Calculadora infixa */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
char *oper(char op, char *l, char *r) {
	char *res = malloc(strlen(l)+strlen(r)+6);
	sprintf(res, "(%c %s %s)", op, l, r);
	return res;
}

/* (if (cond) (true) (false)) */
char *makeIfElse(char* cond, char *ifTrue, char *ifFalse) {
	char *res = malloc(strlen(cond)+strlen(ifTrue)+strlen(ifFalse)+8);
	sprintf(res, "(if %s %s %s)", cond, ifTrue, ifFalse);
	return res;
}

/* (call symbol arg) */
char *makeCall(char* funcName, char *arg) {
	char *res = malloc(strlen(funcName)+strlen(arg)+9);
	sprintf(res, "(call %s %s)", funcName, arg);
	return res;
}

/* (func symbol exp) */
char *makeLambda(char* symbol, char *body) {
	char *res = malloc(strlen(symbol)+strlen(body)+9);
	sprintf(res, "(func %s %s)", symbol, body);
	return res;
}

/* (seq (:= name 0) (:= name (func symbol exp))) */
char *makeFunction(char* name, char* symbol, char *body) {
	char *res = malloc(strlen(name) * 2 + strlen(symbol) + strlen(body) + 29);
	sprintf(res, "(seq (:= %s 0) (:= %s (func %s %s)))", name, name, symbol, body);
	return res;
}

/* (seq before after) */
char *makeSeq(char* before, char *after) {
	char *res = malloc(strlen(before)+strlen(after)+8);
	sprintf(res, "(seq %s %s)", before, after);
	return res;
}

/* (:= symbol value) */
char *setBox(char* symbol, char* value) {
	char *res = malloc(strlen(symbol)+strlen(value)+7);
	sprintf(res, "(:= %s %s)", symbol, value);
	return res;
}

/* (print value) */
char *print(char* value) {
	char *res = malloc(strlen(value)+9);
	sprintf(res, "(print %s)", value);
	return res;
}

/* duplicate string */
char *dup(char *orig) {
	char *res = malloc(strlen(orig)+1);
	strcpy(res,orig);
	return res;
}

int yylex();
void yyerror(char *);
%}

%union {
	char *val;
}

%token	<val> NUM
%token	<val> SYMBOL
%token  PRINT OPEN CLOSE BEGINIF IF ELSE ENDIF OPENCALL CLOSECALL
%token	SETBOX NEXTLINE NEWLAMBDA LAMBDABODY NEWFUNCTION
%type	<val> exp 
%type	<val> seq

%left ADD SUB
%left MUL DIV
%left NEG

/* Gramatica */
%%

input: 		
		| 		seq     { puts($1);}
		| 		error  	{ fprintf(stderr, "Entrada inválida\n"); }
;

exp:			NUM 		{ $$ = dup($1); }
		|		SYMBOL		{ $$ = dup($1); }
		|		SETBOX SYMBOL OPEN exp CLOSE { $$ = setBox($2, $4); }
		|		PRINT OPEN exp CLOSE	{ $$ = print($3); }
		|		BEGINIF exp IF exp ELSE exp ENDIF { $$ = makeIfElse($2, $4, $6); }
		|		NEWFUNCTION SYMBOL SYMBOL OPEN exp CLOSE { $$ = makeFunction($2, $3, $5); }
		|		NEWLAMBDA SYMBOL LAMBDABODY OPEN exp CLOSE { $$ = makeLambda($2, $5);}
		|		BEGINIF exp IF exp ENDIF { $$ = makeIfElse($2, $4, ""); }
		|		OPENCALL exp exp CLOSECALL { $$ = makeCall($2, $3); }
		| 		exp ADD exp	{ $$ = oper('+', $1, $3);}
		| 		exp SUB exp	{ $$ = oper('-', $1, $3);}
		| 		exp MUL exp	{ $$ = oper('*', $1, $3);}
		|		exp DIV exp { $$ = oper('/', $1, $3);}
		| 		SUB exp %prec NEG  { $$ = oper('~', $2, "");} 
		| 		OPEN seq CLOSE	{ $$ = dup($2);}
;

seq: 			exp NEXTLINE seq { $$ = makeSeq($1, $3); }
		|		exp
;

%%

void yyerror(char *s) {
  fprintf(stderr,"%s\n",s);
}
