output "table_id" {
  description = "DynamoDB table ID"
  value       = aws_dynamodb_table.tfstate_lock.id
}
