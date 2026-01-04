# 🤖 AFD Compiler

A **lexical analyzer** for a custom **AFD (Automate Fini Déterministe / Deterministic Finite Automaton)** description language, built with **Flex** for the Theory of Languages and Compilation course at **Université Abdelmalek Essaadi - ENSAH**.

[![Language](https://img.shields.io/badge/Language-C-blue.svg)](https://en.wikipedia.org/wiki/C_(programming_language))
[![Tool](https://img.shields.io/badge/Tool-Flex-orange.svg)](https://github.com/westes/flex)
[![License](https://img.shields.io/badge/License-MIT-green.svg)](LICENSE)

---

## 📖 Overview

This project implements a **lexical scanner** that tokenizes source code written in a custom domain-specific language (DSL) for defining deterministic finite automata. The language allows users to specify automata components including states, alphabets, transitions, and verification rules in a clean, human-readable syntax.

**Author**: Yazid TAHIRI ALAOUI  
---

## ✨ Features

- ✅ **Complete Lexical Analysis** - Tokenizes all language constructs
- ✅ **Error Detection** - Reports unknown characters with line numbers
- ✅ **Comment Support** - Handles single-line comments starting with `#`
- ✅ **Identifier Recognition** - Validates state and automaton names
- ✅ **Symbol Classification** - Distinguishes keywords, operators, and delimiters

---

## 🔤 Language Specification

### Keywords
| Keyword | Description |
|---------|-------------|
| `automate` | Define an automaton |
| `alphabet` | Specify input symbols |
| `etats` | Define states |
| `initial` | Set the initial state |
| `finaux` | Define accepting/final states |
| `transitions` | Define state transitions |
| `verifier` | Verify words (planned) |

### Symbols
| Symbol | Meaning |
|--------|---------|
| `{ }` | Braces for blocks/sets |
| `;` | Statement terminator |
| `,` | Element separator |
| `:` | Transition separator |
| `=` | Assignment operator |
| `->` | Transition arrow |
| `"` | Quotation marks |
| `#` | Comment prefix |

### Syntax Rules
- **Identifiers**: Must start with a letter, followed by letters or digits `[a-zA-Z][a-zA-Z0-9]*`
- **Comments**: Lines starting with `#` are ignored
- **Whitespace**: Spaces and tabs are ignored

---

## 📝 Example

Here's a sample automaton description (`exemple.txt`):

```
# Simple DFA example
automate MonAutomate1 { 
    alphabet = {a, b, c};
    etats = {q0, q1, q_final};
    
    initial = q0;
    finaux = {q_final};
    
    transitions = { 
        q0:a->q1;  
        q1:b->q_final; 
        q_final:c->q0; 
    };
}
```

This defines an automaton that:
- Accepts alphabet symbols: `a`, `b`, `c`
- Has states: `q0`, `q1`, `q_final`
- Starts at state `q0`
- Accepts at state `q_final`
- Transitions form a cycle: q0 →ᵃ q1 →ᵇ q_final →ᶜ q0

---

## 🚀 Getting Started

### Prerequisites
- **Flex** (Fast Lexical Analyzer)
- **GCC** (GNU Compiler Collection)

### Build Instructions

1. **Clone the repository**
   ```bash
   git clone https://github.com/SatushiNakamot0/afd-compiler.git
   cd afd-compiler
   ```

2. **Generate the lexer**
   ```bash
   flex analyseur.l
   ```

3. **Compile the generated C code**
   ```bash
   gcc lex.yy.c -lfl -o analyseur
   ```

4. **Run the analyzer**
   ```bash
   ./analyseur
   ```

   The program reads from `exemple.txt` by default and outputs token classifications.

### Expected Output

```
MOT_CLE : automate
IDENTIFIANT : MonAutomate1
SYMBOLE : {
MOT_CLE : alphabet
AFFECTATION : =
SYMBOLE : {
IDENTIFIANT : a
VIRGULE : ,
IDENTIFIANT : b
VIRGULE : ,
IDENTIFIANT : c
SYMBOLE : }
SYMBOLE : ;
...
```

---

## 📂 Project Structure

```
afd-compiler/
├── analyseur.l                      # Flex lexer specification (source)
├── lex.yy.c                         # Generated C code from Flex
├── analyseur.exe                    # Compiled executable
├── exemple.txt                      # Sample AFD description
├── README.md                        # This file
├── Propositions d'améliorations.txt # Improvement suggestions
└── resultat_commande.png            # Screenshot of execution
```

---

## 🎯 Development Roadmap

### Current Status
- ✅ **Phase 1: Lexical Analysis** (Complete)

### Planned Improvements

Based on the analysis documented in `Propositions d'améliorations.txt`:

1. **📍 Precise Error Positioning**
   - Add column tracking for errors
   - Display: `Error at line X, column Y`

2. **🔗 Parser Integration**
   - Return token codes instead of printing
   - Enable integration with Bison/Yacc parser
   - Define token codes: `AUTOMATE = 256`, etc.

3. **📜 Better String Handling**
   - Capture quoted words in a single token
   - Pattern: `"[a-z]+"`

4. **🗂️ Symbol Table**
   - Store identifiers (states, automaton names)
   - Enable semantic validation

5. **🔮 Future Phases**
   - Phase 2: Syntax Analysis (Bison parser)
   - Phase 3: Semantic Analysis
   - Phase 4: Automaton Simulation & Word Verification

---

## 🧪 Testing

To test with your own automaton:

1. Create a `.txt` file with your AFD description
2. Modify line 56 in `analyseur.l` to point to your file
3. Rebuild and run the analyzer

---

## 📚 Learning Resources

This project demonstrates concepts from:
- **Formal Languages** - Regular expressions, finite automata
- **Compiler Design** - Lexical analysis, tokenization
- **Flex/Lex** - Pattern matching, scanner generation

---

## 🤝 Contributing

This is an educational project, but suggestions and improvements are welcome! Feel free to:
- Open an issue for bugs or questions
- Submit a pull request with enhancements
- Share alternative implementations

---

## 📄 License

This project is open source and available for educational purposes.

---

## 👨‍💻 Author

**Yazid TAHIRI ALAOUI**  
Filière ID1 - ENSAH  
Université Abdelmalek Essaadi

---

## 🙏 Acknowledgments

- Course: Théorie des langages et compilation
- Institution: ENSAH - École Nationale des Sciences Appliquées d'Al Hoceima
- Tools: Flex (The Fast Lexical Analyzer)
