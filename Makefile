# Makefile pour Compilateur AFD
# Yazid TAHIRI ALAOUI - ENSAH

# Compilateurs o flags
CC = gcc
FLEX = flex
BISON = bison

# Flags dyal compilation
CFLAGS = -Wall -g -I.
LDFLAGS = -lfl

# Fichiers source
LEX_SRC = analyseur_enhanced.l
YACC_SRC = analyseur.y
C_SRCS = symbol_table.c ast.c simulateur.c

# Fichiers générés
LEX_GEN = lex.yy.c
YACC_GEN = analyseur.tab.c analyseur.tab.h

# Fichiers objet
OBJS = analyseur.tab.o lex.yy.o symbol_table.o ast.o simulateur.o

# Nom dyal executable
TARGET = compilateur_afd

# Règle par défaut - kolchi
all: $(TARGET)
	@echo "✅ Compilation terminée!"
	@echo "▶️  Exécutez: ./$(TARGET) [fichier.txt]"

# Règle bash ndirou l executable
$(TARGET): $(OBJS)
	@echo "🔗 Linking..."
	$(CC) $(CFLAGS) -o $@ $(OBJS) $(LDFLAGS)

# Génération dyal parser mn Bison
analyseur.tab.c analyseur.tab.h: $(YACC_SRC)
	@echo "🔨 Bison: Génération du parser..."
	$(BISON) -d $(YACC_SRC)

# Génération dyal lexer mn Flex
lex.yy.c: $(LEX_SRC) analyseur.tab.h
	@echo "🔨 Flex: Génération du lexer..."
	$(FLEX) $(LEX_SRC)

# Compilation dyal fichiers C
%.o: %.c
	@echo "📦 Compilation de $<..."
	$(CC) $(CFLAGS) -c $< -o $@

# Build simple (version originale sans parser)
simple: analyseur.l
	@echo "🔨 Build version simple (lexer only)..."
	$(FLEX) analyseur.l
	$(CC) $(CFLAGS) lex.yy.c -o analyseur_simple $(LDFLAGS)
	@echo "✅ Fait! Exécutez: ./analyseur_simple"

# Clean - n9adhfo fichiers générés
clean:
	@echo "🧹 Nettoyage..."
	rm -f $(OBJS) $(LEX_GEN) $(YACC_GEN) $(TARGET) analyseur_simple
	@echo "✅ Nettoyé!"

# Rebuild - clean + all
rebuild: clean all

# Test m3a exemple.txt
test: $(TARGET)
	@echo "🧪 Test avec exemple.txt..."
	./$(TARGET) exemple.txt

# Affichage dyal help
help:
	@echo "Makefile pour Compilateur AFD"
	@echo "=============================="
	@echo ""
	@echo "Commandes disponibles:"
	@echo "  make          - Compile tout (lexer + parser + simulator)"
	@echo "  make simple   - Compile version simple (lexer seul)"
	@echo "  make test     - Compile et teste avec exemple.txt"
	@echo "  make clean    - Supprime fichiers générés"
	@echo "  make rebuild  - Clean + recompile"
	@echo "  make help     - Affiche cette aide"
	@echo ""
	@echo "Utilisation:"
	@echo "  ./$(TARGET) [fichier.txt]"
	@echo "  ./analyseur_simple          (version simple)"

.PHONY: all clean rebuild test help simple
