#ifndef DEF_H
#define DEF_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Structure dyal transition wahda
// Matalan: "q0 : a -> q1"
typedef struct Transition {
    char *source;              // Mn fin jayin
    char symbol;      // Rrmz
    char *destination;         // Fin ghadin
    struct Transition *next;   // Liste chainee (attention pointeurs !!)
} Transition;

// Structure dyal l'automate
typedef struct Automate {
    char *nom; 
    char **alphabet;           // Tableau dynamique
    int nb_symboles;
    
    char **etats;
    int nb_etats;              // ch7al mn etat 3ndna
    
    char *etat_initial;
    
    char **etats_finaux;
    int nb_finaux;
    
    Transition *transitions;   // Rras dyal liste
} Automate;

// Pointeur global (bach ykoun accessible f parser.y)
extern Automate *automate_actuel;

/* Prototypes */
void executer_automate(Automate *a, char *mot);
void generer_dot(Automate *a);
int est_etat_final(Automate  *a, char *etat);
Transition* trouver_transition(Automate *a, char *etat_src, char symbole);


#endif
