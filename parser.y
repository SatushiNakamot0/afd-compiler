%{
#include "def.h"
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

void yyerror(const char *s);
int yylex(void);

Automaton *current_automaton = NULL;

/* Helper Functions - Prototypes */
Automaton* init_automaton(char* name);
void add_symbol(char symbol);
void add_state(char* state_name);
void set_initial(char* state_name);
void add_final(char* state_name);
void add_transition(char* src, char sym, char* dest);
int symbol_exists(char symbol);
int state_exists(char* state_name);

/* Helper Functions - Implementation */

Automaton* init_automaton(char* name) {
    Automaton* automaton = (Automaton*)malloc(sizeof(Automaton));
    if (!automaton) {
        fprintf(stderr, "Error: Memory allocation failed\n");
        exit(1);
    }
    
    automaton->name = strdup(name);
    automaton->alphabet = NULL;
    automaton->alphabet_count = 0;
    automaton->states = NULL;
    automaton->state_count = 0;
    automaton->initial_state = NULL;
    automaton->final_states = NULL;
    automaton->final_count = 0;
    automaton->transitions = NULL;
    
    return automaton;
}

void add_symbol(char symbol) {
    if (!current_automaton) return;
    
    // Check for duplicates
    for (int i = 0; i < current_automaton->alphabet_count; i++) {
        if (current_automaton->alphabet[i][0] == symbol) {
            return; // Symbol already exists
        }
    }
    
    // Add symbol
    current_automaton->alphabet = (char**)realloc(
        current_automaton->alphabet, 
        sizeof(char*) * (current_automaton->alphabet_count + 1)
    );
    current_automaton->alphabet[current_automaton->alphabet_count] = (char*)malloc(2);
    current_automaton->alphabet[current_automaton->alphabet_count][0] = symbol;
    current_automaton->alphabet[current_automaton->alphabet_count][1] = '\0';
    current_automaton->alphabet_count++;
}

void add_state(char* state_name) {
    if (!current_automaton) return;
    
    // Check for duplicates
    for (int i = 0; i < current_automaton->state_count; i++) {
        if (strcmp(current_automaton->states[i], state_name) == 0) {
            return; // State already exists
        }
    }
    
    // Add state
    current_automaton->states = (char**)realloc(
        current_automaton->states,
        sizeof(char*) * (current_automaton->state_count + 1)
    );
    current_automaton->states[current_automaton->state_count] = strdup(state_name);
    current_automaton->state_count++;
}

int symbol_exists(char symbol) {
    if (!current_automaton) return 0;
    
    for (int i = 0; i < current_automaton->alphabet_count; i++) {
        if (current_automaton->alphabet[i][0] == symbol) {
            return 1;
        }
    }
    return 0;
}

int state_exists(char* state_name) {
    if (!current_automaton) return 0;
    
    for (int i = 0; i < current_automaton->state_count; i++) {
        if (strcmp(current_automaton->states[i], state_name) == 0) {
            return 1;
        }
    }
    return 0;
}

void set_initial(char* state_name) {
    if (!current_automaton) return;
    
    // Semantic check: Verify state exists
    if (!state_exists(state_name)) {
        fprintf(stderr, "Error: State '%s' not declared\n", state_name);
        exit(1);
    }
    
    current_automaton->initial_state = strdup(state_name);
    printf("Initial state set: %s\n", state_name);
}

void add_final(char* state_name) {
    if (!current_automaton) return;
    
    // Semantic check: Verify state exists
    if (!state_exists(state_name)) {
        fprintf(stderr, "Error: State '%s' not declared\n", state_name);
        exit(1);
    }
    
    // Check for duplicates
    for (int i = 0; i < current_automaton->final_count; i++) {
        if (strcmp(current_automaton->final_states[i], state_name) == 0) {
            return; // Already a final state
        }
    }
    
    // Add final state
    current_automaton->final_states = (char**)realloc(
        current_automaton->final_states,
        sizeof(char*) * (current_automaton->final_count + 1)
    );
    current_automaton->final_states[current_automaton->final_count] = strdup(state_name);
    current_automaton->final_count++;
}

void add_transition(char* src, char sym, char* dest) {
    if (!current_automaton) return;
    
    // Semantic check: Verify symbol exists in alphabet
    if (!symbol_exists(sym)) {
        fprintf(stderr, "Error: Symbol '%c' not declared in alphabet\n", sym);
        exit(1);
    }
    
    // Semantic check: Verify source state exists
    if (!state_exists(src)) {
        fprintf(stderr, "Error: State '%s' not declared\n", src);
        exit(1);
    }
    
    // Semantic check: Verify destination state exists
    if (!state_exists(dest)) {
        fprintf(stderr, "Error: State '%s' not declared\n", dest);
        exit(1);
    }
    
    // Create new transition
    Transition* new_transition = (Transition*)malloc(sizeof(Transition));
    new_transition->source = strdup(src);
    new_transition->symbol = sym;
    new_transition->destination = strdup(dest);
    new_transition->next = NULL;
    
    // Add to linked list
    if (!current_automaton->transitions) {
        current_automaton->transitions = new_transition;
    } else {
        Transition* temp = current_automaton->transitions;
        while (temp->next) {
            temp = temp->next;
        }
        temp->next = new_transition;
    }
    
    printf("Transition added: %s : %c -> %s\n", src, sym, dest);
}

%}

%union {
    char *str;
    char c;
}

%token TOK_AUTOMATE TOK_ALPHABET TOK_ETATS TOK_INITIAL TOK_FINAUX TOK_TRANSITIONS TOK_VERIFIER
%token TOK_ARROW
%token <str> TOK_IDENTIFIER TOK_STRING
%token <c> TOK_CHAR

%type <str> identifier

%%

program:
    automate_def
    {
        printf("\n✅ Automaton '%s' validated successfully!\n", current_automaton->name);
        printf("   States: %d, Alphabet: %d, Transitions: ", 
               current_automaton->state_count, 
               current_automaton->alphabet_count);
        
        int transition_count = 0;
        Transition* t = current_automaton->transitions;
        while (t) {
            transition_count++;
            t = t->next;
        }
        printf("%d\n", transition_count);
    }
    ;

automate_def:
    TOK_AUTOMATE identifier '{' 
    {
        current_automaton = init_automaton($2);
        printf("Parsing automaton: %s\n", $2);
    }
    sections '}'
    {
        free($2);
    }
    ;

identifier:
    TOK_IDENTIFIER { $$ = $1; }
    ;

sections:
    section
    | sections section
    ;

section:
    alphabet_section
    | etats_section
    | initial_section
    | finaux_section
    | transitions_section
    ;

alphabet_section:
    TOK_ALPHABET '=' '{' char_list '}' ';'
    ;

char_list:
    TOK_CHAR
    {
        add_symbol($1);
    }
    | char_list ',' TOK_CHAR
    {
        add_symbol($3);
    }
    ;

etats_section:
    TOK_ETATS '=' '{' identifier_list '}' ';'
    ;

identifier_list:
    identifier 
    { 
        add_state($1);
        free($1); 
    }
    | identifier_list ',' identifier 
    { 
        add_state($3);
        free($3); 
    }
    ;

initial_section:
    TOK_INITIAL '=' identifier ';'
    {
        set_initial($3);
        free($3);
    }
    ;

finaux_section:
    TOK_FINAUX '=' '{' final_list '}' ';'
    ;

final_list:
    identifier
    {
        add_final($1);
        free($1);
    }
    | final_list ',' identifier
    {
        add_final($3);
        free($3);
    }
    ;

transitions_section:
    TOK_TRANSITIONS '=' '{' transition_list '}' ';'
    ;

transition_list:
    transition
    | transition_list transition
    ;

transition:
    identifier ':' TOK_CHAR TOK_ARROW identifier ';'
    {
        add_transition($1, $3, $5);
        free($1);
        free($5);
    }
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Syntax error: %s\n", s);
}

int main(int argc, char **argv) {
    if (argc > 1) {
        FILE *f = fopen(argv[1], "r");
        if (!f) {
            perror(argv[1]);
            return 1;
        }
        extern FILE *yyin;
        yyin = f;
    }
    
    printf("🔍 Parsing DFA definition...\n\n");
    if (yyparse() == 0) {
        printf("\n📊 Summary:\n");
        printf("   Automaton Name: %s\n", current_automaton->name);
        printf("   Initial State: %s\n", current_automaton->initial_state);
        printf("   Final States: ");
        for (int i = 0; i < current_automaton->final_count; i++) {
            printf("%s", current_automaton->final_states[i]);
            if (i < current_automaton->final_count - 1) printf(", ");
        }
        printf("\n");
    }
    
    return 0;
}
