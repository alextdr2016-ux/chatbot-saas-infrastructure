# modules/rds/variables.tf

variable "project_name" {
  description = "Numele proiectului"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_id" {
  description = "ID-ul VPC-ului"
  type        = string
}

variable "subnet_ids" {
  description = "Lista de subnet IDs pentru RDS"
  type        = list(string)
}

variable "db_name" {
  description = "Numele bazei de date"
  type        = string
  default     = "ejolie_saas"
}

variable "db_username" {
  description = "Username pentru baza de date"
  type        = string
  default     = "ejolie_admin"
}

variable "db_password" {
  description = "Password pentru baza de date"
  type        = string
  sensitive   = true
}

variable "db_instance_class" {
  description = "Tipul instanței RDS"
  type        = string
  default     = "db.t3.micro"  # Free tier eligible
}

variable "allowed_cidr_blocks" {
  description = "CIDR blocks care pot accesa baza de date"
  type        = list(string)
  default     = ["10.0.0.0/16"]  # Doar din VPC
}