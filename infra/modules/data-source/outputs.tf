output "rds_instance_id" {
  description = "The RDS instance identifier"
  value       = aws_db_instance.postgres.id
}

output "rds_endpoint" {
  description = "The connection endpoint for the RDS instance"
  value       = aws_db_instance.postgres.endpoint
}

output "rds_address" {
  description = "The address of the RDS instance"
  value       = aws_db_instance.postgres.address
}

output "rds_port" {
  description = "The port the RDS instance is listening on"
  value       = aws_db_instance.postgres.port
}

output "rds_arn" {
  description = "The ARN of the RDS instance"
  value       = aws_db_instance.postgres.arn
}