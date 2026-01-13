#ifndef DEF_H
#define DEF_H

#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 1. Structure for a single transition
//    Example: "q0 : a -> q1"
typedef struct Transition {
    char *source;              // e.g., "q0"
    char symbol;               // e.g., 'a'
    char *destination;         // e.g., "q1"
    struct Transition *next;   // Pointer to the next transition (Linked List)
} Transition;

// 2. Structure for the whole Automaton
typedef struct Automaton {
    char *name;                // Name of the automaton
    char **alphabet;           // List of allowed symbols
    int alphabet_count;
    char **states;             // List of declared states
    int state_count;
    char *initial_state;       // The start state
    char **final_states;       // List of final states
    int final_count;
    Transition *transitions;   // Head of the linked list of transitions
} Automaton;

// Global pointer so the Parser can access the automaton being built
extern Automaton *current_automaton;

#endif
