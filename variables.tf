variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "security_group_id" {
  description = "The security group id id used to launch resources."
  default     = ""
}

variable "security_group_name" {
  description = "The security group name used to launch a new security group when `security_group_id` is not specified."
  default     = "tf-modules-sg"
}

variable "security_group_description" {
  description = "The description used to launch a new security group when `security_group_id` is not specified."
  default     = ""
}

variable "security_group_tags" {
  description = "Additional tags for the security group."
  type        = map(string)
  default     = {}
}

variable "lite_rule" {
  description = "Whether to create lite rule for security group."
  type        = bool
  default     = false
}

# rule value format: [action]#[source]#[port]#[protocol]. 
# example: "ACCEPT#10.0.0.0/8#ALL#TCP"
variable "ingress_for_lite_rule" {
  type        = list(string)
  default     = []
  description = "List of ingress rules to create for lite rule."
}

# rule value format: [action]#[source]#[port]#[protocol]. 
# example: "DROP#10.0.0.0/8#ALL#ALL"
variable "egress_for_lite_rule" {
  type        = list(string)
  default     = []
  description = "List of egress rules to create for lite rule."
}

variable "ingress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = "List of ingress rules to create where `cidr_block` is used."
}

variable "egress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = "List of egress rules to create where `cidr_block` is used."
}

variable "ingress_with_source_sgids" {
  type        = list(map(string))
  default     = []
  description = "List of ingress rules to create where `source_sgid` is used."
}

variable "egress_with_source_sgids" {
  type        = list(map(string))
  default     = []
  description = "List of egress rules to create where `source_sgid` is used."
}
