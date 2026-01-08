# modules/rds/outputs.tf

output "db_endpoint" {
  description = "Endpoint-ul bazei de date (host:port)"
  value       = aws_db_instance.main.endpoint
}

output "db_host" {
  description = "Hostname-ul bazei de date"
  value       = aws_db_instance.main.address
}

output "db_port" {
  description = "Port-ul bazei de date"
  value       = aws_db_instance.main.port
}

output "db_name" {
  description = "Numele bazei de date"
  value       = aws_db_instance.main.db_name
}

output "db_username" {
  description = "Username-ul bazei de date"
  value       = aws_db_instance.main.username
  sensitive   = true
}

output "security_group_id" {
  description = "ID-ul security group-ului RDS"
  value       = aws_security_group.rds.id
}