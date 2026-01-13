/* Simulateur Implementation - tanfid dyal simulation */

#include "simulateur.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* Création dyal simulateur jdid */
Simulateur* creer_simulateur(AutomateAST* automate) {
    if (!automate) {
        fprintf(stderr, "Erreur: Automate NULL\n");
        return NULL;
    }
    
    Simulateur* sim = (Simulateur*)malloc(sizeof(Simulateur));
    if (!sim) {
        fprintf(stderr, "Erreur: Allocation mémoire pour simulateur\n");
        return NULL;
    }
    
    sim->automate = automate;
    sim->etat_courant = NULL;
    sim->accepte = false;
    
    // nbd2o mn état initial
    reinitialiser(sim);
    
    return sim;
}

void liberer_simulateur(Simulateur* sim) {
    if (!sim) return;
    // ma kanchofoch automate 7it mashi dyalna
    free(sim);
}

/* Réinitialisation - nrj3o l état initial */
void reinitialiser(Simulateur* sim) {
    if (!sim || !sim->automate) return;
    
    sim->etat_courant = sim->automate->etat_initial;
    sim->accepte = est_etat_final(sim->automate, sim->etat_courant);
}

/* Helper: Chercher transition */
char* trouver_transition(AutomateAST* automate, const char* etat, char symbole) {
    if (!automate || !automate->transitions) return NULL;
    
    Transition* t = automate->transitions->tete;
    while (t) {
        // nchofou wash had transition hiya li bghina
        if (strcmp(t->etat_source, etat) == 0 && 
            t->symbole[0] == symbole) {
            return t->etat_dest;
        }
        t = t->suivant;
    }
    
    return NULL; // ma lqinach transition
}

/* Helper: Vérifier wash état final */
bool est_etat_final(AutomateAST* automate, const char* etat) {
    if (!automate || !etat) return false;
    
    ListeEtats* finaux = automate->etats_finaux;
    while (finaux) {
        if (strcmp(finaux->nom, etat) == 0) {
            return true; // yep, final!
        }
        finaux = finaux->suivant;
    }
    
    return false;
}

/* Lire symbole wa7ed o nzido l état */
bool lire_symbole(Simulateur* sim, char symbole) {
    if (!sim || !sim->etat_courant) return false;
    
    // nchofou transition
    char* nouvel_etat = trouver_transition(sim->automate, sim->etat_courant, symbole);
    
    if (!nouvel_etat) {
        printf("❌ Pas de transition pour '%c' depuis %s\n", 
               symbole, sim->etat_courant);
        return false; // ma kaynach transition
    }
    
    // nzido l état jdid
    printf("   %s --%c--> %s\n", sim->etat_courant, symbole, nouvel_etat);
    sim->etat_courant = nouvel_etat;
    sim->accepte = est_etat_final(sim->automate, sim->etat_courant);
    
    return true;
}

/* Vérifier mot kaml */
bool verifier_mot(Simulateur* sim, const char* mot) {
    if (!sim || !mot) return false;
    
    printf("\n🔍 Vérification du mot: \"%s\"\n", mot);
    printf("━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━\n");
    
    // nbd2o mn état initial
    reinitialiser(sim);
    printf("▶️  État initial: %s\n\n", sim->etat_courant);
    
    // nqraw kol symbole
    for (int i = 0; mot[i] != '\0'; i++) {
        if (!lire_symbole(sim, mot[i])) {
            printf("\n❌ REJETÉ - Transition invalide\n");
            return false;
        }
    }
    
    // nchofou wash wsalna l état final
    if (sim->accepte) {
        printf("\n✅ ACCEPTÉ - État final: %s\n", sim->etat_courant);
        return true;
    } else {
        printf("\n❌ REJETÉ - État %s n'est pas final\n", sim->etat_courant);
        return false;
    }
}

/* Affichage dyal état */
void afficher_etat_simulateur(Simulateur* sim) {
    if (!sim) return;
    
    printf("État actuel: %s", sim->etat_courant);
    if (sim->accepte) {
        printf(" (FINAL ✓)");
    }
    printf("\n");
}

/* Mode interactif - bash l user yverifiyi klmat */
void mode_interactif(Simulateur* sim) {
    if (!sim) return;
    
    printf("\n╔═══════════════════════════════════════╗\n");
    printf("║   MODE VÉRIFICATION INTERACTIF       ║\n");
    printf("╚═══════════════════════════════════════╝\n");
    printf("\nEntrez 'quit' pour quitter\n\n");
    
    char mot[256];
    while (1) {
        printf("➤ Mot à vérifier: ");
        if (scanf("%255s", mot) != 1) break;
        
        if (strcmp(mot, "quit") == 0) {
            printf("👋 Au revoir!\n");
            break;
        }
        
        verifier_mot(sim, mot);
        printf("\n");
    }
}
