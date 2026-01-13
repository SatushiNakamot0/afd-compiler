/* Symbol Table - Jdawal ramouze
   Bach nkhazno identifiants (automates, états, symboles)
*/

#ifndef SYMBOL_TABLE_H
#define SYMBOL_TABLE_H

#include <stdbool.h>

// Types dyal symboles li kaynin
typedef enum {
    TYPE_AUTOMATE,   // ism automate
    TYPE_ETAT,       // ism etat
    TYPE_SYMBOLE     // symbole mn alphabet
} TypeSymbole;

// Structure dyal symbole wa7ed
typedef struct Symbole {
    char* nom;              // sm dyalo
    TypeSymbole type;       // chno howa
    int ligne_def;          // fin t3araf (ligne)
    struct Symbole* suivant; // li mora fih (liste chainée)
} Symbole;

// Table des symboles - hashtable b sa7
#define TAILLE_TABLE 256

typedef struct {
    Symbole* buckets[TAILLE_TABLE];  // array dyal linked lists
    int nb_symboles;                  // ch7al fihom
} SymbolTable;

// Functions bach nkhdem m3a table
SymbolTable* creer_table_symboles();
void liberer_table_symboles(SymbolTable* table);

// Ajout o recherche
bool ajouter_symbole(SymbolTable* table, const char* nom, TypeSymbole type, int ligne);
Symbole* chercher_symbole(SymbolTable* table, const char* nom);

// Affichage
void afficher_table_symboles(SymbolTable* table);

// Hash function
unsigned int hash(const char* str);

#endif // SYMBOL_TABLE_H
