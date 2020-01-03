output "security_group_id" {
  description = "The id of security group."
  value       = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
}
