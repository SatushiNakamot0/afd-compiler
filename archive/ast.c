/* AST Implementation - tanfid dyal l'arbre syntaxique */

#include "ast.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

/* === Automate === */

AutomateAST* creer_automate(char* nom) {
    AutomateAST* automate = (AutomateAST*)malloc(sizeof(AutomateAST));
    if (!automate) {
        fprintf(stderr, "Erreur: Allocation mémoire pour automate\n");
        exit(1);
    }
    
    automate->nom = strdup(nom);
    automate->alphabet = NULL;
    automate->etats = NULL;
    automate->etat_initial = NULL;
    automate->etats_finaux = NULL;
    automate->transitions = NULL;
    
    return automate;
}

void liberer_automate(AutomateAST* automate) {
    if (!automate) return;
    
    // n9adhfo kolchi
    if (automate->nom) free(automate->nom);
    if (automate->etat_initial) free(automate->etat_initial);
    
    // nliberiw l listes
    // (simplified - f production code khasna nliberiw chaque élément)
    
    free(automate);
}

/* === Liste Symboles === */

ListeSymboles* creer_liste_symboles() {
    return NULL; // empty list
}

void ajouter_symbole_liste(ListeSymboles* liste, char* symbole) {
    ListeSymboles* nouveau = (ListeSymboles*)malloc(sizeof(ListeSymboles));
    nouveau->symbole = strdup(symbole);
    nouveau->suivant = NULL;
    
    if (!liste) {
        liste = nouveau;
    } else {
        // nmsho l l'axer
        ListeSymboles* courant = liste;
        while (courant->suivant) {
            courant = courant->suivant;
        }
        courant->suivant = nouveau;
    }
}

int compter_symboles(ListeSymboles* liste) {
    int compte = 0;
    while (liste) {
        compte++;
        liste = liste->suivant;
    }
    return compte;
}

/* === Liste États === */

ListeEtats* creer_liste_etats() {
    return NULL; // vide
}

void ajouter_etat(ListeEtats* liste, char* nom) {
    ListeEtats* nouveau = (ListeEtats*)malloc(sizeof(ListeEtats));
    nouveau->nom = strdup(nom);
    nouveau->suivant = NULL;
    
    if (!liste) {
        liste = nouveau;
    } else {
        ListeEtats* courant = liste;
        while (courant->suivant) {
            courant = courant->suivant;
        }
        courant->suivant = nouveau;
    }
}

int compter_etats(ListeEtats* liste) {
    int compte = 0;
    while (liste) {
        compte++;
        liste = liste->suivant;
    }
    return compte;
}

/* === Transitions === */

ListeTransitions* creer_liste_transitions() {
    ListeTransitions* liste = (ListeTransitions*)malloc(sizeof(ListeTransitions));
    liste->tete = NULL;
    liste->compte = 0;
    return liste;
}

Transition* creer_transition(char* source, char* symbole, char* dest) {
    Transition* t = (Transition*)malloc(sizeof(Transition));
    t->etat_source = strdup(source);
    t->symbole = strdup(symbole);
    t->etat_dest = strdup(dest);
    t->suivant = NULL;
    return t;
}

void ajouter_transition(ListeTransitions* liste, Transition* t) {
    if (!liste) return;
    
    t->suivant = liste->tete;
    liste->tete = t;
    liste->compte++;
}

int compter_transitions(ListeTransitions* liste) {
    return liste ? liste->compte : 0;
}

/* === Affichage === */

void afficher_automate(AutomateAST* automate) {
    if (!automate) return;
    
    printf("\n╔══════════════════════════════════════╗\n");
    printf("║   AUTOMATE: %-23s║\n", automate->nom);
    printf("╚══════════════════════════════════════╝\n\n");
    
    // Alphabet
    if (automate->alphabet) {
        printf("📋 Alphabet: {");
        ListeSymboles* s = automate->alphabet;
        while (s) {
            printf("%s", s->symbole);
            if (s->suivant) printf(", ");
            s = s->suivant;
        }
        printf("}\n");
    }
    
    // États
    if (automate->etats) {
        printf("🔵 États: {");
        ListeEtats* e = automate->etats;
        while (e) {
            printf("%s", e->nom);
            if (e->suivant) printf(", ");
            e = e->suivant;
        }
        printf("}\n");
    }
    
    // Initial
    if (automate->etat_initial) {
        printf("▶️  État initial: %s\n", automate->etat_initial);
    }
    
    // Finaux
    if (automate->etats_finaux) {
        printf("🎯 États finaux: {");
        ListeEtats* e = automate->etats_finaux;
        while (e) {
            printf("%s", e->nom);
            if (e->suivant) printf(", ");
            e = e->suivant;
        }
        printf("}\n");
    }
    
    // Transitions
    if (automate->transitions && automate->transitions->tete) {
        printf("\n🔀 Transitions:\n");
        Transition* t = automate->transitions->tete;
        while (t) {
            printf("   %s --%s--> %s\n", t->etat_source, t->symbole, t->etat_dest);
            t = t->suivant;
        }
    }
    
    printf("\n");
}
