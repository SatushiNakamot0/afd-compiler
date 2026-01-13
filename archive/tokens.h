/* Université Abdelmalek Essaadi - ENSAH
   Module : Théorie des langages et compilation
   TP2+ : Token Structure pour l'Analyseur
   
   Réalisé par : Yazid TAHIRI ALAOUI
   Filière : ID1
   
   NOTE: Token codes homa f analyseur.tab.h (generés par Bison automatically)
         Ma khassnach n3arfohom hna bash ma ykunsh conflict
*/

#ifndef TOKENS_H
#define TOKENS_H

// Structure bach nkhazno token info
// hadi ghadi tfidna bash n3arfo fin kayn token o chno kayn fih
typedef struct {
    int type;           // naw3 token (mn analyseur.tab.h)
    char* value;        // l value dyalo ila kan 3ndo (identifiant wla comment)
    int line;           // raqm satr
    int column;         // raqm 3amoud (amélioration jdida!)
} Token;

#endif // TOKENS_H
