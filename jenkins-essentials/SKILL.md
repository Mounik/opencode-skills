---
name: jenkins-essentials
description: Guide pratique pour Jenkins - Le serveur d'automatisation open-source. Maîtrisez les pipelines Jenkinsfile, les stages, les agents et l'intégration continue
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: devops
---

# Jenkins Essentials

## Ce que je fais

- Guide complet pour Jenkins, le serveur d'automatisation open-source
- Installation et configuration de Jenkins
- Création de pipelines déclaratifs (Jenkinsfile)
- Gestion des agents et des nœuds
- Configuration des triggers et des webhooks
- Utilisation des shared libraries
- Implémentation de pipelines multibranch
- Meilleures pratiques pour CI/CD

## Quand m'utiliser

- Créer et configurer des pipelines Jenkins
- Écrire des Jenkinsfiles pour CI/CD
- Configurer des builds automatiques
- Mettre en place des tests automatisés
- Déployer des applications via Jenkins
- Gérer des agents et nœuds Jenkins
- Configurer des webhooks et triggers
- Utiliser des shared libraries Jenkins

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière version de la syntaxe Jenkins Pipeline et des plugins
2. Vérifiez les changements récents dans la documentation Jenkins officielle
3. Fournissez des exemples à jour basés sur les meilleures pratiques Jenkins

## Installation de Jenkins

### Installation sur Linux (Ubuntu/Debian)

```bash
# Ajouter la clé GPG de Jenkins
curl -fsSL https://pkg.jenkins.io/debian/jenkins.io-2023.key | sudo tee \
  /usr/share/keyrings/jenkins-keyring.asc > /dev/null

# Ajouter le dépôt Jenkins
echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
  https://pkg.jenkins.io/debian binary/ | sudo tee \
  /etc/apt/sources.list.d/jenkins.list > /dev/null

# Mettre à jour et installer
sudo apt-get update
sudo apt-get install jenkins

# Démarrer le service
sudo systemctl start jenkins
sudo systemctl enable jenkins
```

### Installation avec Docker

```bash
# Lancer Jenkins avec Docker
docker run -d -p 8080:8080 -p 50000:50000 \
  -v jenkins_home:/var/jenkins_home \
  --name jenkins \
  jenkins/jenkins:lts

# Obtenir le mot de passe initial
docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword
```

### Installation sur macOS

```bash
# Via Homebrew
brew install jenkins-lts

# Démarrer Jenkins
brew services start jenkins-lts
```

### Configuration Initiale

```bash
# Ouvrir Jenkins dans le navigateur
http://localhost:8080

# Récupérer le mot de passe initial (sans Docker)
sudo cat /var/lib/jenkins/secrets/initialAdminPassword

# Installer les plugins suggérés
# Créer un utilisateur admin
```

## Structure d'un Pipeline Jenkins

### Pipeline Déclaratif Basique

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
                sh 'make'
            }
        }
        stage('Test') {
            steps {
                echo 'Testing...'
                sh 'make check'
            }
        }
        stage('Deploy') {
            steps {
                echo 'Deploying...'
                sh 'make publish'
            }
        }
    }
}
```

### Pipeline avec Options

```groovy
pipeline {
    agent any
    
    options {
        skipStagesAfterUnstable()
        buildDiscarder(logRotator(numToKeepStr: '5'))
        timestamps()
    }
    
    stages {
        stage('Build') {
            steps {
                sh 'make'
            }
        }
        stage('Test') {
            steps {
                sh 'make check'
                junit 'reports/**/*.xml'
            }
        }
        stage('Deploy') {
            steps {
                sh 'make publish'
            }
        }
    }
}
```

## Directives Principales

### Agent

```groovy
// Utiliser n'importe quel agent disponible
pipeline {
    agent any
    // ...
}

// Utiliser un agent spécifique
pipeline {
    agent {
        label 'linux-agent'
    }
    // ...
}

// Utiliser un conteneur Docker
pipeline {
    agent {
        docker {
            image 'node:18-alpine'
            args '-v /home/jenkins:/home/jenkins'
        }
    }
    // ...
}

// Utiliser un Dockerfile
pipeline {
    agent {
        dockerfile {
            filename 'Dockerfile.build'
            dir 'build'
            label 'linux-agent'
        }
    }
    // ...
}

// Pas d'agent global (défini par stage)
pipeline {
    agent none
    stages {
        stage('Build') {
            agent {
                label 'linux-agent'
            }
            steps {
                sh 'make'
            }
        }
    }
}
```

### Stages et Steps

```groovy
pipeline {
    agent any
    
    stages {
        // Stage simple
        stage('Build') {
            steps {
                echo 'Building application...'
                sh 'npm install'
                sh 'npm run build'
            }
        }
        
        // Stage avec condition
        stage('Deploy to Staging') {
            when {
                branch 'develop'
            }
            steps {
                sh 'deploy staging'
            }
        }
        
        // Stage parallèle
        stage('Tests') {
            parallel {
                stage('Unit Tests') {
                    steps {
                        sh 'npm run test:unit'
                    }
                }
                stage('Integration Tests') {
                    steps {
                        sh 'npm run test:integration'
                    }
                }
                stage('E2E Tests') {
                    steps {
                        sh 'npm run test:e2e'
                    }
                }
            }
        }
        
        // Stage avec input
        stage('Deploy to Production') {
            steps {
                input message: 'Deploy to production?', ok: 'Deploy'
                sh 'deploy production'
            }
        }
    }
}
```

### Environment

```groovy
pipeline {
    agent any
    
    environment {
        NODE_VERSION = '18'
        DEPLOY_ENV = 'production'
        API_KEY = credentials('api-key-credentials')
    }
    
    stages {
        stage('Build') {
            environment {
                STAGE_SPECIFIC_VAR = 'value'
            }
            steps {
                echo "Node version: ${env.NODE_VERSION}"
                echo "Deploying to: ${env.DEPLOY_ENV}"
                sh 'printenv'
            }
        }
    }
}
```

### Paramètres

```groovy
pipeline {
    agent any
    
    parameters {
        string(name: 'PERSON', defaultValue: 'Mr Jenkins', 
               description: 'Who should I say hello to?')
        
        text(name: 'BIOGRAPHY', defaultValue: '', 
             description: 'Enter some information about the person')
        
        booleanParam(name: 'TOGGLE', defaultValue: true, 
                     description: 'Toggle this value')
        
        choice(name: 'CHOICE', choices: ['One', 'Two', 'Three'], 
               description: 'Pick something')
        
        password(name: 'PASSWORD', defaultValue: 'SECRET', 
                 description: 'Enter a password')
        
        file(name: 'FILE', description: 'Upload a file')
    }
    
    stages {
        stage('Example') {
            steps {
                echo "Hello ${params.PERSON}"
                echo "Biography: ${params.BIOGRAPHY}"
                echo "Toggle: ${params.TOGGLE}"
                echo "Choice: ${params.CHOICE}"
            }
        }
    }
}
```

## Conditions (When)

### Conditions Basiques

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
        
        stage('Deploy to Production') {
            when {
                branch 'production'
            }
            steps {
                echo 'Deploying to production...'
            }
        }
        
        stage('Deploy to Staging') {
            when {
                branch 'staging'
            }
            steps {
                echo 'Deploying to staging...'
            }
        }
    }
}
```

### Conditions Composées

```groovy
pipeline {
    agent any
    
    stages {
        stage('Deploy') {
            when {
                // Toutes les conditions doivent être vraies
                allOf {
                    branch 'production'
                    environment name: 'DEPLOY_TO', value: 'production'
                }
            }
            steps {
                echo 'Deploying...'
            }
        }
        
        stage('Deploy Any') {
            when {
                // Au moins une condition doit être vraie
                anyOf {
                    branch 'production'
                    branch 'staging'
                    environment name: 'DEPLOY_TO', value: 'production'
                }
            }
            steps {
                echo 'Deploying...'
            }
        }
        
        stage('Complex Deploy') {
            when {
                branch 'production'
                anyOf {
                    environment name: 'DEPLOY_TO', value: 'production'
                    environment name: 'DEPLOY_TO', value: 'staging'
                }
            }
            steps {
                echo 'Deploying...'
            }
        }
    }
}
```

### Conditions avec Expressions

```groovy
pipeline {
    agent any
    
    stages {
        stage('Example') {
            when {
                expression {
                    return params.DEBUG_BUILD == true
                }
            }
            steps {
                echo 'Debug build enabled'
            }
        }
        
        stage('Not Production') {
            when {
                not {
                    branch 'production'
                }
            }
            steps {
                echo 'Not on production branch'
            }
        }
    }
}
```

## Actions Post-Pipeline

```groovy
pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                sh 'make'
            }
        }
    }
    
    post {
        // Toujours exécuté
        always {
            echo 'This will always run'
            junit 'reports/**/*.xml'
            cleanWs()
        }
        
        // Exécuté uniquement si succès
        success {
            echo 'Pipeline succeeded!'
            slackSend(color: 'good', message: 'Build succeeded!')
        }
        
        // Exécuté uniquement en cas d'échec
        failure {
            echo 'Pipeline failed!'
            slackSend(color: 'danger', message: 'Build failed!')
        }
        
        // Exécuté si instable
        unstable {
            echo 'Pipeline is unstable'
        }
        
        // Exécuté si changement d'état
        changed {
            echo 'Pipeline status changed'
        }
        
        // Exécuté si succès ou instable
        fixed {
            echo 'Pipeline was fixed'
        }
        
        // Exécuté si échec ou instable
        regression {
            echo 'Pipeline regressed'
        }
        
        // Exécuté si aborted
        aborted {
            echo 'Pipeline aborted'
        }
    }
}
```

## Triggers

```groovy
pipeline {
    agent any
    
    triggers {
        // Déclenchement par cron
        cron('H 4/* 0 0 1-5')
        
        // Déclenchement par webhook (GitHub, GitLab, etc.)
        githubPush()
        
        // Déclenchement périodique sur branche
        pollSCM('H/5 * * * *')
        
        // Déclenchement upstream
        upstream(upstreamProjects: 'job1,job2', threshold: hudson.model.Result.SUCCESS)
    }
    
    stages {
        stage('Build') {
            steps {
                echo 'Building...'
            }
        }
    }
}
```

## Steps Courants

### Commandes Shell

```groovy
stage('Commands') {
    steps {
        // Commande shell simple
        sh 'echo "Hello World"'
        
        // Commande shell multiligne
        sh '''
            echo "Line 1"
            echo "Line 2"
            ./script.sh
        '''
        
        // Commande Windows
        bat 'echo Hello Windows'
        
        // PowerShell
        powershell 'Write-Output "Hello PowerShell"'
        
        // Avec retour de code
        sh script: 'make', returnStatus: true
        
        // Avec sortie
        script {
            def output = sh(script: 'echo "Hello"', returnStdout: true).trim()
            echo "Output: ${output}"
        }
    }
}
```

### Gestion des Artifacts

```groovy
stage('Artifacts') {
    steps {
        // Archiver des artifacts
        archiveArtifacts artifacts: 'build/**/*', fingerprint: true
        
        // Stash (pour partager entre stages/agents)
        stash includes: 'build/**/*', name: 'build-artifacts'
        
        // Unstash
        unstash 'build-artifacts'
        
        // Copier artifacts depuis un autre job
        copyArtifacts projectName: 'upstream-job',
                      selector: specific('${BUILD_NUMBER}'),
                      filter: '**/*.jar'
    }
}
```

### Tests et Rapports

```groovy
stage('Tests') {
    steps {
        // Tests JUnit
        junit 'reports/**/*.xml'
        
        // Couverture de code (JaCoCo)
        jacoco execPattern: 'build/jacoco/*.exec'
        
        // Tests avec timeout
        timeout(time: 10, unit: 'MINUTES') {
            sh 'make test'
        }
        
        // Retry en cas d'échec
        retry(3) {
            sh 'flakey-test.sh'
        }
    }
}
```

### Notifications

```groovy
stage('Notifications') {
    steps {
        // Email
        mail to: 'team@example.com',
             subject: "Job '${env.JOB_NAME}' (${env.BUILD_NUMBER})",
             body: "Voir ${env.BUILD_URL}"
        
        // Slack
        slackSend(color: 'good', message: 'Build succeeded!')
        
        // Mattermost
        mattermostSend(color: '#00ff00', message: 'Build succeeded!')
    }
}
```

## Shared Libraries

### Configuration

```groovy
// Dans Jenkins > Manage Jenkins > Configure System > Global Pipeline Libraries
// Nom: my-shared-library
// Default version: main
// Retrieval method: Modern SCM
// Source Code Management: Git
// Project Repository: https://github.com/org/shared-library.git
```

### Structure d'une Shared Library

```
(shared-library repo)
├── vars/
│   ├── buildAndDeploy.groovy
│   └── sayHello.groovy
├── src/
│   └── org/foo/
│       └── Utilities.groovy
└── resources/
    └── template.json
```

### Utilisation dans un Pipeline

```groovy
@Library('my-shared-library') _

pipeline {
    agent any
    
    stages {
        stage('Build') {
            steps {
                // Utiliser une fonction de la shared library
                buildAndDeploy()
                
                // Avec paramètres
                sayHello(name: 'Jenkins')
            }
        }
    }
}
```

### Exemple de Shared Library

```groovy
// vars/buildAndDeploy.groovy
def call(Map config = [:]) {
    def environment = config.environment ?: 'dev'
    def version = config.version ?: 'latest'
    
    pipeline {
        agent any
        
        stages {
            stage('Build') {
                steps {
                    echo "Building for ${environment}..."
                    sh "docker build -t app:${version} ."
                }
            }
            stage('Deploy') {
                steps {
                    echo "Deploying to ${environment}..."
                    sh "deploy ${environment} ${version}"
                }
            }
        }
    }
}

// vars/sayHello.groovy
def call(Map config = [:]) {
    def name = config.name ?: 'World'
    echo "Hello, ${name}!"
}
```

## Multibranch Pipeline

### Configuration du Jenkinsfile

```groovy
// Jenkinsfile à la racine du repository
pipeline {
    agent any
    
    options {
        // Options spécifiques au multibranch
        disableConcurrentBuilds()
    }
    
    stages {
        stage('Build') {
            steps {
                echo "Building branch: ${env.BRANCH_NAME}"
                sh 'make'
            }
        }
        
        stage('Test') {
            steps {
                sh 'make test'
            }
        }
        
        stage('Deploy') {
            when {
                anyOf {
                    branch 'main'
                    branch 'production'
                }
            }
            steps {
                sh 'make deploy'
            }
        }
    }
    
    post {
        always {
            // Actions de nettoyage
            cleanWs()
        }
    }
}
```

## Bonnes Pratiques

1. **Utilisez des agents spécifiques** plutôt que `agent any`
2. **Versionnez vos Jenkinsfiles** dans Git
3. **Utilisez des shared libraries** pour éviter la duplication
4. **Limitez le nombre de stages** pour des pipelines lisibles
5. **Utilisez des credentials** pour les secrets, jamais en dur
6. **Nettoyez les workspaces** après les builds
7. **Utilisez des timeouts** pour éviter les builds bloqués
8. **Archivez les artifacts** importants
9. **Testez vos pipelines** dans un environnement de test
10. **Documentez vos pipelines** avec des commentaires
