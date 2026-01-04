/* Université Abdelmalek Essaadi - ENSAH
   Module : Théorie des langages et compilation
   TP2 : Analyseur Lexical pour le Langage A
   
   Réalisé par : Yazid TAHIRI ALAOUI
   Filière : ID1
*/

%{
#include <stdio.h>
#include <string.h>

int nb_lignes = 1;
%}


CHIFFRE     [0-9]
LETTRE      [a-zA-Z]
IDENTIFIANT {LETTRE}({LETTRE}|{CHIFFRE})*

%%


#.* { printf("COMMENTAIRE : %s\n", yytext); }


"automate"    { printf("MOT_CLE : automate\n"); }
"alphabet"    { printf("MOT_CLE : alphabet\n"); }
"etats"       { printf("MOT_CLE : etats\n"); }
"initial"     { printf("MOT_CLE : initial\n"); }
"finaux"      { printf("MOT_CLE : finaux\n"); }
"transitions" { printf("MOT_CLE : transitions\n"); }
"verifier"    { printf("MOT_CLE : verifier\n"); }


"{"    { printf("SYMBOLE : {\n"); }
"}"    { printf("SYMBOLE : }\n"); }
";"    { printf("SYMBOLE : ;\n"); }
","    { printf("VIRGULE : ,\n"); }  
":"    { printf("SEPARATEUR : :\n"); }
"="    { printf("AFFECTATION : =\n"); }
"->"   { printf("FLECHE : ->\n"); }
"\""   { printf("GUILLEMET : \"\n"); }
{IDENTIFIANT} { printf("IDENTIFIANT : %s\n", yytext); }
\n      { nb_lignes++; }
[ \t]+  {}
.       { printf("ERREUR a la ligne %d : Caractere inconnu '%s'\n", nb_lignes, yytext); }

%%

int yywrap() {
    return 1;
}

int main() {
    yyin = fopen("exemple.txt", "r"); 
    if (!yyin) {
        printf("Erreur : Impossible d'ouvrir exemple.txt\n");
        return 1;
    }
    yylex();
    
    fclose(yyin);
    return 0;
}