# Makefile pour Compilateur AFD - Version Simplifiee TP2/TP3
# Yazid TAHIRI ALAOUI - ENSAH

CC = gcc
FLEX = flex
BISON = bison

CFLAGS = -Wall -g -I.

all: afd_compiler
	@echo ""
	@echo "Compilation terminee!"
	@echo "Executez: ./afd_compiler [fichier.txt]"
	@echo ""

afd_compiler: parser.tab.c lex.yy.c
	@echo "Compilation finale..."
	$(CC) $(CFLAGS) parser.tab.c lex.yy.c -o afd_compiler
	@echo "Compilateur AFD cree!"

parser.tab.c: parser.y
	@echo "Bison: Generation du parser..."
	$(BISON) -d parser.y

lex.yy.c: lexer.l parser.tab.h
	@echo "Flex: Generation du lexer..."
	$(FLEX) lexer.l

test: afd_compiler
	@echo "Test avec exemple.txt..."
	@echo ""
	./afd_compiler exemple.txt

clean:
	@echo "Nettoyage..."
	rm -f lex.yy.c parser.tab.c parser.tab.h *.o afd_compiler
	@echo "Nettoye!"

rebuild: clean all

help:
	@echo "   Makefile - Compilateur AFD              "
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
