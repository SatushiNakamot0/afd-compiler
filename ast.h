/* AST - Abstract Syntax Tree
   Structure dyal l'arbre syntaxique bash nkhazno automate
*/

#ifndef AST_H
#define AST_H

// Liste dyal symboles (alphabet)
typedef struct ListeSymboles {
    char* symbole;
    struct ListeSymboles* suivant;
} ListeSymboles;

// Liste dyal états
typedef struct ListeEtats {
    char* nom;
    struct ListeEtats* suivant;
} ListeEtats;

// Transition wa7da: source --symbole--> destination
typedef struct Transition {
    char* etat_source;
    char* symbole;
    char* etat_dest;
    struct Transition* suivant;
} Transition;

// Liste dyal transitions
typedef struct ListeTransitions {
    Transition* tete;
    int compte;
} ListeTransitions;

// L'automate kaml - hadshi howa AST dyalna
typedef struct AutomateAST {
    char* nom;                    // ism automate
    ListeSymboles* alphabet;      // alphabet {a, b, c}
    ListeEtats* etats;            // états {q0, q1, ...}
    char* etat_initial;           // état initial
    ListeEtats* etats_finaux;     // états finaux
    ListeTransitions* transitions; // transitions
} AutomateAST;

// Functions bach ncreiw l structures
AutomateAST* creer_automate(char* nom);
void liberer_automate(AutomateAST* automate);

ListeSymboles* creer_liste_symboles();
void ajouter_symbole_liste(ListeSymboles* liste, char* symbole);
int compter_symboles(ListeSymboles* liste);

ListeEtats* creer_liste_etats();
void ajouter_etat(ListeEtats* liste, char* nom);
int compter_etats(ListeEtats* liste);

ListeTransitions* creer_liste_transitions();
void ajouter_transition(ListeTransitions* liste, Transition* t);
int compter_transitions(ListeTransitions* liste);

Transition* creer_transition(char* source, char* symbole, char* dest);

// Affichage
void afficher_automate(AutomateAST* automate);

#endif // AST_H
