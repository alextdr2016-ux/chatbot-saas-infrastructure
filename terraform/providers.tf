# providers.tf - Configurează conexiunea la AWS

terraform {
  required_version = ">= 1.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configurare AWS Provider
provider "aws" {
  region = var.aws_region

  default_tags {
    tags = {
      Project     = "ejolie-chatbot-saas"
      Environment = var.environment
      ManagedBy   = "terraform"
    }
  }
}