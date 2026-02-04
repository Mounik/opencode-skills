# AGENTS.md - Directives du Projet

## Vue d'ensemble

Ce projet contient des **skills personnalisés pour OpenCode** et autres assistants IA. Les skills sont des fichiers markdown avec un frontmatter YAML qui fournissent des connaissances spécifiques à un domaine pour guider l'IA.

Ce dépôt s'inspire de la collection [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) mais est destiné à un usage personnel avec vos propres skills.

## Structure du Projet

```
/home/mounik/skills/
├── AGENTS.md              # Ce fichier - directives pour les agents
├── README.md              # Documentation du projet
├── mon-skill/             # Vos skills personnels (à créer ici)
│   └── SKILL.md
├── un-autre-skill/        # Chaque skill dans son propre dossier
│   └── SKILL.md
├── .opencode/skills/      # Skills OpenCode (emplacement recommandé)
│   └── <skill-name>/
│       └── SKILL.md
├── .claude/skills/        # Compatible Claude Code (optionnel)
│   └── <skill-name>/
│       └── SKILL.md
└── .agent/skills/         # Collection antigravity (référence uniquement)
    └── skills/
        └── ... (626+ skills pour inspiration)
```

## Créer un Nouveau Skill

### Avec OpenCode CLI

```bash
# Lancer la création interactive d'un agent/skill
opencode agent create
```

Cette commande vous guide pour :
- Choisir l'emplacement (global ou projet)
- Définir la description du skill
- Générer un prompt système approprié
- Sélectionner les outils accessibles
- Créer le fichier de configuration

### Création Manuelle

Les skills doivent être créés dans `.opencode/skills/` ou `~/.config/opencode/skills/`.

### Étapes Rapides

```bash
# 1. Créer le dossier du skill (kebab-case)
mkdir -p .opencode/skills/mon-skill-perso

# 2. Créer le fichier SKILL.md
cat > .opencode/skills/mon-skill-perso/SKILL.md << 'EOF'
---
name: mon-skill-perso
description: "Description de ce que fait mon skill"
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: general
---

# Mon Skill Perso

## Ce que je fais

- Description des fonctionnalités
- Liste des tâches accomplies

## Quand m'utiliser

- Utiliser quand [scénario 1]
- Utiliser quand [scénario 2]

## Instructions

[Instructions détaillées ici]

## Exemples

```bash
exemple de commande ici
```
EOF
```

## Structure du fichier SKILL.md

```markdown
---
name: nom-du-skill         # Doit correspondre au nom du dossier (kebab-case)
description: "Description en une ligne"
license: MIT              # Optionnel
compatibility: opencode   # ou claude
metadata:
  audience: developers     # audience cible
  workflow: general       # type de workflow
---

# Titre du Skill

## Ce que je fais

- Fonctionnalité 1
- Fonctionnalité 2

## Quand m'utiliser

- Utiliser quand [scénario 1]
- Utiliser quand [scénario 2]

## Instructions

Étapes à suivre...

## Exemples

```language
exemple de code
```
```

## Emplacements des Skills

OpenCode recherche les skills dans ces emplacements (par ordre de priorité) :

1. **Projet spécifique** : `.opencode/skills/<name>/SKILL.md`
2. **Global** : `~/.config/opencode/skills/<name>/SKILL.md`
3. **Compatible Claude (projet)** : `.claude/skills/<name>/SKILL.md`
4. **Compatible Claude (global)** : `~/.claude/skills/<name>/SKILL.md`

## Documentation à Jour avec Context7

**IMPORTANT** : Pour garantir que vos skills contiennent les informations les plus récentes, utilisez **le MCP Context7** pour récupérer la dernière version de la documentation.

### Dans chaque SKILL.md

Ajoutez une instruction pour utiliser Context7 avant de fournir des exemples de code :

```markdown
## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière version de la documentation officielle
2. Vérifiez les changements récents dans la documentation
3. Fournissez des exemples à jour basés sur la documentation officielle
```

### Exemple d'utilisation de Context7

Si votre skill concerne un framework ou une bibliothèque spécifique :

```markdown
## Instructions

1. Utilisez le MCP Context7 pour récupérer la documentation à jour de [nom-framework]
2. Assurez-vous que les exemples de code suivent la syntaxe de la dernière version
3. Mentionnez la version utilisée dans les exemples

## Exemples

```typescript
// Les exemples suivants utilisent la dernière version de la documentation
// via Context7 MCP
```
```

### Pourquoi Context7 ?

- **Documentation fraîche** : Accès à la documentation la plus récente
- **Précision** : Évite les informations obsolètes ou dépréciées
- **Fiabilité** : Basé sur la documentation officielle
- **Mises à jour** : Peut refléter les dernières versions et changements

## Créer des Agents et Sous-agents

### Configuration dans opencode.json

Le fichier `opencode.json` définit la configuration des agents :

```json
{
  "$schema": "https://opencode.ai/config.json",
  "agent": {
    "build": {
      "mode": "primary",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "{file:./prompts/build.txt}",
      "tools": {
        "write": true,
        "edit": true,
        "bash": true
      }
    },
    "plan": {
      "mode": "primary",
      "model": "anthropic/claude-haiku-4-20250514",
      "tools": {
        "write": false,
        "edit": false,
        "bash": false
      }
    },
    "code-reviewer": {
      "description": "Reviews code for best practices and potential issues",
      "mode": "subagent",
      "model": "anthropic/claude-sonnet-4-20250514",
      "prompt": "You are a code reviewer. Focus on security, performance, and maintainability.",
      "tools": {
        "write": false,
        "edit": false
      }
    }
  }
}
```

### Modes d'Agents

- **`primary`** : Agent principal avec accès complet aux outils configurés
- **`subagent`** : Sous-agent avec permissions restreintes, utilisé par les agents principaux

## Conventions de Nommage

- **Dossiers des skills** : `kebab-case` (ex: `mon-skill-perso`, `api-interne`)
- **Nom dans le frontmatter** : Doit correspondre exactement au nom du dossier
- **Fichiers** : Minuscules avec tirets pour les noms composés

## Contenu Requis

1. **Frontmatter** : Les champs `name` et `description` sont obligatoires
2. **Section "Ce que je fais"** : Description des fonctionnalités du skill
3. **Section "Quand m'utiliser"** : DOIT avoir une section `## Quand m'utiliser` ou `## When to Use Me`
4. **Exemples concrets** : Fournir des exemples utilisables
5. **Instructions claires** : Étapes détaillées et actionnables

## Conventions Git

Préfixes de commit :
- `feat:` - Nouveau skill
- `docs:` - Documentation
- `fix:` - Corrections
- `refactor:` - Améliorations
- `test:` - Tests
- `chore:` - Maintenance

Exemples :
```bash
git commit -m "feat: add skill pour mon api interne"
git commit -m "docs: améliorer les exemples de react-hooks"
git commit -m "fix: corriger typo dans stripe-integration"
```

## Erreurs de Validation Courantes

1. **Frontmatter manquant** : Ajouter le YAML entre les marqueurs `---`
2. **Nom qui ne correspond pas** : Vérifier que `name:` correspond exactement au dossier
3. **Section "Quand m'utiliser" manquante** : Ajouter une section `## Quand m'utiliser`
4. **Emplacement incorrect** : Utiliser `.opencode/skills/` ou `~/.config/opencode/skills/`

## Exemples de Skills Existant

Vous pouvez vous inspirer des skills dans `.agent/skills/skills/` :

- `nextjs-best-practices` - Bonnes pratiques Next.js
- `api-design-principles` - Principes de design d'API
- `react-state-management` - Gestion d'état React
- `python-testing-patterns` - Patterns de test Python

**Note** : Ces skills sont fournis à titre de référence pour comprendre la structure et les conventions.

## Notes

- C'est une **base de connaissances**, pas une codebase traditionnelle
- Les skills sont des fichiers markdown avec un frontmatter YAML
- L'accent est mis sur la **qualité de la documentation** et la cohérence
- Créez vos skills dans `.opencode/skills/` ou `~/.config/opencode/skills/`
- Le dossier `.agent/skills/` est une collection de référence - ne le modifiez pas
- Utilisez `opencode agent create` pour créer rapidement des agents et skills

## Ressources

- [OpenCode Documentation](https://opencode.ai/docs) - Documentation officielle
- [OpenCode Skills Guide](https://github.com/sst/opencode/blob/dev/packages/web/src/content/docs/skills.mdx) - Guide des skills
- [OpenCode Agents Guide](https://github.com/sst/opencode/blob/dev/packages/web/src/content/docs/agents.mdx) - Guide des agents
