# variables.tf - Toate variabilele proiectului

variable "aws_region" {
  description = "AWS region pentru deployment"
  type        = string
  default     = "eu-central-1"  # Frankfurt - cel mai apropiat de România
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
}

variable "project_name" {
  description = "Numele proiectului"
  type        = string
  default     = "ejolie-chatbot"
}

# Database
variable "db_name" {
  description = "Numele bazei de date PostgreSQL"
  type        = string
  default     = "ejolie_saas"
}

variable "db_username" {
  description = "Username pentru PostgreSQL"
  type        = string
  default     = "ejolie_admin"
}

variable "db_password" {
  description = "Password pentru PostgreSQL (setează în terraform.tfvars)"
  type        = string
  sensitive   = true  # Nu se afișează în logs
}

# OpenAI API Key
variable "openai_api_key" {
  description = "OpenAI API Key pentru chatbot"
  type        = string
  sensitive   = true
}