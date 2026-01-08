# main.tf - Fișierul principal care leagă toate modulele

# ===========================================
# VPC - Rețeaua virtuală
# ===========================================
module "vpc" {
  source = "./modules/vpc"

  project_name = var.project_name
  environment  = var.environment
}

# ===========================================
# RDS - Baza de date PostgreSQL
# ===========================================
module "rds" {
  source = "./modules/rds"

  project_name = var.project_name
  environment  = var.environment
  
  vpc_id     = module.vpc.vpc_id
  subnet_ids = module.vpc.public_subnet_ids
  
  db_name     = var.db_name
  db_username = var.db_username
  db_password = var.db_password

  depends_on = [module.vpc]
}

# ===========================================
# ECS - Container Service pentru Chatbot
# ===========================================
module "ecs" {
  source = "./modules/ecs"

  project_name = var.project_name
  environment  = var.environment

  vpc_id             = module.vpc.vpc_id
  public_subnet_ids  = module.vpc.public_subnet_ids
  private_subnet_ids = module.vpc.private_subnet_ids

  # Database connection
  db_host     = module.rds.db_host
  db_name     = module.rds.db_name
  db_username = var.db_username
  db_password = var.db_password

  # OpenAI
  openai_api_key = var.openai_api_key

  # Container settings
  container_port = 5000
  cpu            = 256
  memory         = 512
  desired_count  = 1

  depends_on = [module.vpc, module.rds]
}