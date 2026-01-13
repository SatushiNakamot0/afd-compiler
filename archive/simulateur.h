/* Simulateur d'Automate - bash nsimuliw DFA o nverifiw klmat
   hada howa l core dyal verification
*/

#ifndef SIMULATEUR_H
#define SIMULATEUR_H

#include "ast.h"
#include <stdbool.h>

// Structure dyal DFA simulateur
typedef struct {
    AutomateAST* automate;     // l'automate li ghadi nsimuliwh
    char* etat_courant;        // l'état fin 7na daba
    bool accepte;              // wash dkhalna f état final
} Simulateur;

// Functions principales
Simulateur* creer_simulateur(AutomateAST* automate);
void liberer_simulateur(Simulateur* sim);

// Simulation
void reinitialiser(Simulateur* sim);
bool lire_symbole(Simulateur* sim, char symbole);
bool verifier_mot(Simulateur* sim, const char* mot);

// Helpers
char* trouver_transition(AutomateAST* automate, const char* etat, char symbole);
bool est_etat_final(AutomateAST* automate, const char* etat);

// Affichage
void afficher_etat_simulateur(Simulateur* sim);

// Mode interactif
void mode_interactif(Simulateur* sim);

#endif // SIMULATEUR_H
