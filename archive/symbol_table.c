/* Symbol Table Implementation - tanfid dyal jdawal ramouze */

#include "symbol_table.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// Hash function - bash n7asbo hash dyal string
unsigned int hash(const char* str) {
    unsigned int hash = 5381;
    int c;
    
    while ((c = *str++)) {
        hash = ((hash << 5) + hash) + c; // hash * 33 + c
    }
    
    return hash % TAILLE_TABLE;
}

// Création dyal table jdida
SymbolTable* creer_table_symboles() {
    SymbolTable* table = (SymbolTable*)malloc(sizeof(SymbolTable));
    if (!table) {
        fprintf(stderr, "Erreur: Allocation mémoire pour table\n");
        exit(1);
    }
    
    // n7aydo kolchi
    for (int i = 0; i < TAILLE_TABLE; i++) {
        table->buckets[i] = NULL;
    }
    table->nb_symboles = 0;
    
    return table;
}

// Libération dyal memory
void liberer_table_symboles(SymbolTable* table) {
    if (!table) return;
    
    // nmsho 3la kol bucket
    for (int i = 0; i < TAILLE_TABLE; i++) {
        Symbole* courant = table->buckets[i];
        while (courant) {
            Symbole* suivant = courant->suivant;
            free(courant->nom);
            free(courant);
            courant = suivant;
        }
    }
    
    free(table);
}

// Ajout dyal symbole jdid
bool ajouter_symbole(SymbolTable* table, const char* nom, TypeSymbole type, int ligne) {
    if (!table || !nom) return false;
    
    // nchofou wash deja kayn
    if (chercher_symbole(table, nom) != NULL) {
        return false; // deja mawjoud
    }
    
    // n7asbo hash
    unsigned int index = hash(nom);
    
    // ncreiw symbole jdid
    Symbole* nouveau = (Symbole*)malloc(sizeof(Symbole));
    if (!nouveau) {
        fprintf(stderr, "Erreur: Allocation mémoire pour symbole\n");
        return false;
    }
    
    nouveau->nom = strdup(nom);
    nouveau->type = type;
    nouveau->ligne_def = ligne;
    
    // nzidhom f ra8s dyal liste (front)
    nouveau->suivant = table->buckets[index];
    table->buckets[index] = nouveau;
    
    table->nb_symboles++;
    return true;
}

// Recherche dyal symbole
Symbole* chercher_symbole(SymbolTable* table, const char* nom) {
    if (!table || !nom) return NULL;
    
    unsigned int index = hash(nom);
    Symbole* courant = table->buckets[index];
    
    // nmsho f linked list
    while (courant) {
        if (strcmp(courant->nom, nom) == 0) {
            return courant; // lqinah!
        }
        courant = courant->suivant;
    }
    
    return NULL; // malqinach
}

// Affichage dyal table kamla
void afficher_table_symboles(SymbolTable* table) {
    if (!table) return;
    
    printf("Table contient %d symboles:\n", table->nb_symboles);
    printf("%-20s %-15s %-10s\n", "Nom", "Type", "Ligne");
    printf("------------------------------------------------\n");
    
    // nmshiw 3la kol bucket
    for (int i = 0; i < TAILLE_TABLE; i++) {
        Symbole* courant = table->buckets[i];
        while (courant) {
            const char* type_str;
            switch(courant->type) {
                case TYPE_AUTOMATE: type_str = "Automate"; break;
                case TYPE_ETAT:     type_str = "État"; break;
                case TYPE_SYMBOLE:  type_str = "Symbole"; break;
                default:            type_str = "Inconnu"; break;
            }
            
            printf("%-20s %-15s %-10d\n", 
                   courant->nom, type_str, courant->ligne_def);
            
            courant = courant->suivant;
        }
    }
}
