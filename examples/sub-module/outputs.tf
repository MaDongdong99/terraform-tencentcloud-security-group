output "security_group_id" {
  description = "The ID of the security group"
  value       = module.security_group.security_group_id
}

output "security_group_name" {
  description = "The name of the security group"
  value       = module.security_group.security_group_name
}

output "security_group_description" {
  description = "The description of the security group"
  value       = module.security_group.security_group_description
}
