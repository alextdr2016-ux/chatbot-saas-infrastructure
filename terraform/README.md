# 🤖 Ejolie Chatbot SaaS - AWS Infrastructure

O infrastructură AWS completă pentru un chatbot AI multi-tenant, construită cu Terraform.

![AWS](https://img.shields.io/badge/AWS-FF9900?style=for-the-badge&logo=amazonaws&logoColor=white)
![Terraform](https://img.shields.io/badge/Terraform-7B42BC?style=for-the-badge&logo=terraform&logoColor=white)
![Docker](https://img.shields.io/badge/Docker-2496ED?style=for-the-badge&logo=docker&logoColor=white)
![PostgreSQL](https://img.shields.io/badge/PostgreSQL-316192?style=for-the-badge&logo=postgresql&logoColor=white)
![Python](https://img.shields.io/badge/Python-3776AB?style=for-the-badge&logo=python&logoColor=white)

---

## 📋 Cuprins

- [Despre Proiect](#-despre-proiect)
- [Arhitectură](#-arhitectură)
- [Tehnologii](#-tehnologii)
- [Structura Proiectului](#-structura-proiectului)
- [Cerințe](#-cerințe)
- [Quick Start](#-quick-start)
- [Module Terraform](#-module-terraform)
- [Baza de Date](#-baza-de-date)
- [Deployment](#-deployment)
- [Costuri Estimate](#-costuri-estimate)
- [Comenzi Utile](#-comenzi-utile)

---

## 🎯 Despre Proiect

**Ejolie Chatbot SaaS** este o platformă de chatbot AI destinată magazinelor de fashion e-commerce din România. Infrastructura este construită pentru a suporta:

- ✅ **Multi-tenancy** - Multiple magazine pe aceeași platformă
- ✅ **Scalabilitate** - Auto-scaling bazat pe trafic
- ✅ **Securitate** - HTTPS, VPC izolat, subnets private
- ✅ **High Availability** - Deployment în multiple Availability Zones
- ✅ **Infrastructure as Code** - Totul gestionat prin Terraform

---

## 🏗️ Arhitectură

```
                                    ┌─────────────────────────────────────────────────────────────┐
                                    │                         AWS Cloud                           │
                                    │                      (eu-central-1)                         │
                                    │                                                             │
     ┌──────────┐                   │  ┌─────────────────────────────────────────────────────┐   │
     │  Users   │                   │  │                        VPC                          │   │
     │          │                   │  │                   (10.0.0.0/16)                     │   │
     └────┬─────┘                   │  │                                                     │   │
          │                         │  │  ┌─────────────────────────────────────────────┐   │   │
          │ HTTPS                   │  │  │            Public Subnets                   │   │   │
          ▼                         │  │  │         (10.0.0.0/24, 10.0.1.0/24)          │   │   │
     ┌──────────┐                   │  │  │                                             │   │   │
     │ Route 53 │                   │  │  │  ┌─────────────┐      ┌─────────────────┐   │   │   │
     │   DNS    │                   │  │  │  │     ALB     │      │   ECS Fargate   │   │   │   │
     └────┬─────┘                   │  │  │  │   (HTTPS)   │─────▶│    (Chatbot)    │   │   │   │
          │                         │  │  │  └─────────────┘      └────────┬────────┘   │   │   │
          ▼                         │  │  │                                │            │   │   │
     ┌──────────┐                   │  │  └────────────────────────────────┼────────────┘   │   │
     │   ACM    │                   │  │                                   │                │   │
     │  (SSL)   │                   │  │  ┌────────────────────────────────┼────────────┐   │   │
     └──────────┘                   │  │  │           Private Subnets      │            │   │   │
                                    │  │  │       (10.0.10.0/24, 10.0.11.0/24)          │   │   │
                                    │  │  │                                │            │   │   │
                                    │  │  │  ┌─────────────────────────────▼──────────┐ │   │   │
                                    │  │  │  │              RDS PostgreSQL            │ │   │   │
                                    │  │  │  │            (Multi-tenant DB)           │ │   │   │
                                    │  │  │  └────────────────────────────────────────┘ │   │   │
                                    │  │  │                                             │   │   │
                                    │  │  └─────────────────────────────────────────────┘   │   │
                                    │  │                                                     │   │
                                    │  └─────────────────────────────────────────────────────┘   │
                                    │                                                             │
                                    │  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐      │
                                    │  │     ECR      │  │  CloudWatch  │  │   Route 53   │      │
                                    │  │  (Docker)    │  │   (Logs)     │  │    (DNS)     │      │
                                    │  └──────────────┘  └──────────────┘  └──────────────┘      │
                                    │                                                             │
                                    └─────────────────────────────────────────────────────────────┘
```

---

## 🛠️ Tehnologii

### Infrastructure

| Serviciu               | Scop                               |
| ---------------------- | ---------------------------------- |
| **AWS VPC**            | Rețea virtuală izolată             |
| **AWS ECS Fargate**    | Container orchestration serverless |
| **AWS RDS PostgreSQL** | Bază de date relațională           |
| **AWS ECR**            | Container registry                 |
| **AWS ALB**            | Load balancing + HTTPS termination |
| **AWS ACM**            | Certificate SSL/TLS                |
| **AWS Route 53**       | DNS management                     |
| **AWS CloudWatch**     | Logging și monitoring              |

### Development

| Tool      | Versiune      |
| --------- | ------------- |
| Terraform | >= 1.0.0      |
| AWS CLI   | v1.x sau v2.x |
| Docker    | >= 20.x       |
| Python    | 3.11          |

---

## 📁 Structura Proiectului

```
chatbot-saas-infrastructure/
│
├── terraform/
│   ├── main.tf                 # Orchestrarea modulelor
│   ├── variables.tf            # Definirea variabilelor
│   ├── outputs.tf              # Output-uri după deployment
│   ├── providers.tf            # Configurare AWS provider
│   ├── terraform.tfvars        # Valori variabile (NU în git!)
│   ├── .gitignore              # Exclude fișiere sensibile
│   │
│   └── modules/
│       ├── vpc/
│       │   ├── main.tf         # VPC, Subnets, Route Tables
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       ├── rds/
│       │   ├── main.tf         # PostgreSQL RDS instance
│       │   ├── variables.tf
│       │   └── outputs.tf
│       │
│       └── ecs/
│           ├── main.tf         # ECS Cluster, Service, ALB
│           ├── variables.tf
│           └── outputs.tf
│
├── database/
│   ├── schema.sql              # Schema multi-tenant
│   ├── run_schema.py           # Script pentru aplicare schema
│   └── check_db.py             # Verificare date
│
└── README.md
```

---

## ✅ Cerințe

### Software necesar

- [Terraform](https://www.terraform.io/downloads.html) >= 1.0.0
- [AWS CLI](https://aws.amazon.com/cli/) configurat cu credențiale
- [Docker Desktop](https://www.docker.com/products/docker-desktop/)
- [Python](https://www.python.org/downloads/) 3.11+

### AWS Setup

```bash
# Verifică configurarea AWS
aws sts get-caller-identity

# Ar trebui să returneze Account ID și User
```

---

## 🚀 Quick Start

### 1. Clonează repository-ul

```bash
git clone https://github.com/username/chatbot-saas-infrastructure.git
cd chatbot-saas-infrastructure
```

### 2. Configurează variabilele

```bash
cd terraform
cp terraform.tfvars.example terraform.tfvars
# Editează terraform.tfvars cu valorile tale
```

### 3. Inițializează și aplică Terraform

```bash
terraform init
terraform plan
terraform apply
```

### 4. Aplică schema bazei de date

```bash
cd ../database
pip install psycopg2-binary
python run_schema.py
```

### 5. Build și push Docker image

```bash
# Login ECR
aws ecr get-login-password --region eu-central-1 | docker login --username AWS --password-stdin YOUR_ACCOUNT_ID.dkr.ecr.eu-central-1.amazonaws.com

# Build și push
docker build -t chatbot .
docker tag chatbot:latest YOUR_ECR_URL:latest
docker push YOUR_ECR_URL:latest

# Restart ECS
aws ecs update-service --cluster ejolie-chatbot-dev-cluster --service ejolie-chatbot-dev-service --force-new-deployment --region eu-central-1
```

---

## 📦 Module Terraform

### VPC Module

Creează rețeaua virtuală cu:

- 1 VPC (10.0.0.0/16)
- 2 Public Subnets (în AZ-uri diferite)
- 2 Private Subnets (în AZ-uri diferite)
- Internet Gateway
- Route Tables

```hcl
module "vpc" {
  source = "./modules/vpc"

  project_name = "ejolie-chatbot"
  environment  = "dev"
}
```

### RDS Module

Creează baza de date PostgreSQL:

- db.t3.micro (Free Tier eligible)
- 20GB storage (auto-scaling până la 100GB)
- Backup automat (7 zile retenție)
- Encrypted storage

```hcl
module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  vpc_id       = module.vpc.vpc_id
  subnet_ids   = module.vpc.private_subnet_ids
  db_password  = var.db_password
}
```

### ECS Module

Creează infrastructura de containere:

- ECS Cluster (Fargate)
- ECR Repository
- Task Definition
- ECS Service
- Application Load Balancer
- Security Groups
- IAM Roles
- CloudWatch Log Group

```hcl
module "ecs" {
  source = "./modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  db_host            = module.rds.db_host
  openai_api_key     = var.openai_api_key
}
```

---

## 🗄️ Baza de Date

### Schema Multi-Tenant

```
┌─────────────────┐       ┌─────────────────┐
│     tenants     │       │  tenant_config  │
├─────────────────┤       ├─────────────────┤
│ id (PK)         │──┐    │ id (PK)         │
│ name            │  │    │ tenant_id (FK)  │──┐
│ slug            │  │    │ bot_name        │  │
│ domain          │  │    │ welcome_message │  │
│ api_key         │  │    │ primary_color   │  │
│ plan            │  │    │ ai_model        │  │
│ messages_limit  │  │    └─────────────────┘  │
│ is_active       │  │                         │
└─────────────────┘  │    ┌─────────────────┐  │
                     │    │    products     │  │
                     │    ├─────────────────┤  │
                     ├───▶│ tenant_id (FK)  │◀─┤
                     │    │ name            │  │
                     │    │ price           │  │
                     │    │ description     │  │
                     │    └─────────────────┘  │
                     │                         │
                     │    ┌─────────────────┐  │
                     │    │  conversations  │  │
                     │    ├─────────────────┤  │
                     ├───▶│ tenant_id (FK)  │◀─┤
                     │    │ session_id      │  │
                     │    │ status          │  │
                     │    └────────┬────────┘  │
                     │             │           │
                     │    ┌────────▼────────┐  │
                     │    │    messages     │  │
                     │    ├─────────────────┤  │
                     └───▶│ tenant_id (FK)  │◀─┘
                          │ conversation_id │
                          │ role            │
                          │ content         │
                          └─────────────────┘
```

### Tabele

| Tabel           | Descriere                                      |
| --------------- | ---------------------------------------------- |
| `tenants`       | Clienții platformei (magazinele)               |
| `tenant_config` | Configurări per tenant (branding, AI settings) |
| `products`      | Produsele fiecărui magazin                     |
| `conversations` | Sesiunile de chat                              |
| `messages`      | Mesajele individuale                           |
| `faq`           | Întrebări frecvente per tenant                 |

---

## 🚢 Deployment

### CI/CD Flow (Manual)

```
┌──────────────┐     ┌──────────────┐     ┌──────────────┐     ┌──────────────┐
│   Code Push  │────▶│ Docker Build │────▶│  ECR Push    │────▶│ ECS Deploy   │
│   (GitHub)   │     │   (Local)    │     │   (AWS)      │     │   (AWS)      │
└──────────────┘     └──────────────┘     └──────────────┘     └──────────────┘
```

### Comenzi Deploy

```bash
# 1. Build
docker build -t ejolie-chatbot .

# 2. Tag
docker tag ejolie-chatbot:latest 603630702891.dkr.ecr.eu-central-1.amazonaws.com/ejolie-chatbot-dev:latest

# 3. Push
docker push 603630702891.dkr.ecr.eu-central-1.amazonaws.com/ejolie-chatbot-dev:latest

# 4. Deploy
aws ecs update-service \
  --cluster ejolie-chatbot-dev-cluster \
  --service ejolie-chatbot-dev-service \
  --force-new-deployment \
  --region eu-central-1
```

---

## 💰 Costuri Estimate

### Lunar (24/7 running)

| Serviciu                      | Cost             |
| ----------------------------- | ---------------- |
| VPC, Subnets                  | $0               |
| NAT Gateway\*                 | ~$32             |
| RDS db.t3.micro               | ~$17             |
| ECS Fargate (256 CPU, 512 MB) | ~$12             |
| Application Load Balancer     | ~$18             |
| Route 53                      | ~$0.50           |
| CloudWatch Logs               | ~$1              |
| **TOTAL**                     | **~$48-80/lună** |

\*NAT Gateway e opțional - poate fi dezactivat pentru economii

### Free Tier (cont nou < 12 luni)

- RDS: 750 ore/lună gratuit
- ECR: 500 MB storage gratuit

---

## ⌨️ Comenzi Utile

### Terraform

```bash
# Inițializare
terraform init

# Plan (preview changes)
terraform plan

# Apply (create/update)
terraform apply

# Destroy (șterge tot)
terraform destroy

# Output-uri
terraform output
```

### AWS ECS

```bash
# Status serviciu
aws ecs describe-services \
  --cluster ejolie-chatbot-dev-cluster \
  --services ejolie-chatbot-dev-service \
  --region eu-central-1

# Oprire (0 tasks)
aws ecs update-service \
  --cluster ejolie-chatbot-dev-cluster \
  --service ejolie-chatbot-dev-service \
  --desired-count 0 \
  --region eu-central-1

# Pornire (1 task)
aws ecs update-service \
  --cluster ejolie-chatbot-dev-cluster \
  --service ejolie-chatbot-dev-service \
  --desired-count 1 \
  --region eu-central-1
```

### AWS RDS

```bash
# Oprire (max 7 zile)
aws rds stop-db-instance \
  --db-instance-identifier ejolie-chatbot-dev-db \
  --region eu-central-1

# Pornire
aws rds start-db-instance \
  --db-instance-identifier ejolie-chatbot-dev-db \
  --region eu-central-1
```

### Logs

```bash
# Vezi log streams
aws logs describe-log-streams \
  --log-group-name /ecs/ejolie-chatbot-dev \
  --order-by LastEventTime \
  --descending \
  --limit 3 \
  --region eu-central-1

# Vezi logs
aws logs get-log-events \
  --log-group-name /ecs/ejolie-chatbot-dev \
  --log-stream-name "STREAM_NAME" \
  --region eu-central-1 \
  --limit 50
```

---

## 🔒 Securitate

- ✅ VPC izolat cu subnets private pentru DB
- ✅ Security Groups restrictive
- ✅ RDS nu e accesibil public
- ✅ HTTPS cu certificat SSL valid
- ✅ Credențiale în variabile Terraform (nu în cod)
- ✅ IAM Roles cu permisiuni minime

### Fișiere de exclus din Git

```gitignore
# Terraform
.terraform/
*.tfstate
*.tfstate.*
*.tfvars
!example.tfvars

# Credentials
*.pem
*.key
```

---

## 📝 TODO / Roadmap

- [ ] CI/CD cu GitHub Actions
- [ ] Auto-scaling ECS bazat pe CPU/Memory
- [ ] Redis cache (ElastiCache)
- [ ] Backup automat S3 pentru RDS
- [ ] Monitoring cu CloudWatch Alarms
- [ ] Multi-environment (dev/staging/prod)
- [ ] Stripe integration pentru billing

---

## 👤 Autor

**Alex Tudor**

- Proiect: Ejolie Chatbot SaaS
- Locație: România
- Perioada: Ianuarie 2026

---

## 📄 Licență

Acest proiect este privat și proprietar.

---

## 🆘 Support

Pentru întrebări sau probleme, verifică:

1. AWS CloudWatch Logs pentru erori
2. `terraform plan` pentru diff-uri
3. Fișierul `REPORNIRE_AWS.md` pentru instrucțiuni pas cu pas
