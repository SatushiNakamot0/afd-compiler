%{
#include "def.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

extern int nb_colonne;
extern int yylineno;

Automate *automate_actuel = NULL;

/* Prototypes dyal fonctions auxiliaires */
Automate* initialiser_automate(char* nom);
void ajouter_symbole(char symbole);
void ajouter_etat(char* nom_etat);
void definir_initial(char* nom_etat);
void ajouter_final(char* nom_etat);
void ajouter_transition(char* src, char sym, char* dest);
int symbole_existe(char symbole);
int etat_existe(char* nom_etat);
int transition_existe(char* src, char sym);

/* Implementation dyal fonctions auxiliaires */

Automate* initialiser_automate(char* nom) {
    Automate* automate = (Automate*)malloc(sizeof(Automate));
    if (!automate) {
        fprintf(stderr, "Erreur : Échec d'allocation mémoire\n");
        exit(1);
    }
    
    automate->nom = strdup(nom);
    automate->alphabet = NULL;
    automate->nb_symboles = 0;
    automate->etats = NULL;
    automate->nb_etats = 0;
    automate->etat_initial = NULL;
    automate->etats_finaux = NULL;
    automate->nb_finaux = 0;
    automate->transitions = NULL;
    
    return automate;
}

void ajouter_symbole(char symbole) {
    if (!automate_actuel) return;
    
    // Verifier doublons
    for (int i = 0; i < automate_actuel->nb_symboles; i++) {
        if (automate_actuel->alphabet[i][0] == symbole) {
            return; // Rrmz deja kayyn
        }
    }
    
    // katzid rrmz
    automate_actuel->alphabet = (char**)realloc(
        automate_actuel->alphabet, 
        sizeof(char*) * (automate_actuel->nb_symboles + 1)
    );
    automate_actuel->alphabet[automate_actuel->nb_symboles] = (char*)malloc(2);
    automate_actuel->alphabet[automate_actuel->nb_symboles][0] = symbole;
    automate_actuel->alphabet[automate_actuel->nb_symboles][1] = '\0';
    automate_actuel->nb_symboles++;
}

void ajouter_etat(char* nom_etat) {
    if (!automate_actuel) return;
    
    // Verifier doublons
    for (int i = 0; i < automate_actuel->nb_etats; i++) {
        if (strcmp(automate_actuel->etats[i], nom_etat) == 0) {
            return; // L'etat deja kayyn
        }
    }
    
    // katzid l'etat
    automate_actuel->etats = (char**)realloc(
        automate_actuel->etats,
        sizeof(char*) * (automate_actuel->nb_etats + 1)
    );
    automate_actuel->etats[automate_actuel->nb_etats] = strdup(nom_etat);
    automate_actuel->nb_etats++;
}

int symbole_existe(char symbole) {
    if (!automate_actuel) return 0;
    
    for (int i = 0; i < automate_actuel->nb_symboles; i++) {
        if (automate_actuel->alphabet[i][0] == symbole) {
            return 1;
        }
    }
    return 0;
}

int etat_existe(char* nom_etat) {
    if (!automate_actuel) return 0;
    
    for (int i = 0; i < automate_actuel->nb_etats; i++) {
        if (strcmp(automate_actuel->etats[i], nom_etat) == 0) {
            return 1;
        }
    }
    return 0;
}

//Verifier determinisme
int transition_existe(char* src, char sym) {
    if (!automate_actuel) return 0;
    
    Transition* t = automate_actuel->transitions;
    while (t) {
        if (strcmp(t->source, src) == 0 && t->symbol == sym) {
            return 1; // Deja kayna transition mn had l'etat b had rrmz
        }
        t = t->next;
    }
    return 0;
}

void definir_initial(char* nom_etat) {
    if (!automate_actuel) return;
    
    // Verification semantique : l'etat khasso ykoun kayyn
    if (!etat_existe(nom_etat)) {
        fprintf(stderr, "Erreur semantique: Had l'etat '%s' ma-declarich f 'etats'.\n", nom_etat);
        exit(1);
    }
    
    automate_actuel->etat_initial = strdup(nom_etat);
}

void ajouter_final(char* nom_etat) {
    if (!automate_actuel) return;
    
    // Verification semantique : l'etat khasso ykoun kayyn
    if (!etat_existe(nom_etat)) {
        fprintf(stderr, "Erreur semantique: Had l'etat '%s' ma-declarich f 'etats'.\n", nom_etat);
        exit(1);
    }
    
    // Verifier doublons
    for (int i = 0; i < automate_actuel->nb_finaux; i++) {
        if (strcmp(automate_actuel->etats_finaux[i], nom_etat) == 0) {
            return; // Deja etat final
        }
    }
    
    // katzid l'etat final
    automate_actuel->etats_finaux = (char**)realloc(
        automate_actuel->etats_finaux,
        sizeof(char*) * (automate_actuel->nb_finaux + 1)
    );
    automate_actuel->etats_finaux[automate_actuel->nb_finaux] = strdup(nom_etat);
    automate_actuel->nb_finaux++;
}

void ajouter_transition(char* src, char sym, char* dest) {
    if (!automate_actuel) return;
    
    // Verification semantique : rrmz khasso ykoun f l'alphabet
    if (!symbole_existe(sym)) {
        fprintf(stderr, "Erreur semantique (Ligne %d, Col %d): Had rrmz '%c' ma-kaynch f l'alphabet!\n", 
                yylineno, nb_colonne, sym);
        exit(1);
    }
    
    // Verification semantique : l'etat source khasso ykoun kayyn
    if (!etat_existe(src)) {
        fprintf(stderr, "Erreur semantique: Had l'etat '%s' ma-declarich f 'etats'.\n", src);
        exit(1);
    }
    
    // Verification semantique : l'etat destination khasso ykoun kayyn
    if (!etat_existe(dest)) {
        fprintf(stderr, "Erreur semantique: Had l'etat '%s' ma-declarich f 'etats'.\n", dest);
        exit(1);
    }
    
    if (transition_existe(src, sym)) {
        fprintf(stderr, "Erreur Non-Deterministe: L'etat '%s' 3ando deja transition b rrmz '%c'! L'automate khasso ykoun Deterministe.\n", src, sym);
        exit(1);
    }
    
    // kansaweb transition jdida
    Transition* nouvelle_transition = (Transition*)malloc(sizeof(Transition));
    nouvelle_transition->source = strdup(src);
    nouvelle_transition->symbol = sym;
    nouvelle_transition->destination = strdup(dest);
    nouvelle_transition->next = NULL;
    
    // Zedtha l liste chainee
    if (!automate_actuel->transitions) {
        automate_actuel->transitions = nouvelle_transition;
    } else {
        Transition* temp = automate_actuel->transitions;
        while (temp->next) {
            temp = temp->next;
        }
        temp->next = nouvelle_transition;
    }
}


int est_etat_final(Automate *a, char *etat) {
    for (int i = 0; i < a->nb_finaux; i++) {
        if (strcmp(a->etats_finaux[i], etat) == 0) {
            return 1;
        }
    }
    return 0;
}

Transition* trouver_transition(Automate *a, char *etat_src, char symbole) {
    Transition* t = a->transitions;
    while (t) {
        if (strcmp(t->source, etat_src) == 0 && t->symbol == symbole) {
            return t;
        }
        t = t->next;
    }
    return NULL;
}


void executer_automate(Automate *a, char *mot) {
    if (!a || !a->etat_initial) {
        fprintf(stderr, "Erreur: L'automate machi complet.\n");
        return;
    }
    
    char *etat_courant = a->etat_initial;
    printf("\n--- Simulation dyal l'mot '%s' ---\n", mot);
    printf("Bdit mn l'etat: %s\n", etat_courant);
    
    for (int i = 0; mot[i] != '\0'; i++) {
        char symbole = mot[i];
        printf("  Qra rrmz '%c'... ", symbole);
        
        Transition* t = trouver_transition(a, etat_courant, symbole);
        if (!t) {
            printf("\n\nDommage... L'mot '%s' merfoud (Rejete).\n", mot);
            printf("Sebab: Ma-kaynach transition mn '%s' b rrmz '%c'.\n", etat_courant, symbole);
            return;
        }
        
        printf("-> %s\n", t->destination);
        etat_courant = t->destination;
    }
    
    // Chof wach wselna l etat final
    if (est_etat_final(a, etat_courant)) {
        printf("\nNadi! L'mot '%s' maqboule (Accepte).\n", mot);
        printf("Weselna l l'etat final: %s\n\n", etat_courant);
    } else {
        printf("\nDommage... L'mot '%s' merfoud (Rejete).\n", mot);
        printf("Weselna l '%s' li machi etat final.\n\n", etat_courant);
    }
}

void generer_dot(Automate *a) {
    if (!a) return;
    
    char filename[256];
    snprintf(filename, sizeof(filename), "%s.dot", a->nom);
    
    FILE *f = fopen(filename, "w");
    if (!f) {
        fprintf(stderr, "Erreur: Ma-qdertnach n7el fichier '%s'.\n", filename);
        return;
    }
    
    fprintf(f, "digraph %s {\n", a->nom);
    fprintf(f, "    rankdir=LR;\n");
    fprintf(f, "    node [shape=circle];\n\n");
    
    // Etat initial - flech mn berra
    if (a->etat_initial) {
        fprintf(f, "    start [shape=point];\n");
        fprintf(f, "    start -> %s;\n\n", a->etat_initial);
    }
    
    // Etats finaux - double cercle
    fprintf(f, "    node [shape=doublecircle];\n");
    for (int i = 0; i < a->nb_finaux; i++) {
        fprintf(f, "    %s;\n", a->etats_finaux[i]);
    }
    fprintf(f, "\n    node [shape=circle];\n\n");
    
    // Transitions
    Transition* t = a->transitions;
    while (t) {
        fprintf(f, "    %s -> %s [label=\"%c\"];\n", t->source, t->destination, t->symbol);
        t = t->next;
    }
    
    fprintf(f, "}\n");
    fclose(f);
    
    printf("Fichier Graphviz '%s' genere! Dir 'dot -Tpng %s -o %s.png' bach tchouf l'graphe.\n\n", 
           filename, filename, a->nom);
}

%}

%union {
    char *str;
    char c;
}

%token TOK_AUTOMATE TOK_ALPHABET TOK_ETATS TOK_INITIAL TOK_FINAUX TOK_TRANSITIONS TOK_VERIFIER
%token TOK_ARROW
%token <str> TOK_IDENTIFIER TOK_STRING
%token <c> TOK_CHAR

%type <str> identifier

%%

program:
    automate_def commandes_opt
    {
        printf("Nadi! L'automate '%s' mrigl (valide).\n", automate_actuel->nom);
        printf("Details:\n");
        printf(" - Nombre d'etats: %d\n", automate_actuel->nb_etats);
        printf(" - Taille de l'alphabet: %d\n", automate_actuel->nb_symboles);
        
        int nb_transitions = 0;
        Transition* t = automate_actuel->transitions;
        while (t) {
            nb_transitions++;
            t = t->next;
        }
        printf(" - Nombre de transitions: %d\n", nb_transitions);
        
        // Auto-generer fichier DOT
        generer_dot(automate_actuel);
    }
    ;

commandes_opt:
    /* vide */
    | commandes
    ;

commandes:
    commande
    | commandes commande
    ;

commande:
    TOK_VERIFIER TOK_STRING ';'
    {
        executer_automate(automate_actuel, $2);
        free($2);
    }
    ;

automate_def:
    TOK_AUTOMATE identifier '{' 
    {
        automate_actuel = initialiser_automate($2);
        printf("Bdit kan-analysi l'automate: %s...\n", $2);
    }
    sections '}'
    {
        free($2);
    }
    ;

identifier:
    TOK_IDENTIFIER { $$ = $1; }
    ;

sections:
    section
    | sections section
    ;

section:
    alphabet_section
    | etats_section
    | initial_section
    | finaux_section
    | transitions_section
    ;

alphabet_section:
    TOK_ALPHABET '=' '{' char_list '}' ';'
    ;

char_list:
    TOK_CHAR
    {
        ajouter_symbole($1);
    }
    | char_list ',' TOK_CHAR
    {
        ajouter_symbole($3);
    }
    ;

etats_section:
    TOK_ETATS '=' '{' identifier_list '}' ';'
    ;

identifier_list:
    identifier 
    { 
        ajouter_etat($1);
        free($1); 
    }
    | identifier_list ',' identifier 
    { 
        ajouter_etat($3);
        free($3); 
    }
    ;

initial_section:
    TOK_INITIAL '=' identifier ';'
    {
        definir_initial($3);
        free($3);
    }
    ;

finaux_section:
    TOK_FINAUX '=' '{' final_list '}' ';'
    ;

final_list:
    identifier
    {
        ajouter_final($1);
        free($1);
    }
    | final_list ',' identifier
    {
        ajouter_final($3);
        free($3);
    }
    ;

transitions_section:
    TOK_TRANSITIONS '=' '{' transition_list '}' ';'
    ;

transition_list:
    transition
    | transition_list transition
    ;

transition:
    identifier ':' TOK_CHAR TOK_ARROW identifier ';'
    {
        ajouter_transition($1, $3, $5);
        free($1);
        free($5);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erreur Syntaxique f la ligne %d, colonne %d: Kayn chi mochkil hna!\n", yylineno, nb_colonne);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror(argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = f;
    }
    
    printf("--- Mulakhass ---\n");
    if (yyparse() == 0) {
        printf("\n");
        printf("Smya: %s\n", automate_actuel->nom);
        printf("Etat Initial: %s\n", automate_actuel->etat_initial);
        printf("Etats Finaux: ");
        for (int i = 0; i < automate_actuel->nb_finaux; i++) {
            printf("%s", automate_actuel->etats_finaux[i]);
            if (i < automate_actuel->nb_finaux - 1) printf(", ");
        }
        printf("\n");
    }
    
    return 0;
}
