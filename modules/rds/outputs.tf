output "db_name" {
  value = aws_db_instance.db_instance.db_name
}

output "db_instance_endpoint" {
  value = aws_db_instance.db_instance.endpoint
}