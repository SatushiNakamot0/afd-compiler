#ifndef DEF_H
#define DEF_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure dyal transition wahda
// Matalan: "q0 : a -> q1"
typedef struct Transition {
    char *source;              // L'etat li jayy mnha (ex: "q0")
    char symbol;               // Rrmz dyal transition (ex: 'a')
    char *destination;         // L'etat li ghadi liha (ex: "q1")
    struct Transition *next;   // Pointer l transition li jaya (Liste chainee)
} Transition;

// Structure dyal l'automate kamla
typedef struct Automate {
    char *nom;                 // Smya dyal l'automate
    char **alphabet;           // Lista dyal rrmoz msmo7in
    int nb_symboles;           // 3dad dyal rrmoz f l'alphabet
    char **etats;              // Lista dyal etats li declarinhom
    int nb_etats;              // 3dad dyal etats
    char *etat_initial;        // L'etat li kabda biha
    char **etats_finaux;       // Lista dyal etats finaux
    int nb_finaux;             // 3dad dyal etats finaux
    Transition *transitions;   // Rras dyal liste chainee dyal transitions
} Automate;

// Pointeur global bach Parser ykoun 3ndo access l l'automate 
extern Automate *automate_actuel;

// Prototypes dyal fonctions avancees
void executer_automate(Automate *a, char *mot);
void generer_dot(Automate *a);
int est_etat_final(Automate *a, char *etat);
Transition* trouver_transition(Automate *a, char *etat_src, char symbole);

#endif

