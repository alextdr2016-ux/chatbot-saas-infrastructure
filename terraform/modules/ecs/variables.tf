# modules/ecs/variables.tf

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

variable "public_subnet_ids" {
  description = "Subnet-uri publice pentru ALB"
  type        = list(string)
}

variable "private_subnet_ids" {
  description = "Subnet-uri private pentru ECS tasks"
  type        = list(string)
}

variable "container_port" {
  description = "Port-ul pe care rulează aplicația"
  type        = number
  default     = 5000
}

variable "cpu" {
  description = "CPU pentru task (256, 512, 1024, etc.)"
  type        = number
  default     = 256
}

variable "memory" {
  description = "Memorie pentru task (512, 1024, 2048, etc.)"
  type        = number
  default     = 512
}

variable "desired_count" {
  description = "Numărul de instanțe care rulează"
  type        = number
  default     = 1
}

# Environment variables pentru container
variable "db_host" {
  description = "Host-ul bazei de date"
  type        = string
}

variable "db_name" {
  description = "Numele bazei de date"
  type        = string
}

variable "db_username" {
  description = "Username baza de date"
  type        = string
}

variable "db_password" {
  description = "Password baza de date"
  type        = string
  sensitive   = true
}

variable "openai_api_key" {
  description = "OpenAI API Key"
  type        = string
  sensitive   = true
}

# Variabilă nouă în variables.tf
variable "acm_certificate_arn" {
  description = "ARN-ul certificatului ACM pentru HTTPS"
  type        = string
  default     = "arn:aws:acm:eu-north-1:603630702891:certificate/e9221543-47b2-4746-849c-a8db30285e95"
}