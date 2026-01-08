# modules/ecs/outputs.tf

output "cluster_id" {
  description = "ID-ul ECS Cluster"
  value       = aws_ecs_cluster.main.id
}

output "cluster_name" {
  description = "Numele ECS Cluster"
  value       = aws_ecs_cluster.main.name
}

output "service_name" {
  description = "Numele ECS Service"
  value       = aws_ecs_service.main.name
}

output "ecr_repository_url" {
  description = "URL-ul ECR repository"
  value       = aws_ecr_repository.main.repository_url
}

output "alb_dns_name" {
  description = "DNS-ul Application Load Balancer"
  value       = aws_lb.main.dns_name
}

output "alb_zone_id" {
  description = "Zone ID pentru ALB (pentru Route53)"
  value       = aws_lb.main.zone_id
}

output "target_group_arn" {
  description = "ARN-ul Target Group"
  value       = aws_lb_target_group.main.arn
}