%{
#include "parser.tab.h"
#include "def.h"
#include <string.h>

// hna dert amelioration dyal suivi des lignes et colonnes
int nb_colonne = 1;
%}

%%

[ \t]+                { nb_colonne += strlen(yytext); /* Ignorer les espaces */ }

\n                    { nb_colonne = 1; /* rje3 l star jdid */ }

#.*                   { /* Commentaire : makandiro walo */ }

"automate"            { nb_colonne += 9; return TOK_AUTOMATE; }
"alphabet"            { nb_colonne += 8; return TOK_ALPHABET; }
"etats"               { nb_colonne += 5; return TOK_ETATS; }
"initial"             { nb_colonne += 7; return TOK_INITIAL; }
"finaux"              { nb_colonne += 6; return TOK_FINAUX; }
"transitions"         { nb_colonne += 11; return TOK_TRANSITIONS; }
"verifier"            { nb_colonne += 8; return TOK_VERIFIER; }

"->"                  { nb_colonne += 2; return TOK_ARROW; }

[{};=:,]              { nb_colonne++; return yytext[0]; }

\"[^\"]*\"            { 
                        //chaines de caracteres
                        // printf("DEBUG: Chaine trouvee: %s", yytext);
                        yytext[strlen(yytext)-1] = '\0';
                        yylval.str = strdup(yytext+1);
                        nb_colonne += strlen(yytext) + 1;
                        return TOK_STRING; 
                      }

[a-z]                 { yylval.c = yytext[0]; nb_colonne++; return TOK_CHAR; }

[a-zA-Z_][a-zA-Z0-9_]+ { 
                         // Identifiants (bhal q0, q1, Auto1...)
                         yylval.str = strdup(yytext); 
                         nb_colonne += strlen(yytext); 
                         return TOK_IDENTIFIER; 
                       }

[A-Z_][a-zA-Z0-9_]*    { yylval.str = strdup(yytext); nb_colonne += strlen(yytext); return TOK_IDENTIFIER; }

.                     { nb_colonne++; /* Caractere mam3roufch ? */ }

%%

int yywrap(void) {
    return 1;
}