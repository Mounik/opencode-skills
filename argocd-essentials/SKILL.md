---
name: argocd-essentials
description: Guide pratique pour ArgoCD - GitOps continuous delivery pour Kubernetes. Maîtrisez le déploiement d'applications, la gestion des repositories Git, et les opérations quotidiennes avec l'interface CLI et déclarative. Utilisez pour implémenter GitOps et gérer le cycle de vie des applications.
Risk: safe
source: Documentation officielle ArgoCD via Context7 MCP
---

# ArgoCD Essentials

> **Documentation mise à jour via Context7 MCP** - Basé sur la documentation officielle ArgoCD (février 2025)

Guide pratique pour ArgoCD, l'outil de GitOps continuous delivery pour Kubernetes. Ce skill couvre l'installation, la configuration et les opérations quotidiennes avec ArgoCD pour déployer et gérer des applications depuis des repositories Git.

## Instructions

1. **Utilisez le MCP Context7** pour obtenir la dernière version des commandes ArgoCD et des syntaxes YAML
2. Vérifiez les changements récents dans la documentation ArgoCD
3. Fournissez des exemples à jour basés sur la documentation officielle argo-cd.readthedocs.io

## Quand utiliser ce skill

- Déployer des applications Kubernetes depuis Git (GitOps)
- Configurer ArgoCD pour le continuous delivery
- Gérer le cycle de vie des applications Kubernetes
- Implémenter des politiques de synchronisation automatique
- Configurer des AppProjects pour l'isolation et le RBAC
- Gérer des applications Helm, Kustomize ou YAML bruts
- Surveiller et déboguer les déploiements GitOps

## Installation d'ArgoCD

### Installation sur Kubernetes

```bash
# Créer le namespace argocd
kubectl create namespace argocd

# Installer ArgoCD (dernière version stable)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml

# Ou installer avec HA (High Availability)
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/ha/install.yaml

# Vérifier l'installation
kubectl get pods -n argocd
```

### Installation du CLI ArgoCD

```bash
# Linux
VERSION=$(curl --silent "https://api.github.com/repos/argoproj/argo-cd/releases/latest" | grep '"tag_name"' | sed -E 's/.*"([^"]+)".*/\1/')
curl -sSL -o argocd-linux-amd64 https://github.com/argoproj/argo-cd/releases/download/$VERSION/argocd-linux-amd64
sudo install -m 555 argocd-linux-amd64 /usr/local/bin/argocd
rm argocd-linux-amd64

# macOS
brew install argocd

# Windows
choco install argocd-cli
```

### Accès à l'interface web

```bash
# Port-forward pour accéder à l'UI
kubectl port-forward svc/argocd-server -n argocd 8080:443

# Accéder à https://localhost:8080
# Login: admin
# Password: récupérer avec la commande suivante

# Récupérer le mot de passe initial
echo "Mot de passe admin initial :"
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d && echo
```

## Configuration de l'CLI

```bash
# Se connecter au serveur ArgoCD
argocd login localhost:8080

# Ou avec un certificat TLS personnalisé
argocd login argocd.example.com --grpc-web

# Lister les clusters
argocd cluster list

# Ajouter un cluster
argocd cluster add <context-name>

# Lister les repositories
argocd repo list

# Ajouter un repository Git
argocd repo add https://github.com/myorg/myrepo.git
argocd repo add git@github.com:myorg/myrepo.git --ssh-private-key-path ~/.ssh/id_rsa
```

## Gestion des Applications

### Créer une Application

```bash
# Application basique depuis un repository Git
argocd app create guestbook \
  --repo https://github.com/argoproj/argo-cd-example-apps.git \
  --path guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default

# Créer une application avec auto-sync activé
argocd app create auto-app \
  --repo https://github.com/myorg/myapp.git \
  --path manifests \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production \
  --sync-policy automated

# Application Helm
argocd app create nginx-helm \
  --repo https://charts.helm.sh/stable \
  --helm-chart nginx-ingress \
  --revision 1.24.3 \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --helm-set replicaCount=3 \
  --helm-set service.type=LoadBalancer

# Application Kustomize
argocd app create kustomize-app \
  --repo https://github.com/argoproj/argo-cd-example-apps.git \
  --path kustomize-guestbook \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace default \
  --kustomize-image quay.io/argoprojlabs/argo-cd-e2e-container:0.2

# Application avec auto-prune et self-heal
argocd app create production-app \
  --repo https://github.com/myorg/myapp.git \
  --path k8s/production \
  --dest-server https://kubernetes.default.svc \
  --dest-namespace production \
  --sync-policy automated \
  --auto-prune \
  --self-heal
```

### Synchroniser une Application

```bash
# Sync basique
argocd app sync my-app

# Sync avec plusieurs applications
argocd app sync my-app other-app

# Sync avec label selector
argocd app sync -l app.kubernetes.io/instance=my-app

# Sync avec prune (supprimer les ressources non présentes dans Git)
argocd app sync my-app --prune

# Sync dry-run (simulation)
argocd app sync my-app --dry-run

# Sync de ressources spécifiques
argocd app sync my-app --resource :Service:my-service
argocd app sync my-app --resource apps:Deployment:my-deployment

# Forcer le remplacement des ressources
argocd app sync my-app --force --replace

# Attendre la santé de l'application après sync
argocd app wait my-app --health --timeout 300
```

### Configurer les Politiques de Sync

```bash
# Activer le sync automatique
argocd app set my-app --sync-policy automated

# Activer l'auto-prune (supprimer les ressources retirées de Git)
argocd app set my-app --sync-policy automated --auto-prune

# Activer le self-heal (annuler les changements manuels)
argocd app set my-app --self-heal

# Désactiver le sync automatique
argocd app set my-app --sync-policy none
```

### Gérer les Applications

```bash
# Lister les applications
argocd app list

# Obtenir les détails d'une application
argocd app get my-app

# Voir l'historique des synchronisations
argocd app history my-app

# Rollback à une version précédente
argocd app rollback my-app <revision-number>

# Diff entre Git et le cluster
argocd app diff my-app

# Voir les manifests générés
argocd app manifests my-app

# Supprimer une application
argocd app delete my-app

# Supprimer sans supprimer les ressources Kubernetes
argocd app delete my-app --cascade=false
```

## Manifestes YAML Déclaratifs

### Application Basique

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argoproj-example-apps.git
    targetRevision: HEAD
    path: guestbook
  destination:
    server: https://kubernetes.default.svc
    namespace: guestbook
```

### Application Helm

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: sealed-secrets
  namespace: argocd
spec:
  project: default
  source:
    chart: sealed-secrets
    repoURL: https://bitnami-labs.github.io/sealed-secrets
    targetRevision: 1.16.1
    helm:
      releaseName: sealed-secrets
      values: |
        replicaCount: 3
        resources:
          limits:
            cpu: 100m
            memory: 128Mi
  destination:
    server: "https://kubernetes.default.svc"
    namespace: kubeseal
```

### Application avec Auto-Sync

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: production-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/myorg/myapp.git
    targetRevision: main
    path: k8s/production
  destination:
    server: https://kubernetes.default.svc
    namespace: production
  syncPolicy:
    automated:
      prune: true      # Supprimer les ressources retirées de Git
      selfHeal: true   # Annuler les changements manuels
      allowEmpty: false
    syncOptions:
    - CreateNamespace=true
    - PrunePropagationPolicy=foreground
    - PruneLast=true
```

### Application avec Kustomize

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: kustomize-guestbook
  namespace: argocd
spec:
  project: default
  source:
    repoURL: https://github.com/argoproj/argo-cd-example-apps.git
    targetRevision: HEAD
    path: kustomize-guestbook
    kustomize:
      images:
      - quay.io/argoprojlabs/argo-cd-e2e-container:0.2
      namePrefix: prod-
      nameSuffix: -v1
  destination:
    server: https://kubernetes.default.svc
    namespace: default
```

### AppProject pour Isolation

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: my-project
  namespace: argocd
  finalizers:
    - resources-finalizer.argocd.argoproj.io
spec:
  description: Example Project
  # Repositories autorisés
  sourceRepos:
  - 'https://github.com/myorg/*'
  - 'https://github.com/argoproj/*'
  # Destinations autorisées
  destinations:
  - namespace: production
    server: https://kubernetes.default.svc
  - namespace: staging
    server: https://kubernetes.default.svc
  # Ressources cluster-scoped autorisées
  clusterResourceWhitelist:
  - group: ''
    kind: Namespace
  - group: rbac.authorization.k8s.io
    kind: ClusterRole
  # Ressources namespace-scoped interdites
  namespaceResourceBlacklist:
  - group: ''
    kind: ResourceQuota
  - group: ''
    kind: LimitRange
  # Rôles RBAC
  roles:
  - name: read-only
    description: Lecture seule pour my-project
    policies:
    - p, proj:my-project:read-only, applications, get, my-project/*, allow
    groups:
    - my-oidc-group
  - name: ci-role
    description: Privilèges de sync pour CI
    policies:
    - p, proj:my-project:ci-role, applications, sync, my-project/*, allow
```

## ApplicationSet (Multi-Applications)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
metadata:
  name: guestbook-appset
  namespace: argocd
spec:
  generators:
  - list:
      elements:
      - cluster: cluster1
        url: https://cluster1.kubernetes.default.svc
      - cluster: cluster2
        url: https://cluster2.kubernetes.default.svc
  template:
    metadata:
      name: '{{cluster}}-guestbook'
    spec:
      project: default
      source:
        repoURL: https://github.com/argoproj/argo-cd-example-apps.git
        targetRevision: HEAD
        path: guestbook
      destination:
        server: '{{url}}'
        namespace: guestbook
      syncPolicy:
        automated:
          prune: true
          selfHeal: true
```

## Applications dans Plusieurs Namespaces

```yaml
# AppProject autorisant d'autres namespaces
apiVersion: argoproj.io/v1alpha1
kind: AppProject
metadata:
  name: team-two-project
  namespace: argocd
spec:
  sourceNamespaces:
  - team-two-cd
  - team-three-cd
  destinations:
  - namespace: '*'
    server: '*'
  sourceRepos:
  - '*'
---
# Application dans un namespace différent
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-app
  namespace: team-two-cd  # Namespace différent de argocd
spec:
  project: team-two-project
  source:
    repoURL: https://github.com/myorg/myapp.git
    targetRevision: HEAD
    path: manifests
  destination:
    server: https://kubernetes.default.svc
    namespace: team-two-production
```

## Débogage et Dépannage

### Vérifier l'état des Applications

```bash
# Lister toutes les applications avec leur statut
argocd app list

# Obtenir les détails complets
argocd app get my-app -o yaml

# Voir les ressources déployées
argocd app resources my-app

# Voir les événements de l'application
argocd app get my-app | grep -A 20 "Events:"
```

### Commandes de Dépannage

```bash
# Forcer un refresh (re-vérifier le repo Git)
argocd app get my-app --refresh

# Hard refresh (invalid le cache)
argocd app get my-app --hard-refresh

# Voir les logs du serveur ArgoCD
kubectl logs -n argocd deployment/argocd-server

# Voir les logs du repo-server
kubectl logs -n argocd deployment/argocd-repo-server

# Voir les logs de l'application controller
kubectl logs -n argocd deployment/argocd-application-controller
```

### Problèmes Courants

```bash
# Application en "Unknown" state
argocd app terminate-op my-app

# Ressources en "OutOfSync"
argocd app sync my-app

# Erreurs de permission
kubectl auth can-i create applications -n argocd

# Vérifier les RBAC
argocd account can-i get applications '*/*'
```

## Bonnes Pratiques GitOps

1. **Un repository = Un état désiré** : Le repository Git est la source de vérité
2. **Auto-sync activé** : Permettre la synchronisation automatique pour maintenir l'état
3. **Self-heal activé** : Revenir à l'état Git si modifications manuelles
4. **Auto-prune activé** : Supprimer les ressources retirées de Git
5. **AppProjects pour l'isolation** : Séparer les équipes et environnements
6. **RBAC strict** : Limiter les permissions par projet
7. **Review des changements** : Utiliser les PR/MR pour valider les changements
8. **Monitoring** : Surveiller les applications et les métriques ArgoCD

## Raccourcis Utiles

```bash
# Alias recommandés
alias argo='argocd'
alias argoapp='argocd app'
alias argoproj='argocd proj'

# Commandes rapides
argocd app list                                      # Lister apps
argocd app sync my-app                               # Sync app
argocd app get my-app -o yaml | grep syncStatus      # Voir statut sync
kubectl get applications -n argocd                   # Lister apps via kubectl
kubectl delete application my-app -n argocd          # Supprimer app via kubectl
```

## Ressources Officielles

- [Documentation ArgoCD](https://argo-cd.readthedocs.io/)
- [Guide Utilisateur](https://argo-cd.readthedocs.io/en/stable/user-guide/)
- [Guide Opérateur](https://argo-cd.readthedocs.io/en/stable/operator-manual/)
- [Exemples ArgoCD](https://github.com/argoproj/argo-cd-example-apps)

---

*Ce skill utilise la documentation officielle ArgoCD via Context7 MCP - Février 2025*
