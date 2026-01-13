# Makefile pour Compilateur AFD - Version Simplifiee TP2/TP3
# Yazid TAHIRI ALAOUI - ENSAH

CC = gcc
FLEX = flex
BISON = bison

CFLAGS = -Wall -g -I.

# Target principal
all: afd_compiler
	@echo ""
	@echo "Compilation terminee!"
	@echo "Executez: ./afd_compiler [fichier.txt]"
	@echo ""

# Compilation du compilateur AFD
afd_compiler: parser.tab.c lex.yy.c
	@echo "Compilation finale..."
	$(CC) $(CFLAGS) parser.tab.c lex.yy.c -o afd_compiler
	@echo "Compilateur AFD cree!"

# Generation du parser avec Bison
parser.tab.c: parser.y
	@echo "Bison: Generation du parser..."
	$(BISON) -d parser.y

# Generation du lexer avec Flex
lex.yy.c: lexer.l parser.tab.h
	@echo "Flex: Generation du lexer..."
	$(FLEX) lexer.l

# Test avec le fichier exemple
test: afd_compiler
	@echo "Test avec exemple.txt..."
	@echo ""
	./afd_compiler exemple.txt

# Nettoyage
clean:
	@echo "Nettoyage..."
	rm -f lex.yy.c parser.tab.c parser.tab.h *.o afd_compiler
	@echo "Nettoye!"

# Rebuild
rebuild: clean all

# Aide
help:
	@echo "========================================================"
	@echo "   Makefile - Compilateur AFD (TP2/TP3)               "
	@echo "========================================================"
	@echo ""
	@echo "Cibles:"
	@echo "  make          - Compile le compilateur AFD"
	@echo "  make test     - Test avec exemple.txt"
	@echo "  make clean    - Nettoie fichiers generes"
	@echo "  make rebuild  - Clean + recompile"
	@echo ""
	@echo "Fichiers du projet:"
	@echo "  lexer.l    - Analyseur lexical (Flex)"
	@echo "  parser.y   - Analyseur syntaxique (Bison)"
	@echo "  def.h      - Definitions des structures DFA"
	@echo ""

.PHONY: all test clean rebuild help
