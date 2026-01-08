# modules/vpc/outputs.tf - Ce informații expunem din acest modul

output "vpc_id" {
  description = "ID-ul VPC-ului"
  value       = aws_vpc.main.id
}

output "vpc_cidr" {
  description = "CIDR block-ul VPC-ului"
  value       = aws_vpc.main.cidr_block
}

output "public_subnet_ids" {
  description = "Lista ID-urilor subnet-urilor publice"
  value       = aws_subnet.public[*].id
}

output "private_subnet_ids" {
  description = "Lista ID-urilor subnet-urilor private"
  value       = aws_subnet.private[*].id
}

output "internet_gateway_id" {
  description = "ID-ul Internet Gateway-ului"
  value       = aws_internet_gateway.main.id
}