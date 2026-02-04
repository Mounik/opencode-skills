# Guide d'Implémentation GitLab CI

Ce guide fournit des exemples détaillés et des patterns avancés pour GitLab CI/CD.

## Table des Matières

1. [Nouveautés 2024-2025](#nouveautés-2024-2025)
2. [Pipeline de Base Complète](#pipeline-de-base-complète)
3. [Tests Parallèles](#tests-parallèles)
4. [Déploiement Canary](#déploiement-canary)
5. [Pipeline avec Approval](#pipeline-avec-approval)
6. [Matrix Builds](#matrix-builds)
7. [Intégration Sécurité Avancée](#intégration-sécurité-avancée)
8. [Gestion des Secrets avec Vault](#gestion-des-secrets-avec-vault)
9. [Optimisation des Performances](#optimisation-des-performances)
10. [Workflow Rules](#workflow-rules)

---

## Nouveautés 2024-2025

### Caches Multiples (Multiple Caches)

Nouvelle fonctionnalité permettant de définir plusieurs caches dans un seul job :

```yaml
test-job:
  stage: build
  cache:
    - key:
        files:
          - Gemfile.lock
      paths:
        - vendor/ruby
    - key:
        files:
          - yarn.lock
      paths:
        - .yarn-cache/
  script:
    - bundle config set --local path 'vendor/ruby'
    - bundle install
    - yarn install --cache-folder .yarn-cache
    - echo "Run tests..."
```

Cette approche permet de gérer efficacement différents types de dépendances (Ruby gems, packages npm, etc.) avec des clés de cache distinctes.

### PHP Composer avec Caching

Exemple moderne de mise en cache des dépendances PHP :

```yaml
default:
  image: php:latest
  cache:  # Mise en cache des librairies entre jobs
    key: $CI_COMMIT_REF_SLUG
    paths:
      - vendor/
  before_script:
    # Installation et exécution de Composer
    - curl --show-error --silent "https://getcomposer.org/installer" | php
    - php composer.phar install

test:
  script:
    - vendor/bin/phpunit --configuration phpunit.xml --coverage-text --colors=never
```

### Templates de Sécurité Intégrés

GitLab fournit désormais des scanners de sécurité prêts à l'emploi :

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Container-Scanning.gitlab-ci.yml
```

Ces templates détectent automatiquement les vulnérabilités dans tout le cycle de vie du développement logiciel (SDLC).

### Exemples de CI/CD Officiels

GitLab maintient des fichiers template `.gitlab-ci.yml` pour de nombreux frameworks et langages courants. Des repositories avec des projets exemples sont également disponibles pour :
- Le déploiement avec Dpl
- GitLab Pages
- Les pipelines multi-projets
- npm avec semantic-release
- PHP avec npm/SCP
- PHP avec PHPUnit/`atoum`
- La gestion des secrets avec Vault

---

## Pipeline de Base Complète

Une pipeline complète pour une application Node.js avec tests, build et déploiement :

```yaml
stages:
  - install
  - lint
  - test
  - build
  - deploy

variables:
  NPM_CONFIG_CACHE: "${CI_PROJECT_DIR}/.npm"
  NODE_ENV: "production"
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: ""

# Cache global pour tous les jobs
default:
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
      - .npm/
    policy: pull-push

install:
  stage: install
  image: node:20-alpine
  script:
    - npm ci --cache .npm --prefer-offline
  artifacts:
    paths:
      - node_modules/
    expire_in: 1 hour

lint:
  stage: lint
  image: node:20-alpine
  script:
    - npm run lint
    - npm run format:check
  allow_failure: false

test:unit:
  stage: test
  image: node:20-alpine
  script:
    - npm run test:unit -- --coverage
  coverage: '/All files[^|]*\|[^|]*\s+([\d\.]+)/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml
    paths:
      - coverage/
    expire_in: 1 week

test:integration:
  stage: test
  image: node:20-alpine
  services:
    - name: postgres:15-alpine
      alias: postgres
  variables:
    POSTGRES_DB: test_db
    POSTGRES_USER: test_user
    POSTGRES_PASSWORD: test_pass
    DATABASE_URL: "postgres://test_user:test_pass@postgres:5432/test_db"
  script:
    - npm run test:integration
  allow_failure: true

build:
  stage: build
  image: node:20-alpine
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
      - build/
    expire_in: 1 week

deploy:staging:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context staging
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n staging
    - kubectl rollout status deployment/app -n staging --timeout=5m
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop

deploy:production:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl config use-context production
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA -n production
    - kubectl rollout status deployment/app -n production --timeout=10m
  environment:
    name: production
    url: https://app.example.com
  when: manual
  only:
    - main
```

---

## Tests Parallèles

Exécutez les tests en parallèle pour accélérer la pipeline :

```yaml
stages:
  - test

test:unit:
  stage: test
  parallel: 4
  script:
    - npm run test:unit -- --shard=$CI_NODE_INDEX/$CI_NODE_TOTAL
  artifacts:
    reports:
      junit: junit-report.xml

test:e2e:chrome:
  stage: test
  script:
    - npm run test:e2e -- --browser=chrome

test:e2e:firefox:
  stage: test
  script:
    - npm run test:e2e -- --browser=firefox
```

---

## Déploiement Canary

Déploiement progressif avec surveillance :

```yaml
stages:
  - build
  - deploy:canary
  - verify:canary
  - deploy:production

build:image:
  stage: build
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA

deploy:canary:10:
  stage: deploy:canary
  script:
    - kubectl set image deployment/app-canary app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - kubectl scale deployment/app-canary --replicas=1
    - kubectl scale deployment/app --replicas=9
  environment:
    name: canary
    url: https://canary.example.com

verify:canary:
  stage: verify:canary
  script:
    - sleep 300  # Attendre 5 minutes
    - ./scripts/check-error-rate.sh canary
    - ./scripts/check-latency.sh canary
  allow_failure: false

deploy:production:100:
  stage: deploy:production
  script:
    - kubectl set image deployment/app app=$CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - kubectl scale deployment/app-canary --replicas=0
    - kubectl scale deployment/app --replicas=10
  when: on_success
  environment:
    name: production
    url: https://app.example.com
```

---

## Pipeline avec Approval

Nécessite une approbation manuelle avant le déploiement :

```yaml
stages:
  - build
  - test
  - review
  - deploy

deploy:review:
  stage: review
  script:
    - echo "En attente d'approbation..."
  when: manual
  allow_failure: false
  only:
    - merge_requests
  environment:
    name: review/$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
    url: https://$CI_ENVIRONMENT_SLUG.example.com
    on_stop: stop_review

stop_review:
  stage: review
  script:
    - kubectl delete namespace review-$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
  when: manual
  environment:
    name: review/$CI_MERGE_REQUEST_SOURCE_BRANCH_NAME
    action: stop
```

---

## Matrix Builds

Tests sur plusieurs versions et configurations :

```yaml
stages:
  - test

test:matrix:
  stage: test
  parallel:
    matrix:
      - NODE_VERSION: ["18", "20", "21"]
        OS: ["alpine", "bullseye"]
  image: node:${NODE_VERSION}-${OS}
  script:
    - node --version
    - npm ci
    - npm test
  artifacts:
    reports:
      junit: test-results.xml
```

---

## Intégration Sécurité Avancée

Scan de sécurité complet :

```yaml
stages:
  - security

sast:
  stage: security
  image: returntocorp/semgrep
  script:
    - semgrep --config=auto --json --output=semgrep.json .
  artifacts:
    reports:
      sast: semgrep.json
  allow_failure: true

dependency_scanning:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy filesystem --format json --output trivy-fs.json .
  artifacts:
    reports:
      dependency_scanning: trivy-fs.json
  allow_failure: true

container_scanning:
  stage: security
  image: aquasec/trivy:latest
  script:
    - trivy image --format json --output trivy-image.json $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  artifacts:
    reports:
      container_scanning: trivy-image.json
  allow_failure: true
  only:
    - main
    - tags

secrets_detection:
  stage: security
  image: trufflesecurity/trufflehog:latest
  script:
    - trufflehog filesystem . --json
  allow_failure: true
```

---

## Gestion des Secrets avec Vault

### Authentification Vault avec ID Tokens (Méthode Moderne)

La méthode recommandée en 2024-2025 utilise les ID tokens OIDC pour une authentification sécurisée avec HashiCorp Vault :

```yaml
job_with_secrets:
  id_tokens:
    VAULT_ID_TOKEN:
      aud: https://vault.example.com
  secrets:
    STAGING_DB_PASSWORD:
      vault: myproject/staging/db/password@secret
      # Traduit en chemin 'secret/myproject/staging/db' et champ 'password'
      # Authentification via $VAULT_ID_TOKEN
  script:
    - access-staging-db.sh --token $STAGING_DB_PASSWORD
```

### Multiple ID Tokens pour Vault

Pour authentifier avec plusieurs services Vault différents :

```yaml
job_with_multiple_secrets:
  id_tokens:
    FIRST_ID_TOKEN:
      aud: https://first.service.com
    SECOND_ID_TOKEN:
      aud: https://second.service.com
  secrets:
    FIRST_DB_PASSWORD:
      vault: first/db/password
      token: $FIRST_ID_TOKEN
    SECOND_DB_PASSWORD:
      vault: second/db/password
      token: $SECOND_ID_TOKEN
  script:
    - access-first-db.sh --token $FIRST_DB_PASSWORD
    - access-second-db.sh --token $SECOND_DB_PASSWORD
```

### Vault avec KV Secrets Engine v1

Configuration pour Vault KV Secrets Engine v1 :

```yaml
job:
  variables:
    VAULT_SERVER_URL: https://vault.example.com
    VAULT_AUTH_PATH: jwt_v2
    VAULT_AUTH_ROLE: myproject-staging
  id_tokens:
    VAULT_ID_TOKEN:
      aud: https://vault.example.com
  secrets:
    PASSWORD:
      vault:
        engine:
          name: kv-v1
          path: secret
        field: password
        path: myproject/staging/db
      file: false
```

### Gestion Classique des Secrets CI/CD

Pour les secrets simples sans Vault :

```yaml
stages:
  - deploy

# Variables CI/CD (Settings > CI/CD > Variables)
# DB_PASSWORD (masked, protected)
# AWS_ACCESS_KEY_ID (masked)
# AWS_SECRET_ACCESS_KEY (masked, protected)
# KUBE_CONFIG (file, base64 encoded)

deploy:production:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    # Utiliser les variables de manière sécurisée
    - echo "$DB_PASSWORD" | kubectl create secret generic db-secret --from-literal=password=stdin --dry-run=client -o yaml | kubectl apply -f -
    
    # Pour AWS
    - export AWS_ACCESS_KEY_ID="$AWS_ACCESS_KEY_ID"
    - export AWS_SECRET_ACCESS_KEY="$AWS_SECRET_ACCESS_KEY"
    - aws eks update-kubeconfig --region eu-west-1 --name production
    
    # Déploiement
    - kubectl apply -f k8s/
  environment:
    name: production
    url: https://app.example.com
  only:
    - main
```

### Bonnes Pratiques pour les Secrets

1. **Privilégier les ID tokens** pour l'authentification Vault (méthode moderne et sécurisée)
2. **Toujours marquer les secrets comme `masked`** pour éviter l'affichage dans les logs
3. **Utiliser `protected`** pour les variables sensibles afin qu'elles ne soient accessibles que sur les branches protégées
4. **Ne jamais committer les secrets** dans le repository
5. **Utiliser des variables de type `file`** pour les certificats et clés
6. **Rotation régulière** des secrets

---

## Optimisation des Performances

### Cache Multi-Niveaux

```yaml
# Cache global
default:
  cache:
    key:
      files:
        - package-lock.json
    paths:
      - node_modules/

# Job spécifique avec cache supplémentaire
test:
  cache:
    - key: ${CI_COMMIT_REF_SLUG}
      paths:
        - node_modules/
    - key: jest-cache
      paths:
        - .jest-cache/
  script:
    - npm test -- --cacheDirectory=.jest-cache
```

### Artifacts Optimisés

```yaml
build:
  script:
    - npm run build
  artifacts:
    paths:
      - dist/
    exclude:
      - dist/**/*.map  # Exclure les source maps des artifacts
    expire_in: 3 days
    when: on_success
```

### Runner Tags

```yaml
# Utiliser des runners spécifiques pour des jobs lourds
test:heavy:
  tags:
    - high-memory
    - docker
  script:
    - npm run test:heavy

# Runner partagé pour les jobs légers
lint:
  tags:
    - shared
  script:
    - npm run lint
```

---

## Ressources Additionnelles

- [Documentation GitLab CI/CD](https://docs.gitlab.com/ee/ci/)
- [CI/CD Templates GitLab](https://docs.gitlab.com/ee/ci/examples/)
- [Best Practices GitLab](https://docs.gitlab.com/ee/ci/best_practices/)
- [Sécurité CI/CD](https://docs.gitlab.com/ee/user/application_security/)

---

## Workflow Rules

Les `workflow:rules` permettent de contrôler quand une pipeline doit être créée :

### Git Flow avec Merge Request Pipelines

Configuration pour le workflow Git Flow, activant les pipelines de merge request pour les branches de fonctionnalités tout en maintenant le support des versions multiples sur les branches longues :

```yaml
workflow:
  rules:
    # Pipeline pour les merge requests
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    # Pipeline pour les tags
    - if: $CI_COMMIT_TAG
    # Pipeline pour la branche par défaut
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    # Pipeline pour les branches protégées
    - if: $CI_COMMIT_REF_PROTECTED == "true"
```

Cette configuration :
- Priorise les pipelines pour les merge requests
- Supporte les tags
- Maintient les branches par défaut et les branches protégées
- Assure que les branches par défaut et longues sont protégées

### Workflow avec Exclusions

Exclure certains fichiers de déclenchement :

```yaml
workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_TAG
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
    - if: $CI_COMMIT_BRANCH =~ /^feature\//
      changes:
        - "**/*.js"
        - "**/*.ts"
        - "**/*.vue"
      when: never
    - when: always
```

### Workflow par Environnement

Désactiver les pipelines sur les forks :

```yaml
workflow:
  rules:
    - if: $CI_PIPELINE_SOURCE == "merge_request_event"
    - if: $CI_COMMIT_TAG
    - if: $CI_COMMIT_BRANCH == $CI_DEFAULT_BRANCH
      when: never
    - if: $CI_PROJECT_NAMESPACE != "mon-org"
      when: never
    - when: always
```

---

## Exemples de Commandes Utiles

### Vérifier le statut d'un pipeline

```bash
# Lister les pipelines récents
gl pipeline list --project-id=<ID>

# Voir les logs d'un job
gl job trace --project-id=<ID> --job-id=<JOB_ID>
```

### Déclencher un pipeline manuellement

```bash
# Via l'interface GitLab
# Project > CI/CD > Pipelines > Run pipeline

# Ou via l'API
curl --request POST --header "PRIVATE-TOKEN: <token>" \
  "https://gitlab.com/api/v4/projects/<ID>/pipeline?ref=main"
```

### Déboguer un job échoué

```bash
# Activer le debug mode dans .gitlab-ci.yml
variables:
  CI_DEBUG_SERVICES: "true"
  CI_DEBUG: "true"
```

---

## Documentation à Jour

Ce guide a été mis à jour avec les dernières informations de la documentation officielle GitLab CI/CD via **Context7 MCP** (février 2025).

### Sources

- [Documentation GitLab CI/CD - Caching](https://docs.gitlab.com/ci/caching)
- [Documentation GitLab CI/CD - Secrets HashiCorp Vault](https://docs.gitlab.com/ci/secrets/hashicorp_vault)
- [Documentation GitLab CI/CD - Workflow Rules](https://docs.gitlab.com/ci/yaml/workflow)
- [Documentation GitLab CI/CD - Examples](https://docs.gitlab.com/ci/examples)

### Utilisation de Context7

Pour garantir que ce skill contient toujours les informations les plus récentes :

1. Les exemples de code sont basés sur la documentation officielle GitLab
2. Les fonctionnalités 2024-2025 incluent : Caches multiples, ID Tokens pour Vault, Workflow Rules
3. Les bonnes pratiques sont conformes aux recommandations actuelles

*Dernière mise à jour : Février 2025 via Context7 MCP*
