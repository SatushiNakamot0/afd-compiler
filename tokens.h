/* Université Abdelmalek Essaadi - ENSAH
   Module : Théorie des langages et compilation
   TP2+ : Token Definitions pour l'Analyseur
   
   Réalisé par : Yazid TAHIRI ALAOUI
   Filière : ID1
*/

#ifndef TOKENS_H
#define TOKENS_H

// Token codes li ghadi nrj3o mn lexer l parser
// hadi l codes dyalna bach n3arfo chkoun token

// Keywords - kalmat khas
#define TOK_AUTOMATE    256
#define TOK_ALPHABET    257
#define TOK_ETATS       258
#define TOK_INITIAL     259
#define TOK_FINAUX      260
#define TOK_TRANSITIONS 261
#define TOK_VERIFIER    262

// Symbols - ramouze
#define TOK_LBRACE      270  // {
#define TOK_RBRACE      271  // }
#define TOK_SEMICOLON   272  // ;
#define TOK_COMMA       273  // ,
#define TOK_COLON       274  // :
#define TOK_EQUAL       275  // =
#define TOK_ARROW       276  // ->
#define TOK_QUOTE       277  // "

// Lexical elements - 3anasir mo3jamiya
#define TOK_IDENTIFIER  280
#define TOK_COMMENT     281
#define TOK_STRING      282  // li ghanzidhom f l'amélioration

// Special tokens
#define TOK_ERROR       290
#define TOK_EOF         0

// Structure bach nkhazno token info
// hadi ghadi tfidna bash n3arfo fin kayn token o chno kayn fih
typedef struct {
    int type;           // naw3 token
    char* value;        // l value dyalo ila kan 3ndo (identifiant wla comment)
    int line;           // raqm satr
    int column;         // raqm 3amoud (amélioration jdida!)
} Token;

#endif // TOKENS_H
