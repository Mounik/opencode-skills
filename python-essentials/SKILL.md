---
name: python-essentials
description: Guide Python de référence avec bonnes pratiques, patterns modernes et exemples vérifiés via Context7
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: development
---

# Python Essentiels

## Ce que je fais

- Guide complet pour le développement Python moderne avec bonnes pratiques et patterns
- Structure de projet moderne avec pyproject.toml
- Utilisation de uv (gestionnaire de paquets ultra-rapide) pour remplacer pip, venv, poetry
- Syntaxe fondamentale et Python moderne (3.12+)
- Collections, fonctions, classes et POO
- Tests avec pytest
- Outils de qualité (black, ruff, mypy)
- Gestion d'erreurs et de fichiers

## Quand m'utiliser

- Démarrer un nouveau projet Python
- Apprendre Python depuis le début
- Mettre à jour des connaissances Python (Python 3.12+)
- Implémenter des patterns Python modernes
- Optimiser du code Python existant

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière documentation Python et les frameworks courants
2. Suivez les bonnes pratiques PEP 8 et la structure de projet moderne
3. Utilisez les f-strings pour le formatage de strings (Python 3.6+)
4. Préférez les type hints pour la clarté du code
5. Utilisez les gestionnaires de contexte (`with`) pour les ressources
6. Préférez les compréhensions de listes/dict/set pour la lisibilité
7. Utilisez `pathlib` au lieu de `os.path` pour la manipulation de chemins
8. **Utilisez `uv` (Astral) pour la gestion des environnements virtuels et des dépendances** - remplace pip, venv, poetry, et pip-tools avec une performance 10-100x supérieure
9. Gérez les dépendances avec `pyproject.toml` (PEP 621) plutôt que `requirements.txt`

## Installation

### Linux/macOS

```bash
# Vérifier si Python est installé
python3 --version

# Installation Ubuntu/Debian
sudo apt update
sudo apt install python3 python3-pip python3-venv

# Installation macOS via Homebrew
brew install python
```

### Windows

```powershell
# Télécharger depuis python.org
# Ou via winget
winget install --id Python.Python.3.12
```

## UV - Gestionnaire de Paquets et Projets (Recommandé)

**uv** est un gestionnaire de paquets et de projets Python ultra-rapide écrit en Rust par Astral. Il remplace pip, venv, poetry, pip-tools et pipx avec des performances 10-100x supérieures.

### Installation de uv

```bash
# Linux/macOS
curl -LsSf https://astral.sh/uv/install.sh | sh

# Windows PowerShell
powershell -ExecutionPolicy Bypass -c "irm https://astral.sh/uv/install.ps1 | iex"

# Vérifier l'installation
uv --version
```

### Créer un Environnement Virtuel avec uv

```bash
# Créer un environnement virtuel (télécharge Python automatiquement si nécessaire)
uv venv

# Créer avec une version spécifique de Python
uv venv --python 3.12

# Créer avec pip inclus (pour compatibilité)
uv venv --seed

# Activer l'environnement (Linux/macOS)
source .venv/bin/activate

# Activer l'environnement (Windows)
.venv\Scripts\activate

# Désactiver
deactivate
```

### Gestion des Dépendances avec uv

```bash
# Installer un paquet
uv pip install requests

# Installer plusieurs paquets
uv pip install flask ruff pytest

# Installer avec contraintes de version
uv pip install "requests>=2.31.0"
uv pip install "requests==2.31.0"

# Installer depuis un fichier requirements
uv pip install -r requirements.txt

# Générer un fichier requirements.lock
uv pip freeze > requirements.lock
```

### Gestion de Projet avec uv

#### Initialiser un Projet

```bash
# Créer un nouveau projet applicatif
uv init mon-projet
cd mon-projet

# Créer un projet packagable (bibliothèque)
uv init --lib ma-bibliothèque
```

Cela crée :
- `pyproject.toml` - Configuration du projet
- `README.md` - Documentation
- `.python-version` - Version de Python requise
- `main.py` ou `src/` - Code source initial

#### Ajouter des Dépendances

```bash
# Ajouter une dépendance de production
uv add requests

# Ajouter avec contrainte de version
uv add "requests>=2.31.0"

# Ajouter depuis un dépôt Git
uv add "httpx @ git+https://github.com/encode/httpx"

# Ajouter une dépendance de développement
uv add --dev pytest
uv add --dev black ruff mypy

# Ajouter des dépendances optionnelles
uv add --optional web flask
uv add --optional db sqlalchemy

# Ajouter depuis un fichier requirements
uv add -r requirements.txt
```

#### Synchroniser et Exécuter

```bash
# Synchroniser les dépendances (crée/màj le lockfile)
uv sync

# Exécuter un script Python
uv run main.py

# Exécuter une commande dans l'environnement
uv run -- flask run -p 3000

# Exécuter avec des arguments
uv run python -c "print('Hello World')"
```

### Gestion des Outils Globaux

```bash
# Installer un outil globalement
uv tool install ruff

# Installer une version spécifique
uv tool install ruff@0.6.0

# Exécuter un outil sans l'installer (uvx)
uvx ruff check .
uvx black --check .

# Lister les outils installés
uv tool list

# Mettre à jour un outil
uv tool upgrade ruff

# Désinstaller un outil
uv tool uninstall ruff
```

### Gestion du Cache

```bash
# Voir le répertoire de cache
uv cache dir

# Nettoyer le cache
uv cache clean

# Voir l'utilisation du cache
uv cache prune
```

### Scripts avec Dépendances Inline

```python
# main.py
# /// script
# dependencies = ["requests>=2.31.0", "rich"]
# ///

import requests
from rich import print

response = requests.get("https://api.github.com")
print(f"Status: {response.status_code}")
```

```bash
# Exécuter le script (uv installe automatiquement les dépendances)
uv run main.py

# Créer un lockfile pour le script
uv lock --script main.py
```

### Migration depuis pip/venv

```bash
# Si vous avez un requirements.txt existant
uv venv
uv pip install -r requirements.txt

# Pour créer un projet uv structuré
uv init
# Puis ajoutez vos dépendances :
uv add $(cat requirements.txt)
```

### Méthode Traditionnelle (Fallback)

Si uv n'est pas disponible :

```bash
# Créer l'environnement avec venv
python3 -m venv .venv

# Activer (Linux/macOS)
source .venv/bin/activate

# Activer (Windows PowerShell)
.venv\Scripts\Activate.ps1

# Installer avec pip
pip install -r requirements.txt

# Désactiver
deactivate
```

## Structure de Projet Moderne

```
mon-projet/
├── pyproject.toml          # Configuration du projet (PEP 621)
├── README.md               # Documentation
├── LICENSE                 # Licence du projet
├── .gitignore              # Fichiers à ignorer par Git
├── src/                    # Code source
│   └── mon_projet/
│       ├── __init__.py
│       ├── module1.py
│       └── module2.py
├── tests/                  # Tests
│   ├── __init__.py
│   ├── test_module1.py
│   └── test_module2.py
├── docs/                   # Documentation
└── scripts/                # Scripts utilitaires
```

## Fichier pyproject.toml

Le fichier `pyproject.toml` est le cœur de la configuration du projet. Avec **uv**, il est généré automatiquement et géré via les commandes `uv add`, `uv remove`, etc.

### Structure avec uv

Quand vous utilisez `uv init`, le fichier suivant est créé :

```toml
[project]
name = "mon-projet"
version = "0.1.0"
description = "Description du projet"
readme = "README.md"
requires-python = ">=3.10"
dependencies = []

[project.optional-dependencies]
dev = []
web = []

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=7.0.0",
    "ruff>=0.1.0",
    "mypy>=1.0.0",
]

[tool.uv.sources]
# Sources personnalisées pour les dépendances
# httpx = { git = "https://github.com/encode/httpx" }

[tool.black]
line-length = 88
target-version = ['py310', 'py311', 'py312']

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]

[tool.mypy]
python_version = "3.10"
strict = true

[tool.pytest.ini_options]
testpaths = ["tests"]
addopts = "-v --tb=short"
```

### Fichiers générés par uv

```
mon-projet/
├── pyproject.toml          # Configuration du projet
├── uv.lock                 # Verrouillage des versions (commité!)
├── .python-version         # Version Python requise
├── .venv/                  # Environnement virtuel (gitignored)
└── ...
```

**Important** :
- `uv.lock` : Fichier de verrouillage **à committer** dans Git pour garantir la reproductibilité
- `.venv/` : Répertoire de l'environnement virtuel, **à ajouter dans .gitignore**
- Utilisez `uv sync` pour synchroniser les dépendances après un `git clone`

### Exemple Complet avec Dépendances

```toml
[project]
name = "mon-api"
version = "0.1.0"
description = "API REST moderne"
readme = "README.md"
license = {text = "MIT"}
requires-python = ">=3.11"
dependencies = [
    "fastapi>=0.104.0",
    "uvicorn[standard]>=0.24.0",
    "pydantic>=2.5.0",
    "httpx>=0.25.0",
]

[project.optional-dependencies]
dev = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.21.0",
    "pytest-cov>=4.1.0",
    "ruff>=0.1.6",
    "mypy>=1.7.0",
]

[project.scripts]
mon-api = "mon_api.main:main"

[build-system]
requires = ["hatchling"]
build-backend = "hatchling.build"

[tool.uv]
dev-dependencies = [
    "pytest>=7.4.0",
    "pytest-asyncio>=0.21.0",
    "pytest-cov>=4.1.0",
]

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "UP", "B", "C4", "SIM"]
ignore = ["E501"]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
```

### Fichier .gitignore Recommandé

```gitignore
# Python
__pycache__/
*.py[cod]
*$py.class
*.so
.Python

# Environnement virtuel (uv)
.venv/
venv/
ENV/
env/

# Distribution / Packaging
dist/
build/
*.egg-info/
*.egg

# uv
# (pas besoin d'ignorer uv.lock - il doit être commité!)

# Tests
.pytest_cache/
.coverage
htmlcov/

# IDE
.vscode/
.idea/
*.swp
*.swo
*~

# OS
.DS_Store
Thumbs.db
```

## Syntaxe Fondamentale

### Variables et Types

```python
# Variables (snake_case convention)
nom_utilisateur = "Alice"
age = 30
pi = 3.14159
est_actif = True

# Types de base
entier: int = 42
flottant: float = 3.14
chaine: str = "Hello"
booléen: bool = True
nul: None = None

# Types composés
liste: list[int] = [1, 2, 3, 4, 5]
dictionnaire: dict[str, int] = {"a": 1, "b": 2}
ensemble: set[int] = {1, 2, 3}
tuple_immutable: tuple[int, str] = (1, "deux")
```

### Strings et F-strings

```python
# F-strings (Python 3.6+) - RECOMMANDÉ
nom = "Alice"
age = 30
message = f"Bonjour {nom}, vous avez {age} ans"

# Expressions dans les f-strings
prix = 19.99
total = f"Prix TTC: {prix * 1.20:.2f} €"

# Méthodes utiles
texte = "  Python est génial  "
texte.strip()           # "Python est génial"
texte.lower()           # " python est génial  "
texte.upper()           # "  PYTHON EST GÉNIAL  "
texte.replace("génial", "super")  # "  Python est super  "

# Vérification
texte.startswith("Py")  # False (à cause des espaces)
texte.strip().startswith("Py")  # True
"Python" in texte       # True
```

### Structures de Contrôle

```python
# Conditions
age = 25

if age < 13:
    categorie = "Enfant"
elif age < 20:
    categorie = "Adolescent"
elif age < 65:
    categorie = "Adulte"
else:
    categorie = "Senior"

# Opérateur ternaire
statut = "Majeur" if age >= 18 else "Mineur"

# Match/Case (Python 3.10+)
def traiter_commande(commande: str) -> str:
    match commande.split():
        case ["quit"]:
            return "Au revoir"
        case ["load", fichier]:
            return f"Chargement de {fichier}"
        case ["save", fichier]:
            return f"Sauvegarde dans {fichier}"
        case _:
            return "Commande inconnue"

# Boucle for
for i in range(5):           # 0, 1, 2, 3, 4
    print(i)

fruits = ["pomme", "banane", "cerise"]
for fruit in fruits:
    print(fruit)

# Boucle while
compteur = 0
while compteur < 5:
    print(compteur)
    compteur += 1

# enumerate() pour index + valeur
for index, fruit in enumerate(fruits):
    print(f"{index}: {fruit}")

# zip() pour itérer sur plusieurs listes
noms = ["Alice", "Bob", "Charlie"]
ages = [25, 30, 35]
for nom, age in zip(noms, ages):
    print(f"{nom} a {age} ans")

# Break et continue
for nombre in range(10):
    if nombre == 3:
        continue        # Skip 3
    if nombre == 7:
        break           # Stop à 7
    print(nombre)
```

## Collections

### Listes

```python
# Création
liste_vide = []
nombres = [1, 2, 3, 4, 5]
mixte = [1, "deux", 3.0, True]

# Méthodes
nombres.append(6)           # Ajoute à la fin
nombres.insert(0, 0)        # Insère au début
nombres.extend([7, 8, 9])   # Étend avec une autre liste
dernier = nombres.pop()     # Retire et retourne le dernier
premier = nombres.pop(0)    # Retire et retourne le premier
nombres.remove(3)           # Retire la première occurrence
index = nombres.index(4)    # Trouve l'index
compte = nombres.count(2)   # Compte les occurrences
nombres.sort()              # Trie en place
nombres.reverse()           # Inverse en place
nombres.clear()             # Vide la liste

# Compréhensions de listes (recommandé)
carres = [x**2 for x in range(10)]
pairs = [x for x in range(20) if x % 2 == 0]

# Slicing
nombres = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
nombres[2:5]       # [2, 3, 4]
nombres[:3]        # [0, 1, 2]
nombres[7:]        # [7, 8, 9]
nombres[::2]       # [0, 2, 4, 6, 8] (tous les 2)
nombres[::-1]      # [9, 8, 7, ...] (inversé)
```

### Dictionnaires

```python
# Création
vide = {}
personne = {
    "nom": "Alice",
    "age": 30,
    "ville": "Paris"
}

# Accès
nom = personne["nom"]
age = personne.get("age", 0)           # Avec valeur par défaut

# Modification
personne["email"] = "alice@example.com"  # Ajoute
personne["age"] = 31                      # Modifie
del personne["ville"]                     # Supprime

# Méthodes
personne.keys()       # dict_keys(['nom', 'age', 'email'])
personne.values()     # dict_values(['Alice', 31, 'alice@example.com'])
personne.items()      # dict_items([('nom', 'Alice'), ...])

# Compréhension de dict
carres = {x: x**2 for x in range(5)}
# {0: 0, 1: 1, 2: 4, 3: 9, 4: 16}

# Fusionner dicts (Python 3.9+)
defauts = {"theme": "sombre", "langue": "fr"}
config = {**defauts, "langue": "en"}
# {"theme": "sombre", "langue": "en"}

# dict() avec compréhension
resultats = {nom: len(nom) for nom in ["Alice", "Bob", "Charlie"]}
```

### Sets

```python
# Création
ensemble_vide = set()  # PAS {} (qui crée un dict)
nombres = {1, 2, 3, 4, 5}

# Opérations
nombres.add(6)
nombres.remove(3)       # Erreur si existe pas
nombres.discard(10)     # Silencieux si existe pas

# Opérations ensemblistes
a = {1, 2, 3, 4}
b = {3, 4, 5, 6}

a | b       # Union: {1, 2, 3, 4, 5, 6}
a & b       # Intersection: {3, 4}
a - b       # Différence: {1, 2}
a ^ b       # Différence symétrique: {1, 2, 5, 6}

# Éliminer doublons
doublons = [1, 2, 2, 3, 3]
unique = list(set(doublons))  # [1, 2, 3]
```

## Fonctions

### Définition de Fonctions

```python
# Fonction simple
def saluer(nom: str) -> str:
    """Retourne un message de salutation."""
    return f"Bonjour, {nom} !"

# Fonction avec paramètres par défaut
def creer_utilisateur(
    nom: str,
    email: str,
    actif: bool = True,
    role: str = "user"
) -> dict:
    """Crée un dictionnaire utilisateur."""
    return {
        "nom": nom,
        "email": email,
        "actif": actif,
        "role": role
    }

# Appel
utilisateur = creer_utilisateur("Alice", "alice@example.com")
admin = creer_utilisateur("Bob", "bob@example.com", role="admin")

# *args et **kwargs
def fonction_flexible(*args: int, **kwargs: str) -> None:
    """Accepte arguments positionnels et nommés variables."""
    print(f"Args: {args}")
    print(f"Kwargs: {kwargs}")

fonction_flexible(1, 2, 3, nom="Alice", ville="Paris")
```

### Générateurs

```python
# Fonction génératrice
def fibonacci(n: int):
    """Génère les n premiers nombres de Fibonacci."""
    a, b = 0, 1
    for _ in range(n):
        yield a
        a, b = b, a + b

# Utilisation
for nombre in fibonacci(10):
    print(nombre)

# Expression génératrice (parenthèses)
carres = (x**2 for x in range(100000))  # Économique en mémoire

# Conversion
liste_carres = list(carres)
```

## Classes et POO

### Classe de Base

```python
from dataclasses import dataclass
from typing import Optional

class Personne:
    """Représente une personne avec nom et âge."""
    
    # Attribut de classe
    espece = "Homo sapiens"
    
    def __init__(self, nom: str, age: int):
        """Initialise une personne."""
        self.nom = nom          # Attribut d'instance
        self._age = age         # Attribut "protégé" (convention)
        self.__id = id(self)    # Attribut privé (name mangling)
    
    def __str__(self) -> str:
        """Représentation string pour utilisateur."""
        return f"{self.nom}, {self._age} ans"
    
    def __repr__(self) -> str:
        """Représentation pour développeur."""
        return f"Personne(nom={self.nom!r}, age={self._age})"
    
    @property
    def age(self) -> int:
        """Getter pour l'âge."""
        return self._age
    
    @age.setter
    def age(self, valeur: int) -> None:
        """Setter pour l'âge avec validation."""
        if valeur < 0:
            raise ValueError("L'âge ne peut pas être négatif")
        self._age = valeur
    
    @classmethod
    def depuis_annee_naissance(cls, nom: str, annee: int) -> "Personne":
        """Crée une personne depuis son année de naissance."""
        from datetime import datetime
        age = datetime.now().year - annee
        return cls(nom, age)
    
    @staticmethod
    def est_majeur(age: int) -> bool:
        """Vérifie si un âge correspond à un majeur."""
        return age >= 18

# Utilisation
alice = Personne("Alice", 30)
print(alice)                    # "Alice, 30 ans"
print(repr(alice))              # "Personne(nom='Alice', age=30)"

bob = Personne.depuis_annee_naissance("Bob", 1990)
print(Personne.est_majeur(25))  # True
```

### Dataclasses (Python 3.7+)

```python
from dataclasses import dataclass, field
from typing import List

@dataclass
class Produit:
    """Représente un produit en stock."""
    nom: str
    prix: float
    quantite: int = 0
    categories: List[str] = field(default_factory=list)
    
    def valeur_stock(self) -> float:
        """Calcule la valeur totale du stock."""
        return self.prix * self.quantite

# Utilisation
produit = Produit("Laptop", 999.99, 10)
print(produit)  # Produit(nom='Laptop', prix=999.99, quantite=10, categories=[])
print(produit.valeur_stock())  # 9999.9
```

### Héritage

```python
class Animal:
    """Classe de base pour les animaux."""
    
    def __init__(self, nom: str):
        self.nom = nom
    
    def parler(self) -> str:
        raise NotImplementedError("Les sous-classes doivent implémenter ceci")

class Chien(Animal):
    """Représente un chien."""
    
    def parler(self) -> str:
        return f"{self.nom} dit: Wouf!"

class Chat(Animal):
    """Représente un chat."""
    
    def parler(self) -> str:
        return f"{self.nom} dit: Miaou!"

# Polymorphisme
animaux = [Chien("Rex"), Chat("Minou")]
for animal in animaux:
    print(animal.parler())
```

## Gestion des Erreurs

### Try/Except/Finally

```python
def diviser(a: float, b: float) -> float:
    """Divise a par b avec gestion d'erreurs."""
    try:
        resultat = a / b
    except ZeroDivisionError:
        print("Erreur: Division par zéro!")
        return float('inf')
    except TypeError as e:
        print(f"Erreur de type: {e}")
        raise
    else:
        # Exécuté si pas d'exception
        print("Division réussie")
        return resultat
    finally:
        # Toujours exécuté
        print("Opération terminée")

# Capturer plusieurs exceptions
try:
    # code risqué
    pass
except (ValueError, TypeError) as e:
    print(f"Erreur de valeur ou type: {e}")

# Ignorer une exception (avec contexte)
from contextlib import suppress

with suppress(FileNotFoundError):
    os.remove("fichier_temporaire.txt")
```

### Exceptions Personnalisées

```python
class ValidationError(Exception):
    """Erreur de validation de données."""
    pass

class EmailInvalideError(ValidationError):
    """Email au format invalide."""
    pass

class AgeInvalideError(ValidationError):
    """Âge en dehors des limites."""
    pass

def valider_utilisateur(email: str, age: int) -> None:
    """Valide les données utilisateur."""
    if "@" not in email:
        raise EmailInvalideError(f"Email invalide: {email}")
    
    if not 0 <= age <= 150:
        raise AgeInvalideError(f"Âge invalide: {age}")

# Utilisation
try:
    valider_utilisateur("invalid", 200)
except ValidationError as e:
    print(f"Erreur de validation: {e}")
```

## Gestion de Fichiers

### Lecture et Écriture

```python
from pathlib import Path

# Chemin moderne avec pathlib
chemin = Path("data") / "fichier.txt"

# Écriture
texte = "Bonjour, monde!"
chemin.write_text(texte, encoding="utf-8")

# Lecture
contenu = chemin.read_text(encoding="utf-8")

# Gestionnaire de contexte (recommandé)
with open(chemin, "r", encoding="utf-8") as f:
    contenu = f.read()

# Ligne par ligne
with open(chemin, "r", encoding="utf-8") as f:
    for ligne in f:
        print(ligne.strip())

# Écriture JSON
import json

data = {"nom": "Alice", "age": 30}
chemin_json = Path("data") / "config.json"

with open(chemin_json, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2, ensure_ascii=False)

# Lecture JSON
with open(chemin_json, "r", encoding="utf-8") as f:
    data = json.load(f)
```

## Modules et Packages

### Importations

```python
# Import standard
import os
import sys
from datetime import datetime, timedelta

# Import avec alias
import numpy as np
import pandas as pd

# Import spécifique
from math import sqrt, pi
from typing import List, Dict, Optional

# Import relatif (dans un package)
from . import module_local
from ..utils import helpers
from .constants import DEBUG

# Vérifier si module est disponible
try:
    import requests
except ImportError:
    print("Module 'requests' non installé")
```

### Créer un Package

```python
# mon_package/__init__.py
"""Package mon_package."""

__version__ = "1.0.0"
__all__ = ["ma_fonction", "MaClasse"]

from .module import ma_fonction, MaClasse

# mon_package/module.py
def ma_fonction():
    pass

class MaClasse:
    pass
```

## Tests avec pytest

### Tests de Base

```python
# tests/test_calculs.py
import pytest
from src.calculs import addition, division

def test_addition():
    """Test l'addition de deux nombres."""
    assert addition(2, 3) == 5
    assert addition(-1, 1) == 0
    assert addition(0, 0) == 0

def test_division():
    """Test la division."""
    assert division(10, 2) == 5.0
    assert division(7, 2) == 3.5

def test_division_par_zero():
    """Test la division par zéro."""
    with pytest.raises(ZeroDivisionError):
        division(10, 0)

# Fixture
@pytest.fixture
def utilisateur():
    """Crée un utilisateur de test."""
    return {
        "nom": "Test",
        "email": "test@example.com"
    }

def test_utilisateur(utilisateur):
    """Test avec fixture."""
    assert utilisateur["nom"] == "Test"

# Paramétrisation
@pytest.mark.parametrize("a,b,resultat", [
    (1, 2, 3),
    (5, 5, 10),
    (-1, 1, 0),
])
def test_addition_parametrise(a, b, resultat):
    assert addition(a, b) == resultat
```

### Exécution des Tests avec uv

```bash
# Tous les tests
uv run pytest

# Avec couverture
uv run pytest --cov=src --cov-report=html

# Tests spécifiques
uv run pytest tests/test_calculs.py
uv run pytest tests/test_calculs.py::test_addition

# Verbose
uv run pytest -v

# Debug
uv run pytest --pdb
```

## Outils de Qualité

### Installation avec uv (Recommandé)

```bash
# Installer comme outils globaux
uv tool install black
uv tool install ruff
uv tool install mypy

# Ou tous en une commande
uv tool install black ruff mypy

# Exécuter sans installation via uvx
uvx black --check .
uvx ruff check .
uvx mypy src/
```

### Installation avec pip (Alternative)

```bash
pip install black ruff mypy pytest pytest-cov
```

### Configuration dans pyproject.toml

Ces outils sont généralement configurés dans `pyproject.toml` :

```toml
[tool.black]
line-length = 88
target-version = ['py311', 'py312']

[tool.ruff]
line-length = 88
select = ["E", "F", "I", "N", "W", "UP"]
ignore = ["E501"]

[tool.ruff.lint.pydocstyle]
convention = "google"

[tool.mypy]
python_version = "3.11"
strict = true
warn_return_any = true
warn_unused_configs = true
```

### Black (Formatage)

```bash
# Formater un fichier
black src/mon_module.py
# ou
uvx black src/mon_module.py

# Formater tout le projet
black .
# ou
uvx black .

# Vérifier sans modifier
black --check .
# ou
uvx black --check .
```

### Ruff (Linting)

```bash
# Linter le code
ruff check .
# ou
uvx ruff check .

# Linter et corriger
ruff check --fix .
# ou
uvx ruff check --fix .

# Vérifier imports
ruff check --select I .
# ou
uvx ruff check --select I .
```

### mypy (Vérification de types)

```bash
# Vérifier les types
mypy src/
# ou
uvx mypy src/

# Ignorer les imports manquants
mypy --ignore-missing-imports src/
# ou
uvx mypy --ignore-missing-imports src/
```

### Script de Vérification Complet

Créez un script `check.sh` :

```bash
#!/bin/bash
set -e

echo "=== Ruff (Linting) ==="
uvx ruff check . --fix

echo "=== Black (Formatage) ==="
uvx black --check .

echo "=== mypy (Types) ==="
uvx mypy src/

echo "=== Tests ==="
uv run pytest

echo "✅ Tous les checks sont passés!"
```

## Pattern Matching (Python 3.10+)

```python
def analyser_donnees(data):
    """Analyse différents types de données avec pattern matching."""
    match data:
        # Match sur valeur exacte
        case None:
            return "Aucune donnée"
        
        # Match sur type
        case int(n) if n < 0:
            return f"Nombre négatif: {n}"
        case int(n):
            return f"Nombre positif: {n}"
        
        # Match sur structure dict
        case {"type": "user", "name": str(nom)}:
            return f"Utilisateur: {nom}"
        
        # Match sur structure liste
        case [x, y, *reste]:
            return f"Liste avec {len(reste)+2} éléments"
        
        # Match sur dataclass
        case Produit(nom=n, prix=p):
            return f"Produit {n} à {p}€"
        
        # Cas par défaut
        case _:
            return "Format non reconnu"
```

## Ressources

- [Documentation Python officielle](https://docs.python.org/fr/3/)
- [PEP 8 - Style Guide](https://peps.python.org/pep-0008/)
- [Python Type Hints](https://docs.python.org/3/library/typing.html)
- [pytest Documentation](https://docs.pytest.org/)
- [Black Documentation](https://black.readthedocs.io/)
- [Ruff Documentation](https://docs.astral.sh/ruff/)
