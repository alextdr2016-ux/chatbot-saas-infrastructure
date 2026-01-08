# modules/vpc/variables.tf

variable "project_name" {
  description = "Numele proiectului"
  type        = string
}

variable "environment" {
  description = "Environment (dev, staging, prod)"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block pentru VPC"
  type        = string
  default     = "10.0.0.0/16"  # ~65,000 IP-uri disponibile
}

variable "availability_zones" {
  description = "Liste de AZ-uri pentru redundanță"
  type        = list(string)
  default     = ["eu-central-1a", "eu-central-1b"]  # 2 zone în Frankfurt
}