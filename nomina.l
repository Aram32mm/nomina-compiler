%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%

"EMPLEADO"      { return EMPLEADO; }
"CALCULAR"      { return CALCULAR; }
"MOSTRAR"       { return MOSTRAR; }
"TOTAL"         { return TOTAL; }

[a-zA-Z][a-zA-Z0-9_]*  { 
    yylval.str = strdup(yytext); 
    return NOMBRE; 
}

[0-9]+          { yylval.num = atoi(yytext); return NUMERO; }
[0-9]+\.[0-9]+  { yylval.fnum = atof(yytext); return DECIMAL; }

\n              { return EOL; }
[ \t]           { /* ignorar espacios */ }
.               { printf("Caracter desconocido: %s\n", yytext); }

%%

int yywrap() { return 1; }
