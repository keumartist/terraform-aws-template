output "tfstate_lock_table_id" {
  description = "DynamoDB table ID"
  value       = module.tfstate_lock_store.table_id
}
