%{
#include "parser.tab.h"
#include "def.h"
#include <string.h>
%}

%%

[ \t\n]+              { /* Ignore whitespace */ }
#.*                   { /* Ignore comments */ }

"automate"            { return TOK_AUTOMATE; }
"alphabet"            { return TOK_ALPHABET; }
"etats"               { return TOK_ETATS; }
"initial"             { return TOK_INITIAL; }
"finaux"              { return TOK_FINAUX; }
"transitions"         { return TOK_TRANSITIONS; }
"verifier"            { return TOK_VERIFIER; }

"->"                  { return TOK_ARROW; }

[{};=:,]              { return yytext[0]; }

\"[^\"]*\"            { 
                        yytext[strlen(yytext)-1] = '\0';  /* Remove closing quote */
                        yylval.str = strdup(yytext+1);     /* Skip opening quote */
                        return TOK_STRING; 
                      }

[a-z]                 { yylval.c = yytext[0]; return TOK_CHAR; }

[a-zA-Z_][a-zA-Z0-9_]+ { yylval.str = strdup(yytext); return TOK_IDENTIFIER; }
[A-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); return TOK_IDENTIFIER; }

.                     { /* Ignore unknown characters */ }


%%

int yywrap(void) {
    return 1;
}