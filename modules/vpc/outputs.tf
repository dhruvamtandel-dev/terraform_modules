output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "vpc id for vpc"
}

output "private_subnet_ids" {
  value       = { for key, subnet in aws_subnet.vpc_private_subnet : key => subnet.id }
  description = "map of private subnets name => subnet id"
}

output "public_subnet_ids" {
  value       = { for key, subnet in aws_subnet.vpc_public_subnet : key => subnet.id }
  description = "map of public subnets name => subnet id"
}

output "db_subnet_ids" {
  value       = { for key, subnet in aws_subnet.db_subnet : key => subnet.id }
  description = "map of database subnets name => subnet id"
}