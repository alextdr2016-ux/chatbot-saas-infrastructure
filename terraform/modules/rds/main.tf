# modules/rds/main.tf - Creează baza de date PostgreSQL

# ===========================================
# Security Group pentru RDS
# ===========================================
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group pentru PostgreSQL RDS"
  vpc_id      = var.vpc_id

  # Permite conexiuni PostgreSQL din VPC
  ingress {
    description = "PostgreSQL from VPC"
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = var.allowed_cidr_blocks
  }



  # Permite trafic outbound
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  }
}

# ===========================================
# Subnet Group pentru RDS (necesită min 2 AZ-uri)
# ===========================================
resource "aws_db_subnet_group" "main" {
  name       = "${var.project_name}-${var.environment}-db-subnet"
  subnet_ids = var.subnet_ids

  tags = {
    Name = "${var.project_name}-${var.environment}-db-subnet"
  }
}

# ===========================================
# RDS PostgreSQL Instance
# ===========================================
resource "aws_db_instance" "main" {
  identifier = "${var.project_name}-${var.environment}-db"

  # Engine
  engine               = "postgres"
  engine_version       = "15"
  instance_class       = var.db_instance_class
  
  # Storage
  allocated_storage     = 20      # GB - minim pentru free tier
  max_allocated_storage = 100     # Auto-scaling până la 100GB
  storage_type          = "gp2"
  storage_encrypted     = true

  # Database
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  port     = 5432

  # Network
  db_subnet_group_name   = aws_db_subnet_group.main.name
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible    = false  # Doar din VPC

  # Backup
  backup_retention_period = 7     # Păstrează backup-uri 7 zile
  backup_window          = "03:00-04:00"  # Backup la 3 AM UTC
  
  # Maintenance
  maintenance_window        = "Mon:04:00-Mon:05:00"
  auto_minor_version_upgrade = true

  # Protection
  deletion_protection = false  # Pune true în producție!
  skip_final_snapshot = true   # Pentru dev - în prod pune false

  tags = {
    Name = "${var.project_name}-${var.environment}-db"
  }
}