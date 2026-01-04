%{
#include <stdio.h>
#include <string.h>

extern FILE *yyin;

int ligne = 1;

int yywrap() {
    return 1;
}
%}

LETTRE      [a-zA-Z]
CHIFFRE     [0-9]
IDENTIFIANT {LETTRE}({LETTRE}|{CHIFFRE})*
CHAINE      \"[^\"]*\"
ESPACE      [ \t]+

%%

#[^\n]* {}

"automate"    { printf("MOT_CLE: automate\n"); }
"alphabet"    { printf("MOT_CLE: alphabet\n"); }
"etats"       { printf("MOT_CLE: etats\n"); }
"initial"     { printf("MOT_CLE: initial\n"); }
"finaux"      { printf("MOT_CLE: finaux\n"); }
"transitions" { printf("MOT_CLE: transitions\n"); }
"verifier"    { printf("MOT_CLE: verifier\n"); }


"{"           { printf("ACCOLADE_OUVRANTE\n"); }
"}"           { printf("ACCOLADE_FERMANTE\n"); }
";"           { printf("POINT_VIRGULE\n"); }
"="           { printf("AFFECTATION\n"); }
":"           { printf("DEUX_POINTS\n"); }
"->"          { printf("FLECHE_TRANSITION\n"); }
","           { printf("VIRGULE\n"); }
{CHAINE}      { printf("CHAINE: %s\n", yytext); }
{IDENTIFIANT} { printf("IDENTIFIANT: %s\n", yytext); }
{ESPACE}      {}
\n            { ligne++; }

.             { printf("ERREUR LEXICALE (Ligne %d): Caractère inconnu '%s'\n", ligne, yytext); }

%%

int main(int argc, char **argv) {
    if (argc < 2) {
        printf("Usage: %s <fichier_source>\n", argv[0]);
        return 1;
    }

    yyin = fopen(argv[1], "r");
    if (yyin == NULL) {
        printf("Erreur: Impossible d'ouvrir le fichier %s\n", argv[1]);
        return 1;
    }

    yylex();

    fclose(yyin);
    return 0;
}