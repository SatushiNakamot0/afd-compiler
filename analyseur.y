/* Université Abdelmalek Essaadi - ENSAH
   Module : Théorie des langages et compilation
   TP3 : Analyseur Syntaxique (Parser) pour AFD
   
   Réalisé par : Yazid TAHIRI ALAOUI
   Filière : ID1
*/

%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "tokens.h"
#include "symbol_table.h"
#include "ast.h"

// Variables globales
extern int nb_lignes;
extern int nb_colonnes;
extern FILE* yyin;

// L AST dyal l automate kolha
AutomateAST* automate_courant = NULL;

// Table des symboles - jdawal ramouze
SymbolTable* table_symboles = NULL;

// Functions li ghadi nst3mlohom
void yyerror(const char* msg);
int yylex(void);

%}

/* Union bach nkhazno values dyal tokens */
%union {
    char* string;          // text (identifiants, strings)
    int nombre;            // nombres
    AutomateAST* automate; // AST dyal automate
    ListeEtats* etats;     // liste dyal l7alat
    ListeSymboles* symboles; // liste dyal symboles
    Transition* transition;  // transition wa7da
    ListeTransitions* transitions; // liste dyal transitions
}

/* Tokens - ra token codes mn lexer */
%token TOK_AUTOMATE TOK_ALPHABET TOK_ETATS TOK_INITIAL TOK_FINAUX TOK_TRANSITIONS TOK_VERIFIER
%token TOK_LBRACE TOK_RBRACE TOK_SEMICOLON TOK_COMMA TOK_COLON TOK_EQUAL TOK_ARROW TOK_QUOTE
%token <string> TOK_IDENTIFIER TOK_COMMENT TOK_STRING
%token TOK_ERROR TOK_EOF

/* Types dyal non-terminaux */
%type <automate> automate
%type <etats> liste_etats liste_etats_corps
%type <symboles> liste_symboles liste_symboles_corps
%type <transitions> liste_transitions liste_transitions_corps
%type <transition> transition
%type <string> identificateur

/* Priorités o associativité */
%start programme

%%

/* Règle principale - qwa3id raisiya */
programme:
    automate {
        automate_courant = $1;
        printf("\n=== Analyse syntaxique réussie! ===\n");
        printf("Automate: %s\n", $1->nom);
    }
    | /* fichier khawi */
    ;

/* Définition d'un automate */
automate:
    TOK_AUTOMATE identificateur TOK_LBRACE 
        declarations
    TOK_RBRACE {
        printf("Automate défini: %s\n", $2);
        
        // nzidhom l table des symboles
        if (!ajouter_symbole(table_symboles, $2, TYPE_AUTOMATE, nb_lignes)) {
            yyerror("Automate déjà défini");
        }
        
        $$ = creer_automate($2);
        free($2);
    }
    ;

identificateur:
    TOK_IDENTIFIER { 
        $$ = strdup($1); 
        free($1);
    }
    ;

/* Déclarations f l intérieur dyal automate */
declarations:
    declaration
    | declarations declaration
    ;

declaration:
    alphabet_decl
    | etats_decl
    | initial_decl
    | finaux_decl
    | transitions_decl
    ;

/* Alphabet = {symboles} */
alphabet_decl:
    TOK_ALPHABET TOK_EQUAL TOK_LBRACE liste_symboles TOK_RBRACE TOK_SEMICOLON {
        printf("Alphabet défini avec %d symboles\n", compter_symboles($4));
        if (automate_courant) {
            automate_courant->alphabet = $4;
        }
    }
    ;

liste_symboles:
    TOK_LBRACE liste_symboles_corps TOK_RBRACE { $$ = $2; }
    ;

liste_symboles_corps:
    identificateur {
        $$ = creer_liste_symboles();
        ajouter_symbole_liste($$, $1);
        free($1);
    }
    | liste_symboles_corps TOK_COMMA identificateur {
        ajouter_symbole_liste($1, $3);
        free($3);
        $$ = $1;
    }
    ;

/* États = {q0, q1, ...} */
etats_decl:
    TOK_ETATS TOK_EQUAL TOK_LBRACE liste_etats TOK_RBRACE TOK_SEMICOLON {
        printf("États définis: %d états\n", compter_etats($4));
        if (automate_courant) {
            automate_courant->etats = $4;
        }
        
        // nzidhom kolhom l table
        ListeEtats* courant = $4;
        while (courant) {
            ajouter_symbole(table_symboles, courant->nom, TYPE_ETAT, nb_lignes);
            courant = courant->suivant;
        }
    }
    ;

liste_etats:
    TOK_LBRACE liste_etats_corps TOK_RBRACE { $$ = $2; }
    ;

liste_etats_corps:
    identificateur {
        $$ = creer_liste_etats();
        ajouter_etat($$, $1);
        free($1);
    }
    | liste_etats_corps TOK_COMMA identificateur {
        ajouter_etat($1, $3);
        free($3);
        $$ = $1;
    }
    ;

/* Initial = q0 */
initial_decl:
    TOK_INITIAL TOK_EQUAL identificateur TOK_SEMICOLON {
        printf("État initial: %s\n", $3);
        
        // nchofou wash kayn f etats
        if (!chercher_symbole(table_symboles, $3)) {
            char msg[100];
            sprintf(msg, "État initial '%s' non défini dans etats", $3);
            yyerror(msg);
        }
        
        if (automate_courant) {
            automate_courant->etat_initial = strdup($3);
        }
        free($3);
    }
    ;

/* Finaux = {q_final, ...} */
finaux_decl:
    TOK_FINAUX TOK_EQUAL TOK_LBRACE liste_etats TOK_RBRACE TOK_SEMICOLON {
        printf("États finaux: %d états\n", compter_etats($4));
        
        // nverifiw kolhom kaynin
        ListeEtats* courant = $4;
        while (courant) {
            if (!chercher_symbole(table_symboles, courant->nom)) {
                char msg[100];
                sprintf(msg, "État final '%s' non défini", courant->nom);
                yyerror(msg);
            }
            courant = courant->suivant;
        }
        
        if (automate_courant) {
            automate_courant->etats_finaux = $4;
        }
    }
    ;

/* Transitions = { q0:a->q1; ... } */
transitions_decl:
    TOK_TRANSITIONS TOK_EQUAL TOK_LBRACE liste_transitions TOK_RBRACE TOK_SEMICOLON {
        printf("Transitions définies: %d transitions\n", compter_transitions($4));
        if (automate_courant) {
            automate_courant->transitions = $4;
        }
    }
    ;

liste_transitions:
    TOK_LBRACE liste_transitions_corps TOK_RBRACE { $$ = $2; }
    ;

liste_transitions_corps:
    transition {
        $$ = creer_liste_transitions();
        ajouter_transition($$, $1);
    }
    | liste_transitions_corps transition {
        ajouter_transition($1, $2);
        $$ = $1;
    }
    ;

/* Transition: q0:a->q1; */
transition:
    identificateur TOK_COLON identificateur TOK_ARROW identificateur TOK_SEMICOLON {
        // nverifiw les états
        if (!chercher_symbole(table_symboles, $1)) {
            char msg[100];
            sprintf(msg, "État source '%s' non défini", $1);
            yyerror(msg);
        }
        if (!chercher_symbole(table_symboles, $5)) {
            char msg[100];
            sprintf(msg, "État destination '%s' non défini", $5);
            yyerror(msg);
        }
        
        $$ = creer_transition($1, $3, $5);
        free($1);
        free($3);
        free($5);
    }
    ;

%%

/* Function dyal erreur */
void yyerror(const char* msg) {
    fprintf(stderr, "ERREUR SYNTAXIQUE [ligne %d, col %d]: %s\n", 
            nb_lignes, nb_colonnes, msg);
}

/* Main function */
int main(int argc, char** argv) {
    // n7adro table des symboles
    table_symboles = creer_table_symboles();
    
    // nfet7o fichier
    if (argc > 1) {
        yyin = fopen(argv[1], "r");
        if (!yyin) {
            fprintf(stderr, "Erreur: Impossible d'ouvrir '%s'\n", argv[1]);
            return 1;
        }
    } else {
        yyin = fopen("exemple.txt", "r");
        if (!yyin) {
            fprintf(stderr, "Erreur: Impossible d'ouvrir exemple.txt\n");
            return 1;
        }
    }
    
    printf("=== Compilateur AFD - Analyse Complète ===\n\n");
    
    // ndirou parsing
    int resultat = yyparse();
    
    if (resultat == 0 && automate_courant) {
        printf("\n=== Compilation réussie! ===\n");
        afficher_automate(automate_courant);
        
        // naffichow table des symboles
        printf("\n=== Table des Symboles ===\n");
        afficher_table_symboles(table_symboles);
    } else {
        printf("\n=== Échec de la compilation ===\n");
    }
    
    // n9adhfo memory
    if (automate_courant) {
        liberer_automate(automate_courant);
    }
    liberer_table_symboles(table_symboles);
    
    fclose(yyin);
    return resultat;
}
