# outputs.tf - Ce informații vrem să vedem după deployment

# VPC Outputs
output "vpc_id" {
  description = "ID-ul VPC-ului creat"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "ID-urile subnet-urilor publice"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "ID-urile subnet-urilor private"
  value       = module.vpc.private_subnet_ids
}

# RDS Outputs
output "db_endpoint" {
  description = "Endpoint-ul bazei de date PostgreSQL"
  value       = module.rds.db_endpoint
}

output "db_host" {
  description = "Hostname-ul bazei de date"
  value       = module.rds.db_host
}

output "db_name" {
  description = "Numele bazei de date"
  value       = module.rds.db_name
}

# ECS Outputs
output "ecr_repository_url" {
  description = "URL-ul ECR pentru push Docker images"
  value       = module.ecs.ecr_repository_url
}

output "alb_dns_name" {
  description = "URL-ul Application Load Balancer (chatbot)"
  value       = module.ecs.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Numele ECS Cluster"
  value       = module.ecs.cluster_name
}

output "ecs_service_name" {
  description = "Numele ECS Service"
  value       = module.ecs.service_name
}