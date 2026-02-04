---
name: helm-essentials
description: Guide pratique pour Helm - Le gestionnaire de packages Kubernetes. Maîtrisez l'installation de charts, la création de packages, les templates et le déploiement d'applications sur Kubernetes
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: devops
---

# Helm Essentials

## Ce que je fais

- Guide complet pour Helm, le gestionnaire de packages Kubernetes
- Installation et configuration de Helm
- Gestion des repositories de charts
- Installation et gestion des applications avec Helm
- Création de charts Helm personnalisés
- Gestion des templates et des helpers
- Gestion des dépendances (subcharts)
- Packaging et distribution de charts
- Débogage et tests de charts

## Quand m'utiliser

- Installer et gérer des applications Kubernetes avec Helm
- Créer des charts Helm personnalisés
- Gérer des dépendances entre charts
- Déployer des applications depuis des repositories Helm
- Effectuer des upgrades et rollbacks d'applications
- Gérer les configurations avec values.yaml
- Déboguer et tester des charts Helm

## Instructions

1. **Utilisez le MCP Context7** pour obtenir la dernière version des commandes Helm et des syntaxes de charts
2. Vérifiez les changements récents dans la documentation Helm
3. Fournissez des exemples à jour basés sur la documentation officielle helm.sh

## Installation de Helm

### Linux

```bash
# Télécharger et installer la dernière version
curl https://raw.githubusercontent.com/helm/helm/main/scripts/get-helm-3 | bash

# Ou via package manager (Ubuntu/Debian)
curl https://baltocdn.com/helm/signing.asc | gpg --dearmor | sudo tee /usr/share/keyrings/helm.gpg > /dev/null
sudo apt-get install apt-transport-https --yes
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/helm.gpg] https://baltocdn.com/helm/stable/debian/ all main" | sudo tee /etc/apt/sources.list.d/helm-stable-debian.list
sudo apt-get update
sudo apt-get install helm
```

### macOS

```bash
# Via Homebrew
brew install helm
```

### Windows

```powershell
# Via Chocolatey
choco install kubernetes-helm

# Via Winget
winget install Helm.Helm
```

### Vérifier l'installation

```bash
# Vérifier la version
helm version

# Voir l'aide
helm --help
```

## Gestion des Repositories

### Ajouter et gérer des repositories

```bash
# Ajouter un repository
helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable

# Lister les repositories
helm repo list

# Mettre à jour les repositories
helm repo update

# Supprimer un repository
helm repo remove bitnami

# Rechercher dans les repositories
helm search repo nginx
helm search repo nginx --versions
helm search repo nginx --version ^1.0.0
helm search repo nginx --devel  # Inclure les versions de développement
```

## Installation de Charts

### Installer un chart

```bash
# Installation basique
helm install my-nginx bitnami/nginx

# Installation avec un nom généré
helm install --generate-name bitnami/nginx

# Installation dans un namespace spécifique
helm install my-nginx bitnami/nginx --namespace production --create-namespace

# Installation avec un fichier de values personnalisé
helm install my-nginx bitnami/nginx -f myvalues.yaml

# Installation avec des valeurs en ligne
helm install my-nginx bitnami/nginx --set replicaCount=3
helm install my-nginx bitnami/nginx --set service.type=LoadBalancer

# Installation avec plusieurs sets
helm install my-nginx bitnami/nginx \
  --set replicaCount=3 \
  --set service.type=LoadBalancer \
  --set image.tag=latest
```

### Exemple d'installation complète

```bash
# Installer WordPress avec Bitnami
helm install happy-panda bitnami/wordpress

# Résultat attendu :
# NAME: happy-panda
# LAST DEPLOYED: Tue Jan 26 10:27:17 2021
# NAMESPACE: default
# STATUS: deployed
# REVISION: 1
# NOTES:
# ** Please be patient while as chart is being deployed **
#
# Your WordPress site can be accessed through following DNS name...
```

## Gestion des Releases

### Lister et obtenir des informations

```bash
# Lister toutes les releases
helm list
helm list --all-namespaces

# Lister les releases dans un namespace
helm list --namespace production

# Obtenir les informations d'une release
helm status my-release

# Obtenir l'historique des revisions
helm history my-release

# Obtenir les valeurs utilisées
helm get values my-release
helm get values my-release --all  # Toutes les valeurs

# Obtenir le manifest généré
helm get manifest my-release
```

### Upgrades et Rollbacks

```bash
# Upgrader une release
helm upgrade my-release bitnami/nginx

# Upgrader avec de nouvelles valeurs
helm upgrade my-release bitnami/nginx -f newvalues.yaml

# Upgrader et installer si non existant
helm upgrade --install my-release bitnami/nginx

# Rollback à une version précédente
helm rollback my-release 1

# Rollback (syntaxe complète)
helm rollback <RELEASE> [REVISION]
```

### Suppression

```bash
# Désinstaller une release
helm uninstall my-release

# Désinstaller et garder l'historique
helm uninstall my-release --keep-history
```

## Création de Charts

### Structure d'un Chart

```
mychart/
├── Chart.yaml          # Métadonnées du chart
├── values.yaml         # Valeurs par défaut
├── charts/             # Dépendances (subcharts)
├── templates/          # Templates Kubernetes
│   ├── _helpers.tpl    # Fonctions utilitaires
│   ├── deployment.yaml
│   ├── service.yaml
│   ├── ingress.yaml
│   └── NOTES.txt       # Notes post-installation
└── README.md           # Documentation du chart
```

### Créer un nouveau chart

```bash
# Créer un chart
helm create mychart

# Voir la structure
ls -la mychart/

# Tester le rendu des templates
helm template mychart

# Tester avec des valeurs spécifiques
helm template mychart -f myvalues.yaml

# Installation en dry-run
helm install --debug --dry-run goodly-guppy ./mychart

# Ou
helm install mychart --generate-name --dry-run --debug
```

### Chart.yaml

```yaml
apiVersion: v2
name: my-application
description: A Helm chart for my application
type: application
version: 1.0.0
appVersion: "1.16.0"
keywords:
  - web
  - application
home: https://example.com
sources:
  - https://github.com/example/my-app
maintainers:
  - name: John Doe
    email: john@example.com
icon: https://example.com/icon.png
```

### values.yaml

```yaml
# Valeurs par défaut pour mychart
replicaCount: 1

image:
  repository: nginx
  pullPolicy: IfNotPresent
  tag: ""

imagePullSecrets: []
nameOverride: ""
fullnameOverride: ""

serviceAccount:
  create: true
  annotations: {}
  name: ""

service:
  type: ClusterIP
  port: 80

ingress:
  enabled: false
  className: ""
  annotations: {}
  hosts:
    - host: chart-example.local
      paths:
        - path: /
          pathType: ImplementationSpecific
  tls: []

resources:
  limits:
    cpu: 100m
    memory: 128Mi
  requests:
    cpu: 100m
    memory: 128Mi

autoscaling:
  enabled: false
  minReplicas: 1
  maxReplicas: 100
  targetCPUUtilizationPercentage: 80
```

## Templates

### Exemple de template Deployment

```yaml
# templates/deployment.yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: {{ include "mychart.fullname" . }}
  labels:
    {{- include "mychart.labels" . | nindent 4 }}
spec:
  {{- if not .Values.autoscaling.enabled }}
  replicas: {{ .Values.replicaCount }}
  {{- end }}
  selector:
    matchLabels:
      {{- include "mychart.selectorLabels" . | nindent 6 }}
  template:
    metadata:
      labels:
        {{- include "mychart.selectorLabels" . | nindent 8 }}
    spec:
      containers:
        - name: {{ .Chart.Name }}
          image: "{{ .Values.image.repository }}:{{ .Values.image.tag | default .Chart.AppVersion }}"
          imagePullPolicy: {{ .Values.image.pullPolicy }}
          ports:
            - name: http
              containerPort: 80
              protocol: TCP
          resources:
            {{- toYaml .Values.resources | nindent 12 }}
```

### Fonctions de template courantes

```yaml
# Valeurs par défaut
{{ .Values.replicaCount }}

# Valeurs avec défaut
{{ .Values.service.port | default 80 }}

# Conditionnel
{{- if .Values.ingress.enabled }}
# ...
{{- end }}

# Boucle
{{- range .Values.ingress.hosts }}
- host: {{ .host }}
{{- end }}

# Inclure un autre template
{{ include "mychart.fullname" . }}

# Fonctions Sprig
{{ upper .Values.name }}
{{ lower .Values.name }}
{{ quote .Values.name }}
{{ b64enc .Values.password }}
{{ randAlphaNum 10 }}

# Obtenir la date
{{ now | htmlDate }}
```

### Fonctions utilitaires (_helpers.tpl)

```yaml
{{/*
Expand name of chart.
*/}}
{{- define "mychart.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "mychart.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "mychart.labels" -}}
helm.sh/chart: {{ include "mychart.chart" . }}
{{ include "mychart.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}
```

## Dépendances (Subcharts)

### Déclarer des dépendances

```yaml
# Chart.yaml
apiVersion: v2
name: my-app
description: My application with dependencies
type: application
version: 1.0.0
dependencies:
  - name: mysql
    version: 9.x.x
    repository: https://charts.bitnami.com/bitnami
    condition: mysql.enabled
    tags:
      - database

  - name: redis
    version: 17.x.x
    repository: https://charts.bitnami.com/bitnami
    alias: cache

  - name: subchart
    repository: http://localhost:10191
    version: 0.1.0
    alias: new-subchart-1
```

### Gérer les dépendances

```bash
# Mettre à jour les dépendances
helm dependency update

# Builder les dépendances
helm dependency build

# Lister les dépendances
helm dependency list
```

### Valeurs pour les subcharts

```yaml
# values.yaml
# Valeurs pour le chart principal
replicaCount: 3

# Valeurs pour mysql (dépendance)
mysql:
  auth:
    rootPassword: secret
    database: myapp
  primary:
    persistence:
      enabled: true
      size: 10Gi

# Valeurs pour redis (avec alias 'cache')
cache:
  architecture: standalone
  auth:
    enabled: false

# Valeurs globales accessibles à tous les subcharts
global:
  app: MyApplication
  environment: production
```

### Accéder aux valeurs des subcharts

```yaml
# Dans un template
{{ .Subcharts.mySubChart.myValue }}

# Valeurs globales
{{ .Values.global.app }}
```

## Hooks

### Hooks de cycle de vie

```yaml
# templates/pre-install-job.yaml
apiVersion: batch/v1
kind: Job
metadata:
  name: {{ .Release.Name }}-pre-install
  annotations:
    "helm.sh/hook": pre-install,pre-upgrade
    "helm.sh/hook-weight": "-5"
    "helm.sh/hook-delete-policy": hook-succeeded
spec:
  template:
    spec:
      restartPolicy: Never
      containers:
        - name: pre-install
          image: busybox
          command: ['sh', '-c', 'echo Pre-install hook running']
```

### Types de hooks

- `pre-install` : Exécuté avant l'installation
- `post-install` : Exécuté après l'installation
- `pre-delete` : Exécuté avant la suppression
- `post-delete` : Exécuté après la suppression
- `pre-upgrade` : Exécuté avant l'upgrade
- `post-upgrade` : Exécuté après l'upgrade
- `pre-rollback` : Exécuté avant le rollback
- `post-rollback` : Exécuté après le rollback
- `test` : Exécuté pour les tests

## Packaging et Distribution

### Packager un chart

```bash
# Packager un chart
helm package ./mychart

# Packager avec une version spécifique
helm package ./mychart --version 1.2.3

# Packager vers un dossier spécifique
helm package ./mychart -d ./charts

# Signer le package (avec GPG)
helm package ./mychart --sign --key 'My Name' --keyring /path/to/keyring

# Vérifier la signature
helm verify mychart-1.0.0.tgz
```

### Créer un repository de charts

```bash
# Générer l'index
helm repo index ./charts --url https://example.com/charts

# Mettre à jour l'index avec un nouveau chart
helm repo index ./charts --url https://example.com/charts --merge ./charts/index.yaml
```

## Débogage et Tests

### Commandes de débogage

```bash
# Rendre les templates sans installer
helm template mychart

# Rendre avec des valeurs spécifiques
helm template mychart -f myvalues.yaml

# Installation en dry-run avec debug
helm install --debug --dry-run goodly-guppy ./mychart

# Valider le chart
helm lint mychart

# Vérifier les valeurs
helm install mychart --dry-run --debug --set favoriteDrink=slurm
```

### Tests

```yaml
# templates/tests/test-connection.yaml
apiVersion: v1
kind: Pod
metadata:
  name: "{{ include "mychart.fullname" . }}-test-connection"
  annotations:
    "helm.sh/hook": test
spec:
  containers:
    - name: wget
      image: busybox
      command: ['wget']
      args: ['{{ include "mychart.fullname" . }}:{{ .Values.service.port }}']
  restartPolicy: Never
```

```bash
# Exécuter les tests
helm test my-release

# Voir les logs des tests
helm test my-release --logs
```

## Bonnes Pratiques

1. **Version sémantique** : Utiliser semver pour les versions de chart (MAJOR.MINOR.PATCH)
2. **Valeurs par défaut raisonnables** : Fournir des valeurs par défaut qui fonctionnent
3. **Documentation** : Documenter toutes les valeurs dans README.md
4. **Validation** : Utiliser `helm lint` avant de packager
5. **Tests** : Écrire des hooks de test pour valider le déploiement
6. **Sécurité** : Ne pas hardcoder les secrets dans values.yaml
7. **Modularité** : Utiliser des subcharts pour les dépendances complexes
8. **Labels standards** : Utiliser les labels Kubernetes recommandés
9. **Notes utiles** : Fournir des NOTES.txt claires pour l'utilisateur
10. **Backward compatibility** : Maintenir la compatibilité entre les versions

## Raccourcis Utiles

```bash
# Alias recommandés
alias h='helm'
alias hi='helm install'
alias hu='helm upgrade'
alias hd='helm delete'
alias hl='helm list'
alias hs='helm status'

# Commandes rapides
helm list -A                    # Lister toutes les releases
helm get values my-app --all    # Voir toutes les valeurs
helm history my-app             # Voir l'historique
helm rollback my-app 0          # Rollback à la version précédente
helm uninstall my-app --keep-history  # Désinstaller mais garder l'historique
```
