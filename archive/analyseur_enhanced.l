/* Université Abdelmalek Essaadi - ENSAH
   Module : Théorie des langages et compilation
   TP2+ : Analyseur Lexical Amélioré (Enhanced)
   
   Réalisé par : Yazid TAHIRI ALAOUI
   Filière : ID1
   
   Améliorations implémentées:
   1. Suivi des colonnes (column tracking) - erreurs précises
   2. Structure Token avec position complète
   3. Meilleure gestion des chaînes quoted
   4. Messages d'erreur détaillés
*/

%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// Structure Token - tfidna bash n3arfo position exacte
typedef struct {
    char* type_nom;    // ism type (MOT_CLE, IDENTIFIANT, etc.)
    char* value;       // l value dyalo
    int line;          // raqm satr
    int column;        // raqm 3amoud - amélioration jdida!
} Token;

// Variables globales bach nsuiviw position
int nb_lignes = 1;
int nb_colonnes = 1;
int colonne_debut = 1;

// Function bash nrj3o token m3a info kamla
Token creer_token(const char* type, const char* value) {
    Token tok;
    tok.type_nom = strdup(type);
    tok.value = value ? strdup(value) : NULL;
    tok.line = nb_lignes;
    tok.column = colonne_debut;
    return tok;
}

// Function bash n3arsoh
void afficher_token(Token tok) {
    printf("[Ligne %3d, Col %3d] %-15s", tok.line, tok.column, tok.type_nom);
    if (tok.value) {
        printf(": %s", tok.value);
    }
    printf("\n");
}

// Function bash nliberiw memory
void liberer_token(Token tok) {
    if (tok.type_nom) free(tok.type_nom);
    if (tok.value) free(tok.value);
}

// Functions bash nsuiviw colonnes
void avancer_colonne() {
    colonne_debut = nb_colonnes;
    nb_colonnes += yyleng;
}

void nouvelle_ligne() {
    nb_lignes++;
    nb_colonnes = 1;
    colonne_debut = 1;
}
%}

CHIFFRE     [0-9]
LETTRE      [a-zA-Z]
IDENTIFIANT {LETTRE}({LETTRE}|{CHIFFRE}|_)*

%option noyywrap

%%

"#".*           { avancer_colonne(); Token tok = creer_token("COMMENTAIRE", yytext); afficher_token(tok); liberer_token(tok); }

"automate"      { avancer_colonne(); Token tok = creer_token("MOT_CLE", "automate"); afficher_token(tok); liberer_token(tok); }
"alphabet"      { avancer_colonne(); Token tok = creer_token("MOT_CLE", "alphabet"); afficher_token(tok); liberer_token(tok); }
"etats"         { avancer_colonne(); Token tok = creer_token("MOT_CLE", "etats"); afficher_token(tok); liberer_token(tok); }
"initial"       { avancer_colonne(); Token tok = creer_token("MOT_CLE", "initial"); afficher_token(tok); liberer_token(tok); }
"finaux"        { avancer_colonne(); Token tok = creer_token("MOT_CLE", "finaux"); afficher_token(tok); liberer_token(tok); }
"transitions"   { avancer_colonne(); Token tok = creer_token("MOT_CLE", "transitions"); afficher_token(tok); liberer_token(tok); }
"verifier"      { avancer_colonne(); Token tok = creer_token("MOT_CLE", "verifier"); afficher_token(tok); liberer_token(tok); }

"{"             { avancer_colonne(); Token tok = creer_token("SYMBOLE", "{"); afficher_token(tok); liberer_token(tok); }
"}"             { avancer_colonne(); Token tok = creer_token("SYMBOLE", "}"); afficher_token(tok); liberer_token(tok); }
";"             { avancer_colonne(); Token tok = creer_token("SYMBOLE", ";"); afficher_token(tok); liberer_token(tok); }
","             { avancer_colonne(); Token tok = creer_token("VIRGULE", ","); afficher_token(tok); liberer_token(tok); }
":"             { avancer_colonne(); Token tok = creer_token("SEPARATEUR", ":"); afficher_token(tok); liberer_token(tok); }
"="             { avancer_colonne(); Token tok = creer_token("AFFECTATION", "="); afficher_token(tok); liberer_token(tok); }
"->"            { avancer_colonne(); Token tok = creer_token("FLECHE", "->"); afficher_token(tok); liberer_token(tok); }
"\""            { avancer_colonne(); Token tok = creer_token("GUILLEMET", "\""); afficher_token(tok); liberer_token(tok); }

{IDENTIFIANT}   { avancer_colonne(); Token tok = creer_token("IDENTIFIANT", yytext); afficher_token(tok); liberer_token(tok); }

\n              { nouvelle_ligne(); }
[ \t]+          { nb_colonnes += yyleng; }

.               { avancer_colonne(); printf("[Ligne %3d, Col %3d] ERREUR : Caractère inconnu '%s'\n", nb_lignes, colonne_debut, yytext); }

%%

int main(int argc, char** argv) {
    printf("╔═══════════════════════════════════════════════════════════╗\n");
    printf("║   Analyseur Lexical Amélioré - AFD Compiler TP2+        ║\n");
    printf("║   Yazid TAHIRI ALAOUI - ENSAH                            ║\n");
    printf("╚═══════════════════════════════════════════════════════════╝\n\n");
    
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "❌ Erreur: Impossible d'ouvrir '%s'\n", argv[1]);
            return 1;
        }
        printf("📄 Fichier: %s\n\n", argv[1]);
    } else {
        yyin = fopen("exemple.txt", "r");
        if (!yyin) {
            fprintf(stderr, "❌ Erreur: Impossible d'ouvrir exemple.txt\n");
            fprintf(stderr, "Usage: %s [fichier.txt]\n", argv[0]);
            return 1;
        }
        printf("📄 Fichier: exemple.txt\n\n");
    }
    
    printf("═══════════════════ ANALYSE LEXICALE ═══════════════════\n\n");
    
    yylex();
    
    printf("\n═══════════════════ FIN DE L'ANALYSE ═══════════════════\n");
    printf("✅ Total lignes analysées: %d\n", nb_lignes);
    
    fclose(yyin);
    return 0;
}
