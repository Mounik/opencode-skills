---
name: kubernetes-essentials
description: Guide pratique et opérationnel pour Kubernetes avec kubectl. Maîtrisez les commandes essentielles, les manifestes YAML, et les opérations quotidiennes sur les clusters
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: devops
---

# Kubernetes Essentials

## Ce que je fais

- Guide complet pour les opérations Kubernetes quotidiennes
- Commandes kubectl essentielles
- Manifestes YAML pour les ressources Kubernetes
- Gestion des pods, deployments, services
- Configuration de ConfigMaps et Secrets
- Gestion de l'Ingress et du networking
- Débogage et dépannage d'applications Kubernetes

## Quand m'utiliser

- Déployer des applications conteneurisées sur Kubernetes
- Créer et gérer des pods, deployments, services
- Déboguer des applications Kubernetes
- Configurer des ConfigMaps et Secrets
- Gérer l'Ingress et le networking
- Opérations quotidiennes de maintenance

## Instructions

1. **Utilisez le MCP Context7** pour obtenir la dernière version des commandes kubectl et des syntaxes YAML
2. Vérifiez les changements récents dans la documentation Kubernetes
3. Fournissez des exemples à jour basés sur la documentation officielle kubernetes.io

## Installation de kubectl

### Linux

```bash
# Télécharger la dernière version
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"

# Rendre exécutable
chmod +x kubectl

# Déplacer dans le PATH
sudo mv kubectl /usr/local/bin/

# Vérifier l'installation
kubectl version --client
```

### macOS

```bash
# Via Homebrew
brew install kubectl

# Ou téléchargement direct
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/darwin/amd64/kubectl"
```

### Windows

```powershell
# Via Chocolatey
choco install kubernetes-cli

# Ou via winget
winget install --id Kubernetes.kubectl
```

## Configuration de kubectl

```bash
# Voir la configuration actuelle
kubectl config view

# Lister les contextes (clusters)
kubectl config get-contexts

# Changer de contexte
kubectl config use-context <context-name>

# Définir le namespace par défaut
kubectl config set-context --current --namespace=<namespace-name>
```

## Commandes Essentielles kubectl

### Informations sur le Cluster

```bash
# Informations sur le cluster
kubectl cluster-info

# Version du serveur et du client
kubectl version

# Nœuds du cluster
kubectl get nodes
kubectl get nodes -o wide

# Nœuds détaillés
kubectl describe node <node-name>
```

### Gestion des Pods

```bash
# Lister les pods
kubectl get pods
kubectl get pods -o wide
kubectl get pods --all-namespaces

# Lister les pods avec plus d'informations
kubectl get pods -o wide

# Lister les pods sur un nœud spécifique
kubectl get pods --field-selector=spec.nodeName=<node-name>

# Détails d'un pod
kubectl describe pod <pod-name>

# Logs d'un pod
kubectl logs <pod-name>
kubectl logs <pod-name> -f  # Suivi en temps réel
kubectl logs <pod-name> --previous  # Logs du conteneur précédent (après restart)

# Exécuter une commande dans un pod
kubectl exec <pod-name> -- <command>
kubectl exec <pod-name> -it -- /bin/sh  # Shell interactif

# Créer un pod rapidement (éphémère)
kubectl run nginx --image=nginx
kubectl run busybox --image=busybox --restart=Never -- sleep 3600

# Supprimer un pod
kubectl delete pod <pod-name>
```

### Gestion des Deployments

```bash
# Lister les deployments
kubectl get deployments
kubectl get deployment <deployment-name>

# Détails d'un deployment
kubectl describe deployment <deployment-name>

# Scale un deployment
kubectl scale deployment <deployment-name> --replicas=5

# Mettre à jour l'image d'un deployment
kubectl set image deployment/<deployment-name> <container-name>=<new-image>:<tag>

# Rollout d'un deployment
kubectl rollout status deployment/<deployment-name>
kubectl rollout history deployment/<deployment-name>
kubectl rollout undo deployment/<deployment-name>

# Supprimer un deployment
kubectl delete deployment <deployment-name>
```

### Gestion des Services

```bash
# Lister les services
kubectl get services
kubectl get svc

# Détails d'un service
kubectl describe service <service-name>

# Supprimer un service
kubectl delete service <service-name>
```

### Gestion des ConfigMaps et Secrets

```bash
# ConfigMaps
kubectl get configmaps
kubectl describe configmap <configmap-name>
kubectl delete configmap <configmap-name>

# Secrets
kubectl get secrets
kubectl describe secret <secret-name>
kubectl delete secret <secret-name>

# Créer un secret à partir de fichiers littéraux
kubectl create secret generic <secret-name> \
  --from-literal=username=admin \
  --from-literal=password='secret-password'

# Créer un secret à partir d'un fichier
kubectl create secret generic <secret-name> --from-file=./config.json
```

### Gestion des Namespaces

```bash
# Lister les namespaces
kubectl get namespaces
kubectl get ns

# Créer un namespace
kubectl create namespace <namespace-name>

# Supprimer un namespace
kubectl delete namespace <namespace-name>

# Toutes les ressources dans un namespace
kubectl get all -n <namespace-name>
```

### Gestion des Ingress

```bash
# Lister les ingress
kubectl get ingress
kubectl get ingress -n <namespace-name>

# Détails d'un ingress
kubectl describe ingress <ingress-name>

# Supprimer un ingress
kubectl delete ingress <ingress-name>
```

## Manifestes YAML Essentiels

### Pod Simple

```yaml
apiVersion: v1
kind: Pod
metadata:
  name: nginx-pod
  labels:
    app: nginx
spec:
  containers:
  - name: nginx
    image: nginx:latest
    ports:
    - containerPort: 80
```

### Deployment

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
  labels:
    app: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        ports:
        - containerPort: 8080
        resources:
          requests:
            memory: "128Mi"
            cpu: "100m"
          limits:
            memory: "256Mi"
            cpu: "200m"
```

### Service ClusterIP

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-service
spec:
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
  type: ClusterIP
```

### Service NodePort

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-nodeport-service
spec:
  type: NodePort
  selector:
    app: my-app
  ports:
    - port: 80
      targetPort: 8080
      nodePort: 30007
```

### Service LoadBalancer

```yaml
apiVersion: v1
kind: Service
metadata:
  name: my-loadbalancer-service
spec:
  type: LoadBalancer
  selector:
    app: my-app
  ports:
    - protocol: TCP
      port: 80
      targetPort: 8080
```

### ConfigMap

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: app-config
data:
  database.properties: |
    database.url=jdbc:mysql://localhost:3306/mydb
    database.user=admin
  app.properties: |
    app.name=my-application
    app.version=1.0.0
```

### Secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: app-secrets
type: Opaque
data:
  # Les valeurs doivent être encodées en base64
  username: YWRtaW4=  # admin
  password: c2VjcmV0  # secret
```

### Ingress

```yaml
apiVersion: networking.k8s.io/v1
kind: Ingress
metadata:
  name: minimal-ingress
  annotations:
    nginx.ingress.kubernetes.io/rewrite-target: /
spec:
  ingressClassName: nginx
  rules:
  - host: myapp.example.com
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: my-service
            port:
              number: 80
```

### Deployment avec ConfigMap et Secret

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: my-app
spec:
  replicas: 3
  selector:
    matchLabels:
      app: my-app
  template:
    metadata:
      labels:
        app: my-app
    spec:
      containers:
      - name: my-app
        image: my-app:latest
        ports:
        - containerPort: 8080
        env:
        - name: DATABASE_URL
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: database.url
        - name: DATABASE_USER
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: username
        - name: DATABASE_PASSWORD
          valueFrom:
            secretKeyRef:
              name: app-secrets
              key: password
        volumeMounts:
        - name: config-volume
          mountPath: /etc/config
      volumes:
      - name: config-volume
        configMap:
          name: app-config
```

## Débogage et Dépannage

### Vérifier l'état des ressources

```bash
# Événements du cluster (erreurs, warnings)
kubectl get events --sort-by='.lastTimestamp'
kubectl get events --field-selector type=Warning

# Pods en échec
kubectl get pods --all-namespaces | grep -v Running

# Détails d'un pod (pour voir les erreurs)
kubectl describe pod <pod-name>

# Top des ressources
kubectl top nodes
kubectl top pods
kubectl top pods --all-namespaces
```

### Logs et Debugging

```bash
# Logs d'un pod spécifique
kubectl logs <pod-name>

# Logs d'un conteneur spécifique dans un pod multi-conteneurs
kubectl logs <pod-name> -c <container-name>

# Logs de tous les pods d'un deployment
kubectl logs -l app=<app-label>

# Logs avec timestamps
kubectl logs <pod-name> --timestamps

# Logs depuis une heure spécifique
kubectl logs <pod-name> --since=1h
```

### Exécution de commandes de débogage

```bash
# Shell dans un pod
kubectl exec -it <pod-name> -- /bin/sh
kubectl exec -it <pod-name> -- /bin/bash

# Commande spécifique
kubectl exec <pod-name> -- ps aux
kubectl exec <pod-name> -- cat /etc/os-release

# Copier des fichiers depuis/vers un pod
kubectl cp <pod-name>:/path/to/file ./local-file
kubectl cp ./local-file <pod-name>:/path/to/file
```

### Port Forwarding

```bash
# Forwarder un port local vers un pod
kubectl port-forward <pod-name> 8080:80

# Forwarder un port local vers un service
kubectl port-forward svc/<service-name> 8080:80

# Forwarder un port local vers un deployment
kubectl port-forward deployment/<deployment-name> 8080:80
```

## Bonnes Pratiques

1. **Utilisez toujours des manifests YAML** plutôt que des commandes impératives pour la production
2. **Versionnez vos manifests** dans Git (GitOps)
3. **Utilisez des labels** pour organiser vos ressources
4. **Définissez des ressources (CPU/Memory)** pour tous les conteneurs
5. **Utilisez des Health Checks** (liveness et readiness probes)
6. **Limitez les privilèges** des conteneurs (runAsNonRoot, readOnlyRootFilesystem)
7. **Utilisez des Namespaces** pour isoler les environnements
8. **Surveillez les logs et métriques**

## Commandes Rapides (Cheat Sheet)

```bash
# Apply
kubectl apply -f manifest.yaml
kubectl apply -f ./directory/
kubectl apply -f https://example.com/manifest.yaml

# Get
kubectl get all
kubectl get all -n <namespace>
kubectl get events --sort-by='.lastTimestamp'

# Delete
kubectl delete -f manifest.yaml
kubectl delete pod <pod-name> --force --grace-period=0

# Edit
kubectl edit deployment <deployment-name>

# Expose
kubectl expose deployment <deployment-name> --type=LoadBalancer --port=80

# Run
kubectl run -it --rm debug --image=busybox --restart=Never -- /bin/sh
```
