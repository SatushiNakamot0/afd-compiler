/* Université Abdelmalek Essaadi - ENSAH
   Module : Théorie des langages et compilation
   TP2+ : Analyseur Lexical Amélioré pour le Langage AFD
   
   Réalisé par : Yazid TAHIRI ALAOUI
   Filière : ID1
   
   Améliorations:
   1. Suivi des colonnes (column tracking)
   2. Retour de codes token au lieu de printf
   3. Meilleure gestion des chaînes
   4. Préparation pour l'intégration avec Bison
*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include "tokens.h"

// Variables globales bach nt7akmo f position
int nb_lignes = 1;      // 3adad stourat
int nb_colonnes = 1;    // 3adad l3amouda (jdid!)
int colonne_debut = 1;  // fin bda token (bach n3arfo position)

// Function bach nkhazno l colonnes
void avancer_colonne() {
    colonne_debut = nb_colonnes;
    nb_colonnes += yyleng;
}

// Function bach nrj3o token m3a l info dyalo
Token creer_token(int type, char* value) {
    Token tok;
    tok.type = type;
    tok.value = value ? strdup(value) : NULL;
    tok.line = nb_lignes;
    tok.column = colonne_debut;
    return tok;
}

// Function bach n3arso token (pour debug)
void afficher_token(Token tok) {
    printf("[Ligne %d, Col %d] ", tok.line, tok.column);
    
    switch(tok.type) {
        case TOK_AUTOMATE:    printf("MOT_CLE : automate\n"); break;
        case TOK_ALPHABET:    printf("MOT_CLE : alphabet\n"); break;
        case TOK_ETATS:       printf("MOT_CLE : etats\n"); break;
        case TOK_INITIAL:     printf("MOT_CLE : initial\n"); break;
        case TOK_FINAUX:      printf("MOT_CLE : finaux\n"); break;
        case TOK_TRANSITIONS: printf("MOT_CLE : transitions\n"); break;
        case TOK_VERIFIER:    printf("MOT_CLE : verifier\n"); break;
        case TOK_LBRACE:      printf("SYMBOLE : {\n"); break;
        case TOK_RBRACE:      printf("SYMBOLE : }\n"); break;
        case TOK_SEMICOLON:   printf("SYMBOLE : ;\n"); break;
        case TOK_COMMA:       printf("VIRGULE : ,\n"); break;
        case TOK_COLON:       printf("SEPARATEUR : :\n"); break;
        case TOK_EQUAL:       printf("AFFECTATION : =\n"); break;
        case TOK_ARROW:       printf("FLECHE : ->\n"); break;
        case TOK_QUOTE:       printf("GUILLEMET : \"\n"); break;
        case TOK_IDENTIFIER:  printf("IDENTIFIANT : %s\n", tok.value); break;
        case TOK_COMMENT:     printf("COMMENTAIRE : %s\n", tok.value); break;
        case TOK_STRING:      printf("CHAINE : \"%s\"\n", tok.value); break;
        case TOK_ERROR:       printf("ERREUR : %s\n", tok.value); break;
        default:              printf("TOKEN_INCONNU : %d\n", tok.type); break;
    }
}
%}

/* Définitions - t3arif dyaln */
CHIFFRE     [0-9]
LETTRE      [a-zA-Z]
IDENTIFIANT {LETTRE}({LETTRE}|{CHIFFRE}|_)*
CHAINE      \"[^\"]*\"

/* Options dyalna */
%option noyywrap

%%

/* Commentaires - ta3liqat */
#.*  { 
    avancer_colonne();
    Token tok = creer_token(TOK_COMMENT, yytext);
    afficher_token(tok);
    if(tok.value) free(tok.value);
}

/* Mots-clés - kalmat moftahiya */
"automate"  { 
    avancer_colonne();
    Token tok = creer_token(TOK_AUTOMATE, NULL);
    afficher_token(tok);
}

"alphabet"  { 
    avancer_colonne();
    Token tok = creer_token(TOK_ALPHABET, NULL);
    afficher_token(tok);
}

"etats"     { 
    avancer_colonne();
    Token tok = creer_token(TOK_ETATS, NULL);
    afficher_token(tok);
}

"initial"   { 
    avancer_colonne();
    Token tok = creer_token(TOK_INITIAL, NULL);
    afficher_token(tok);
}

"finaux"    { 
    avancer_colonne();
    Token tok = creer_token(TOK_FINAUX, NULL);
    afficher_token(tok);
}

"transitions" { 
    avancer_colonne();
    Token tok = creer_token(TOK_TRANSITIONS, NULL);
    afficher_token(tok);
}

"verifier"  { 
    avancer_colonne();
    Token tok = creer_token(TOK_VERIFIER, NULL);
    afficher_token(tok);
}

/* Symboles - ramouze */
"{"    { 
    avancer_colonne();
    Token tok = creer_token(TOK_LBRACE, NULL);
    afficher_token(tok);
}

"}"    { 
    avancer_colonne();
    Token tok = creer_token(TOK_RBRACE, NULL);
    afficher_token(tok);
}

";"    { 
    avancer_colonne();
    Token tok = creer_token(TOK_SEMICOLON, NULL);
    afficher_token(tok);
}

","    { 
    avancer_colonne();
    Token tok = creer_token(TOK_COMMA, NULL);
    afficher_token(tok);
}

":"    { 
    avancer_colonne();
    Token tok = creer_token(TOK_COLON, NULL);
    afficher_token(tok);
}

"="    { 
    avancer_colonne();
    Token tok = creer_token(TOK_EQUAL, NULL);
    afficher_token(tok);
}

"->"   { 
    avancer_colonne();
    Token tok = creer_token(TOK_ARROW, NULL);
    afficher_token(tok);
}

"\""   { 
    avancer_colonne();
    Token tok = creer_token(TOK_QUOTE, NULL);
    afficher_token(tok);
}

/* Chaînes entre guillemets - amélioration #3 */
{CHAINE} {
    avancer_colonne();
    // nkhado text bla guillemets
    char* contenu = strndup(yytext + 1, yyleng - 2);
    Token tok = creer_token(TOK_STRING, contenu);
    afficher_token(tok);
    if(tok.value) free(tok.value);
    free(contenu);
}

/* Identifiants - asm8i */
{IDENTIFIANT} { 
    avancer_colonne();
    Token tok = creer_token(TOK_IDENTIFIER, yytext);
    afficher_token(tok);
    if(tok.value) free(tok.value);
}

/* Nouvelles lignes - stourat jdad */
\n  { 
    nb_lignes++; 
    nb_colonnes = 1;     // nr7o l bdaya dyal satr
    colonne_debut = 1;
}

/* Espaces et tabulations - faraghat */
[ \t]+  { 
    nb_colonnes += yyleng;  // nzidhom l colonnes bla ma n3arso
}

/* Caractères inconnus - hrouf ma3rofinach */
.   { 
    avancer_colonne();
    Token tok = creer_token(TOK_ERROR, yytext);
    printf("ERREUR a la ligne %d, colonne %d : Caractere inconnu '%s'\n", 
           tok.line, tok.column, yytext);
    if(tok.value) free(tok.value);
}

%%

/* Fonction principale - dyal test */
int main(int argc, char** argv) {
    // ila 3tana fichier f command line, nst3mloh
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            printf("Erreur : Impossible d'ouvrir le fichier '%s'\n", argv[1]);
            return 1;
        }
    } else {
        // sinon nst3mlou exemple.txt
        yyin = fopen("exemple.txt", "r");
        if (!yyin) {
            printf("Erreur : Impossible d'ouvrir exemple.txt\n");
            printf("Usage: %s [fichier]\n", argv[0]);
            return 1;
        }
    }
    
    printf("=== Analyse Lexicale Améliorée ===\n");
    printf("Fichier: %s\n\n", argc > 1 ? argv[1] : "exemple.txt");
    
    // ndirou scan dyal kolchi
    yylex();
    
    printf("\n=== Fin de l'analyse ===\n");
    printf("Total lignes: %d\n", nb_lignes);
    
    fclose(yyin);
    return 0;
}
