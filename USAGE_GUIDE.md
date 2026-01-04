# Guide d'Utilisation - Compilateur AFD Enhanced

## 🚀 Installation des Prérequis

### Windows (avec MinGW/MSYS2)
```bash
# Installer MSYS2 puis:
pacman -S mingw-w64-x86_64-gcc
pacman -S flex bison
```

### Linux (Ubuntu/Debian)
```bash
sudo apt-get install gcc flex bison
```

### macOS
```bash
brew install flex bison gcc
```

## 📦 Compilation

### Version Complète (avec Parser et Simulator)
```bash
make
```

Ceci génère l'exécutable `compilateur_afd` qui inclut:
- Analyseur lexical avec tracking colonnes
- Analyseur syntaxique (parser)
- Analyse sémantique avec table des symboles
- Simulateur DFA pour vérification de mots

### Version Simple (Lexer uniquement)
```bash
make simple
```

Génère `analyseur_simple` - juste l'analyseur lexical original.

## 🎮 Utilisation

### 1. Analyser un fichier AFD
```bash
./compilateur_afd exemple.txt
```

### 2. Test rapide
```bash
make test
```

### 3. Mode interactif (après compilation)
Le compilateur lance automatiquement le mode interactif pour vérifier des mots.

## 📝 Exemple de Fichier

Créez `mon_automate.txt`:
```
automate MonDFA {
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

Puis exécutez:
```bash
./compilateur_afd mon_automate.txt
```

## 🔍 Vérification de Mots

Une fois le fichier compilé avec succès, vous pouvez vérifier des mots:
```
➤ Mot à vérifier: ab
🔍 Vérification du mot: "ab"
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
▶️  État initial: q0

   q0 --a--> q1
   q1 --b--> q_final

✅ ACCEPTÉ - État final: q_final
```

## 🧹 Nettoyage

```bash
make clean      # Supprime fichiers générés
make rebuild    # Clean + recompile
```

## 🐛 Débogage

### Erreurs de Compilation

**Problème**: `flex: command not found`
**Solution**: Installez flex/bison (voir section Installation)

**Problème**: `undefined reference to 'yywrap'`
**Solution**: Utilisez le flag `-lfl` lors de la compilation

### Erreurs d'Analyse

Le compilateur affiche maintenant les erreurs avec **ligne ET colonne**:
```
ERREUR a la ligne 5, colonne 12 : Caractère inconnu '&'
```

## 📚 Améliorations Implémentées

✅ **1. Suivi des colonnes** - Erreurs précises (ligne + colonne)
✅ **2. Codes de tokens** - Retour de tokens au lieu de printf
✅ **3. Gestion des chaînes** - Pattern `"..."` pour mots complets
✅ **4. Table des symboles** - Validation sémantique
✅ **5. Parser Bison** - Analyse syntaxique complète
✅ **6. Simulateur DFA** - Vérification de mots

## 🎯 Prochaines Étapes

- Optimisation de la table des symboles
- Export vers formats standards (DOT/GraphViz)
- Support pour automates non-déterministes (NFA)
- Interface graphique pour visualisation

---

**Auteur**: Yazid TAHIRI ALAOUI
**Cours**: Théorie des langages et compilation - ENSAH
