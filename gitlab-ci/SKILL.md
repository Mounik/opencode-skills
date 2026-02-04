---
name: gitlab-ci
description: Construction de pipelines GitLab CI/CD avec des workflows multi-étapes, la mise en cache et des runners distribués pour une automatisation scalable
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: devops
---

# GitLab CI/CD Patterns

## Ce que je fais

- Guide complet pour GitLab CI/CD
- Création de pipelines multi-étapes
- Mise en cache pour optimiser les builds
- Déploiement multi-environnement
- Intégration avec Terraform
- Analyse de sécurité (SAST, Dependency Scanning)
- Utilisation de pipelines enfants dynamiques
- Stratégies avancées de mise en cache

## Quand m'utiliser

- Automatiser le CI/CD basé sur GitLab
- Implémenter des pipelines multi-étapes
- Configurer les GitLab Runners
- Déployer vers Kubernetes depuis GitLab
- Implémenter des workflows GitOps
- Mettre en place l'analyse de sécurité
- Optimiser les performances des pipelines

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière documentation de GitLab CI/CD
2. Vérifiez les changements récents dans la documentation officielle de GitLab
3. Fournissez des exemples à jour basés sur les bonnes pratiques GitLab
4. Assurez-vous d'utiliser les dernières versions des images Docker

## Structure Basique d'un Pipeline

```yaml
stages:
  - build
  - test
  - deploy

variables:
  DOCKER_DRIVER: overlay2
  DOCKER_TLS_CERTDIR: "/certs"

build:
  stage: build
  image: node:20
  script:
    - npm ci
    - npm run build
  artifacts:
    paths:
      - dist/
    expire_in: 1 hour
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/

test:
  stage: test
  image: node:20
  script:
    - npm ci
    - npm run lint
    - npm test
  coverage: '/Lines\s*:\s*(\d+\.\d+)%/'
  artifacts:
    reports:
      coverage_report:
        coverage_format: cobertura
        path: coverage/cobertura-coverage.xml

deploy:
  stage: deploy
  image: bitnami/kubectl:latest
  script:
    - kubectl apply -f k8s/
    - kubectl rollout status deployment/my-app
  only:
    - main
  environment:
    name: production
    url: https://app.example.com
```

## Construction et Push Docker

```yaml
build-docker:
  stage: build
  image: docker:24
  services:
    - docker:24-dind
  before_script:
    - docker login -u $CI_REGISTRY_USER -p $CI_REGISTRY_PASSWORD $CI_REGISTRY
  script:
    - docker build -t $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA .
    - docker build -t $CI_REGISTRY_IMAGE:latest .
    - docker push $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
    - docker push $CI_REGISTRY_IMAGE:latest
  only:
    - main
    - tags
```

## Déploiement Multi-Environnement

```yaml
.deploy_template: &deploy_template
  image: bitnami/kubectl:latest
  before_script:
    - kubectl config set-cluster k8s --server="$KUBE_URL" --insecure-skip-tls-verify=true
    - kubectl config set-credentials admin --token="$KUBE_TOKEN"
    - kubectl config set-context default --cluster=k8s --user=admin
    - kubectl config use-context default

deploy:staging:
  <<: *deploy_template
  stage: deploy
  script:
    - kubectl apply -f k8s/ -n staging
    - kubectl rollout status deployment/my-app -n staging
  environment:
    name: staging
    url: https://staging.example.com
  only:
    - develop

deploy:production:
  <<: *deploy_template
  stage: deploy
  script:
    - kubectl apply -f k8s/ -n production
    - kubectl rollout status deployment/my-app -n production
  environment:
    name: production
    url: https://app.example.com
  when: manual
  only:
    - main
```

## Pipeline Terraform

```yaml
stages:
  - validate
  - plan
  - apply

variables:
  TF_ROOT: ${CI_PROJECT_DIR}/terraform
  TF_VERSION: "1.6.0"

before_script:
  - cd ${TF_ROOT}
  - terraform --version

validate:
  stage: validate
  image: hashicorp/terraform:${TF_VERSION}
  script:
    - terraform init -backend=false
    - terraform validate
    - terraform fmt -check

plan:
  stage: plan
  image: hashicorp/terraform:${TF_VERSION}
  script:
    - terraform init
    - terraform plan -out=tfplan
  artifacts:
    paths:
      - ${TF_ROOT}/tfplan
    expire_in: 1 day

apply:
  stage: apply
  image: hashicorp/terraform:${TF_VERSION}
  script:
    - terraform init
    - terraform apply -auto-approve tfplan
  dependencies:
    - plan
  when: manual
  only:
    - main
```

## Analyse de Sécurité

```yaml
include:
  - template: Security/SAST.gitlab-ci.yml
  - template: Security/Dependency-Scanning.gitlab-ci.yml
  - template: Security/Container-Scanning.gitlab-ci.yml

trivy-scan:
  stage: test
  image: aquasec/trivy:latest
  script:
    - trivy image --exit-code 1 --severity HIGH,CRITICAL $CI_REGISTRY_IMAGE:$CI_COMMIT_SHA
  allow_failure: true
```

## Stratégies de Mise en Cache

```yaml
# Cache node_modules
build:
  cache:
    key: ${CI_COMMIT_REF_SLUG}
    paths:
      - node_modules/
    policy: pull-push

# Cache global
cache:
  key: ${CI_COMMIT_REF_SLUG}
  paths:
    - .cache/
    - vendor/

# Cache séparé par job
job1:
  cache:
    key: job1-cache
    paths:
      - build/

job2:
  cache:
    key: job2-cache
    paths:
      - dist/
```

## Pipelines Enfants Dynamiques

```yaml
generate-pipeline:
  stage: build
  script:
    - python generate_pipeline.py > child-pipeline.yml
  artifacts:
    paths:
      - child-pipeline.yml

trigger-child:
  stage: deploy
  trigger:
    include:
      - artifact: child-pipeline.yml
        job: generate-pipeline
    strategy: depend
```

## Bonnes Pratiques

1. **Utiliser des tags d'image spécifiques** (node:20, pas node:latest)
2. **Mettre en cache les dépendances** de manière appropriée
3. **Utiliser des artifacts** pour les sorties de build
4. **Implémenter des portes manuelles** pour la production
5. **Utiliser des environnements** pour le suivi des déploiements
6. **Activer les pipelines de merge request**
7. **Utiliser les planifications de pipelines** pour les jobs récurrents
8. **Implémenter l'analyse de sécurité**
9. **Utiliser les variables CI/CD** pour les secrets
10. **Surveiller les performances des pipelines**

## Fichiers de Référence

- `assets/gitlab-ci.yml.template` - Template de pipeline complet
- `references/pipeline-stages.md` - Patterns d'organisation des étapes
