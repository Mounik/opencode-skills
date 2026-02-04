---
name: terraform-essentials
description: Guide pratique pour Terraform - L'outil d'infrastructure as code. Maîtrisez la gestion de l'infrastructure cloud, les providers, les modules et le workflow Terraform
license: MIT
compatibility: opencode
metadata:
  audience: developers
  workflow: devops
---

# Terraform Essentials

## Ce que je fais

- Guide complet pour Terraform, l'outil d'infrastructure as code (IaC) open-source
- Installation et configuration de Terraform
- Création de configurations HCL
- Gestion des providers et des modules
- Workflow complet pour provisionner et gérer l'infrastructure
- Gestion de l'état (state)
- Utilisation de workspaces pour multi-environnements
- Bonnes pratiques pour l'IaC

## Quand m'utiliser

- Provisionner de l'infrastructure cloud (AWS, Azure, GCP)
- Gérer l'infrastructure as code
- Créer et gérer des configurations Terraform
- Déployer des ressources réseau, compute, storage
- Gérer l'état de l'infrastructure (state)
- Créer des modules Terraform réutilisables
- Gérer plusieurs environnements (dev/staging/prod)
- Migrer de l'infrastructure existante vers Terraform

## Instructions

1. Utilisez le MCP Context7 pour obtenir la dernière version des providers Terraform et de la syntaxe HCL
2. Vérifiez les changements récents dans la documentation Terraform officielle
3. Fournissez des exemples à jour basés sur les meilleures pratiques HashiCorp

## Installation de Terraform

### Linux (Ubuntu/Debian)

```bash
# Installer via apt
wget -O- https://apt.releases.hashicorp.com/gpg | sudo gpg --dearmor -o /usr/share/keyrings/hashicorp-archive-keyring.gpg
echo "deb [signed-by=/usr/share/keyrings/hashicorp-archive-keyring.gpg] https://apt.releases.hashicorp.com $(lsb_release -cs) main" | sudo tee /etc/apt/sources.list.d/hashicorp.list > /dev/null
sudo apt update && sudo apt install terraform

# Vérifier l'installation
terraform version
```

### macOS

```bash
# Via Homebrew
brew tap hashicorp/tap
brew install hashicorp/tap/terraform

# Vérifier l'installation
terraform version
```

### CentOS/RHEL

```bash
# Installer via yum
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
sudo yum -y install terraform

# Vérifier l'installation
terraform version
```

### Windows

```powershell
# Via Chocolatey
choco install terraform

# Via Winget
winget install HashiCorp.Terraform
```

### Vérification

```bash
# Voir la version
terraform version

# Voir l'aide
terraform --help

# Voir la liste des commandes
terraform
```

## Structure d'un Projet Terraform

```
project/
├── main.tf           # Ressources principales
├── variables.tf      # Définition des variables
├── outputs.tf        # Valeurs de sortie
├── providers.tf      # Configuration des providers
├── terraform.tfvars  # Valeurs des variables
├── backend.tf        # Configuration du backend
└── modules/          # Modules locaux
    └── vpc/
        ├── main.tf
        ├── variables.tf
        └── outputs.tf
```

## Workflow Terraform

### 1. Initialisation

```bash
# Initialiser le projet (télécharger les providers)
terraform init

# Initialiser et migrer le backend
terraform init -migrate-state

# Réinitialiser (nettoyer et re-télécharger)
terraform init -upgrade
```

### 2. Formatage et Validation

```bash
# Formater le code
terraform fmt

# Formater récursivement
terraform fmt -recursive

# Valider la configuration
terraform validate
```

### 3. Planification

```bash
# Voir le plan d'exécution
terraform plan

# Sauvegarder le plan dans un fichier
terraform plan -out=tfplan

# Plan avec variables
terraform plan -var="region=us-west-2"
terraform plan -var-file="production.tfvars"
```

### 4. Application

```bash
# Appliquer les changements
terraform apply

# Appliquer sans confirmation
terraform apply -auto-approve

# Appliquer un plan sauvegardé
terraform apply tfplan

# Cibler une ressource spécifique
terraform apply -target=aws_instance.web
```

### 5. Destruction

```bash
# Détruire toute l'infrastructure
terraform destroy

# Détruire sans confirmation
terraform destroy -auto-approve

# Détruire une ressource spécifique
terraform destroy -target=aws_instance.web
```

## Configuration HCL

### Fichier principal (main.tf)

```hcl
# Définir le provider
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

required_version = ">= 1.2.0"
}

# Configurer le provider AWS
provider "aws" {
  region = var.aws_region
}

# Créer une ressource EC2
resource "aws_instance" "web" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  tags = {
    Name = "Web Server"
    Environment = "Production"
  }
}
```

### Variables (variables.tf)

```hcl
# Variable simple
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

# Variable avec validation
variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"

  validation {
    condition     = contains(["t2.micro", "t2.small", "t2.medium"], var.instance_type)
    error_message = "Instance type must be t2.micro, t2.small, or t2.medium."
  }
}

# Variable de type liste
variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

# Variable de type map
variable "instance_tags" {
  description = "Tags for instances"
  type        = map(string)
  default     = {
    Environment = "Production"
    Team        = "DevOps"
  }
}

# Variable booléenne
variable "enable_monitoring" {
  description = "Enable detailed monitoring"
  type        = bool
  default     = true
}

# Variable sensible
variable "db_password" {
  description = "Database password"
  type        = string
  sensitive   = true
}
```

### Valeurs des variables (terraform.tfvars)

```hcl
# terraform.tfvars
aws_region      = "us-west-2"
instance_type   = "t2.small"
db_password     = "supersecretpassword123"

availability_zones = ["us-west-2a", "us-west-2b"]

instance_tags = {
  Environment = "Staging"
  Team        = "Platform"
  CostCenter  = "IT-123"
}
```

### Outputs (outputs.tf)

```hcl
# Output simple
output "instance_id" {
  description = "ID of EC2 instance"
  value       = aws_instance.web.id
}

# Output d'une liste
output "instance_ips" {
  description = "Public IPs of all instances"
  value       = aws_instance.web.*.public_ip
}

# Output sensible
output "db_password" {
  description = "Database password"
  value       = var.db_password
  sensitive   = true
}

# Output avec condition
output "load_balancer_dns" {
  description = "DNS name of load balancer"
  value       = var.create_lb ? aws_lb.main[0].dns_name : null
}
```

## Ressources et Providers

### Créer des ressources

```hcl
# Ressource AWS EC2
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  root_block_device {
    volume_size = 20
    volume_type = "gp3"
  }

  tags = {
    Name = "Example Instance"
  }
}

# Ressource AWS S3 Bucket
resource "aws_s3_bucket" "example" {
  bucket = "my-unique-bucket-name"

  tags = {
    Environment = "Production"
  }
}

# Ressource avec dépendance explicite
resource "aws_security_group" "example" {
  name_prefix = "example-"

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "example_with_sg" {
  ami           = "ami-0c55b159cbfafe1f0"
  instance_type = "t2.micro"

  # Dépendance implicite
  vpc_security_group_ids = [aws_security_group.example.id]

  # Dépendance explicite
  depends_on = [aws_security_group.example]
}
```

### Référencer des ressources

```hcl
# Référencer une ressource créée
resource "aws_eip" "example" {
  instance = aws_instance.example.id
  domain   = "vpc"
}

# Utiliser des attributs de ressource
output "instance_public_ip" {
  value = aws_instance.example.public_ip
}

# Référencer une ressource dans un autre module
resource "aws_route53_record" "example" {
  zone_id = data.aws_route53_zone.main.zone_id
  name    = "www.example.com"
  type    = "A"
  ttl     = "300"
  records = [module.web_server.public_ip]
}
```

## Modules

### Utiliser un module

```hcl
# Utiliser un module depuis le Registry
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.0.0"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["eu-west-1a", "eu-west-1b", "eu-west-1c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}
```

### Utiliser un module local

```hcl
# Utiliser un module local
module "web_server" {
  source = "./modules/web-server"

  instance_count = 2
  instance_type  = "t2.micro"
  subnet_ids     = module.vpc.public_subnets
}

# Utiliser un module depuis Git
module "backend" {
  source = "github.com/org/terraform-modules//backend?ref=v1.0.0"

  environment = "production"
}
```

### Créer un module

```hcl
# modules/web-server/main.tf
resource "aws_instance" "web" {
  count         = var.instance_count
  ami           = data.aws_ami.ubuntu.id
  instance_type = var.instance_type
  subnet_id     = var.subnet_ids[count.index % length(var.subnet_ids)]

  tags = {
    Name = "web-server-${count.index + 1}"
  }
}

# modules/web-server/variables.tf
variable "instance_count" {
  description = "Number of instances to create"
  type        = number
  default     = 1
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "subnet_ids" {
  description = "List of subnet IDs"
  type        = list(string)
}

# modules/web-server/outputs.tf
output "instance_ids" {
  description = "IDs of created instances"
  value       = aws_instance.web.*.id
}

output "public_ips" {
  description = "Public IPs of created instances"
  value       = aws_instance.web.*.public_ip
}
```

## Gestion de l'État (State)

### Backend local vs remote

```hcl
# Backend S3 (recommandé pour le travail d'équipe)
terraform {
  backend "s3" {
    bucket         = "my-terraform-state-bucket"
    key            = "prod/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    dynamodb_table = "terraform-locks"
  }
}

# Backend Azure
terraform {
  backend "azurerm" {
    resource_group_name  = "terraform-state"
    storage_account_name = "tfstateaccount"
    container_name       = "tfstate"
    key                  = "prod.terraform.tfstate"
  }
}

# Backend GCS
terraform {
  backend "gcs" {
    bucket = "tf-state-bucket"
    prefix = "terraform/state"
  }
}
```

### Commandes de gestion d'état

```bash
# Voir l'état actuel
terraform state list

# Voir les détails d'une ressource
terraform state show aws_instance.web

# Supprimer une ressource de l'état
terraform state rm aws_instance.web

# Déplacer une ressource dans l'état
terraform state mv aws_instance.old aws_instance.new

# Importer une ressource existante
terraform import aws_instance.web i-1234567890abcdef0

# Pull l'état depuis le backend
terraform state pull

# Push l'état vers le backend
terraform state push
```

## Workspaces

Les workspaces permettent de gérer plusieurs environnements.

```bash
# Lister les workspaces
terraform workspace list

# Créer un nouveau workspace
terraform workspace new staging

# Changer de workspace
terraform workspace select production

# Afficher le workspace actuel
terraform workspace show

# Supprimer un workspace
terraform workspace delete staging
```

### Utilisation avec des fichiers de variables

```hcl
# Utiliser le nom du workspace dans la configuration
resource "aws_instance" "web" {
  tags = {
    Environment = terraform.workspace
  }
}
```

## Fonctions HCL

### Fonctions de chaîne

```hcl
# Upper et lower
upper("hello")  # HELLO
lower("WORLD")  # world

# Join et split
join(", ", ["a", "b", "c"])  # "a, b, c"
split(",", "a,b,c")          # ["a", "b", "c"]

# Format
format("Hello, %s!", "World")  # "Hello, World!"

# Replace
replace("hello world", "world", "terraform")  # "hello terraform"
```

### Fonctions de collection

```hcl
# Length
length(["a", "b", "c"])  # 3

# Element
element(["a", "b", "c"], 1)  # "b"

# Lookup
lookup({a = "apple", b = "banana"}, "a", "unknown")  # "apple"

# Merge
merge({a = "1", b = "2"}, {b = "3", c = "4"})  # {a = "1", b = "3", c = "4"}
```

### Fonctions de fichier

```hcl
# File
file("${path.module}/script.sh")

# Templatefile
templatefile("${path.module}/user-data.sh", {
  server_name = "web-server"
  environment = "production"
})

# Fileexists
fileexists("${path.module}/config.txt")  # true ou false
```

## Commandes Avancées

### Graph

```bash
# Générer un graphique de dépendances
terraform graph | dot -Tpng > graph.png
```

### Console

```bash
# Ouvrir la console interactive
terraform console

# Tester des expressions
> 1 + 2
3

> aws_instance.web.public_ip
"54.123.45.67"
```

### Taint et Untaint

```bash
# Marquer une ressource comme "tainted" (sera recréée)
terraform taint aws_instance.web

# Retirer le marquage
terraform untaint aws_instance.web
```

### Refresh

```bash
# Rafraîchir l'état depuis les APIs
terraform refresh
```

## Bonnes Pratiques

1. **Versionnez vos configurations** avec Git
2. **Utilisez des backends distants** pour le travail d'équipe
3. **Verrouillez l'état** avec DynamoDB (AWS) ou équivalent
4. **Organisez en modules** pour la réutilisabilité
5. **Utilisez des workspaces** pour les environnements
6. **Formatez le code** avec `terraform fmt`
7. **Validez avant d'appliquer** avec `terraform validate`
8. **Sauvegardez les plans** pour les déploiements en production
9. **Utilisez des variables sensibles** avec `sensitive = true`
10. **Documentez avec des outputs** clairs
