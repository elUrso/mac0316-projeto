D [0-9]
E [Ee][+-]?{D}+
S [a-zA-Z]
Z [a-zA-Z0-9]

%{
#include <math.h>
#include <string.h>
#include "mcalc.tab.h"
%}


%%

propono  { return PRINT; }       /* token to print values */
quod     { return BEGINIF; }     /* token to begin if */
paro    { return SETBOX; }       /* token to manipulate boxes */
functio { return NEWFUNCTION; } /* token to create function*/
tum      { return NEXTLINE; }    /* token to create sequences */
transeat { return NEWLAMBDA; }   /* token to create lambda */
ad       { return LAMBDABODY; }  /* token to set lambda body */


{D}*[.]?{D}+{E}?	{ yylval.val = yytext; return NUM; }
{S}+{Z}*             { yylval.val = strdup(yytext); return SYMBOL; }

[ \t\n]+	/* pula espacos em branco */

#.*		/* comentarios simples */

[(]		{ return OPEN; }
[)]		{ return CLOSE; }
[+]		{ return ADD; }
[-]		{ return SUB; }
[?]     { return IF; }
[:]     { return ELSE; }
[!]     { return ENDIF; }
[*]		{ return MUL; }
[/]		{ return DIV; }
[\[]    { return OPENCALL; }
[\]]    { return CLOSECALL; }

.	{  fprintf(stderr, "Entrada ignorada\n-->%s\n", yytext); }

%%

/* Local Variables: */
/* mode: c */
/* End: */