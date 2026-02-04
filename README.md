# Skills Personnels pour OpenCode

Collection de skills personnalisés pour OpenCode et assistants IA.

## Objectif

Créez et gérez vos propres skills - fichiers de connaissances spécialisés qu'OpenCode utilise pour mieux vous assister dans des domaines spécifiques.

## Structure du Projet

```
/home/mounik/skills/
├── AGENTS.md              # Directives pour les agents IA
├── README.md              # Ce fichier
├── mon-skill/             # Vos skills personnels (à créer ici)
│   └── SKILL.md
├── un-autre-skill/        # Chaque skill dans son propre dossier
│   └── SKILL.md
├── .agent/skills/         # Collection antigravity (référence uniquement)
│   └── skills/
│       └── ... (626+ skills pour inspiration)
├── .opencode/skills/      # Skills OpenCode (emplacement recommandé)
│   └── <skill-name>/
│       └── SKILL.md
└── .claude/skills/        # Compatible Claude Code (optionnel)
    └── <skill-name>/
        └── SKILL.md
```

## Commencer Rapidement

### Avec OpenCode CLI

```bash
opencode agent create
```

Cette commande interactive vous guide pour:
- Choisir l'emplacement (global ou projet)
- Définir la description du skill
- Générer un prompt système approprié
- Sélectionner les outils accessibles
- Créer le fichier de configuration

### Création Manuelle

Les skills doivent être créés dans `.opencode/skills/` ou `~/.config/opencode/skills/`.

#### Étapes Rapides

1. Créer le dossier du skill (kebab-case):
```bash
mkdir -p .opencode/skills/mon-skill-perso
```

2. Créer le fichier SKILL.md avec ce template:

```markdown
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

Étapes à suivre...

## Exemples

```bash
exemple de commande ici
```
```

## Structure d'un Skill

Chaque skill est un dossier contenant un fichier SKILL.md avec ce format:

**Frontmatter YAML requis:**
- `name` : Nom du skill (doit correspondre au dossier)
- `description` : Description en une ligne
- `license` : Optionnel (MIT par défaut)
- `compatibility` : opencode ou claude
- `metadata` : audience et workflow

**Sections principales:**
1. Titre du skill (# Titre)
2. Ce que je fais - description des fonctionnalités
3. Quand m'utiliser - cas d'usage
4. Instructions - étapes détaillées
5. Exemples - code ou commandes utilisables

## Emplacements des Skills

OpenCode recherche les skills dans cet ordre de priorité:

1. Projet spécifique: `.opencode/skills/<name>/SKILL.md`
2. Global: `~/.config/opencode/skills/<name>/SKILL.md`
3. Compatible Claude (projet): `.claude/skills/<name>/SKILL.md`
4. Compatible Claude (global): `~/.claude/skills/<name>/SKILL.md`

## Conventions

### Nommage

- Dossiers: kebab-case (ex: `mon-skill`, `api-interne`)
- Nom dans SKILL.md: doit correspondre exactement au dossier
- Fichier principal: toujours nommé SKILL.md

### Contenu Requis

1. Frontmatter YAML avec `name` et `description`
2. Section "Ce que je fais" pour décrire les fonctionnalités
3. Section "Quand m'utiliser" pour décrire les cas d'usage
4. Exemples concrets que l'IA peut suivre
5. Instructions claires et actionnables

### Commits Git

Préfixes de commit:
- `feat:` - Nouveau skill
- `docs:` - Documentation
- `fix:` - Corrections
- `refactor:` - Améliorations
- `test:` - Tests
- `chore:` - Maintenance

Exemples:
```bash
git commit -m "feat: add skill pour mon api interne"
git commit -m "docs: améliorer les exemples de react-hooks"
git commit -m "fix: corriger typo dans stripe-integration"
```

## Exemples de Skills

### Skill pour Stack Technique Interne

Contenu:
- Stack technique et conventions de l'entreprise
- Guide pour créer des projets
- Définit les conventions de code et architecture

Cas d'usage:
- Création de nouveaux projets
- Configuration de l'authentification
- Définition des patterns d'architecture

### Skill pour Scripts Utiles

Contenu:
- Scripts et commandes fréquemment utilisés
- Commandes de déploiement rapides
- Automatisation du nettoyage des branches git

Cas d'usage:
- Déploiement rapide
- Nettoyage des branches git
- Opérations répétitives

## Agents et Sous-agents

OpenCode supporte la création d'agents et de sous-agents via `opencode agent create`.

### Configuration (opencode.json)

Le fichier opencode.json définit la configuration des agents:

**Modes d'agents:**
- `primary`: Agent principal avec accès complet aux outils configurés
- `subagent`: Sous-agent avec permissions restreintes

**Exemple de configuration:**
- `build`: Agent principal avec accès write, edit, bash
- `plan`: Agent principal sans accès aux fichiers
- `code-reviewer`: Sous-agent pour review de code

## Inspiration et Référence

Le dossier `.agent/skills/` contient une collection de **626+ skills** couvrant:

- Frontend: React, Vue, Angular, Next.js, Tailwind
- Backend: Node.js, Python, Go, Rust, APIs
- DevOps: Docker, Kubernetes, CI/CD, Terraform
- Mobile: React Native, Flutter, iOS, Android
- Data: SQL, NoSQL, Data Engineering, ML
- Security: Pentesting, Sécurité applicative, Conformité
- Soft Skills: Communication, Gestion de projet, Documentation

Consultez ces skills pour vous inspirer et comprendre les bonnes pratiques!

## Documentation à Jour avec Context7

Pour garantir que vos skills contiennent les informations les plus récentes, utilisez le MCP Context7 pour récupérer la dernière version de la documentation officielle.

**Avantages:**
- Documentation fraîche et à jour
- Précision - évite les informations obsolètes
- Fiabilité - basé sur la documentation officielle
- Mises à jour - peut refléter les dernières versions

## Ressources

- [AGENTS.md](./AGENTS.md) - Directives détaillées pour créer des skills
- [.agent/skills/skills/](./.agent/skills/skills/) - Collection de référence (626+ skills)
- [OpenCode Documentation](https://opencode.ai/docs) - Documentation officielle d'OpenCode
- [OpenCode Skills Guide](https://github.com/sst/opencode/blob/dev/packages/web/src/content/docs/skills.mdx) - Guide des skills
- [OpenCode Agents Guide](https://github.com/sst/opencode/blob/dev/packages/web/src/content/docs/agents.mdx) - Guide des agents

## Astuces

1. **Commencez simple**: Créez un skill basique et améliorez-le au fil du temps
2. **Soyez spécifique**: Plus vos instructions sont précises, mieux l'IA pourra vous aider
3. **Testez**: Utilisez le skill avec OpenCode et ajustez selon les résultats
4. **Versionnez**: Commitez régulièrement vos modifications

## Erreurs Courantes

1. **Frontmatter manquant**: Ajouter le YAML entre les marqueurs `---`
2. **Nom qui ne correspond pas**: Vérifier que `name:` correspond exactement au dossier
3. **Section "Quand m'utiliser" manquante**: Ajouter une section `## Quand m'utiliser`
4. **Emplacement incorrect**: Utiliser `.opencode/skills/` ou `~/.config/opencode/skills/`

## License

Ce projet est destiné à un usage personnel. Les skills dans `.agent/skills/` proviennent de [antigravity-awesome-skills](https://github.com/sickn33/antigravity-awesome-skills) sous licence MIT.
