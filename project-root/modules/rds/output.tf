output "primary_db_endpoint" {
  description = "The endpoint of the primary RDS instance."
  value       = aws_db_instance.primary.endpoint
}

output "primary_db_arn" {
  description = "The ARN of the primary RDS instance."
  value       = aws_db_instance.primary.arn
}
