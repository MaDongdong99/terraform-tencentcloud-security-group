#################
# Security group
#################
variable "create" {
  description = "Whether to create security group and all rules"
  type        = bool
  default     = true
}

variable "create_sg" {
  description = "Whether to create security group"
  type        = bool
  default     = true
}

variable "tags" {
  description = "A map of tags to add to all resources."
  type        = map(string)
  default     = {}
}

variable "security_group_id" {
  description = "The security group id id used to launch resources."
  type        = string
  default     = ""
}

variable "name" {
  description = "The security group name used to launch a new security group when `security_group_id` is not specified."
  type        = string
  default     = "tf-modules-sg"
}

variable "description" {
  description = "The description used to launch a new security group when `security_group_id` is not specified."
  type        = string
  default     = ""
}

variable "project_id" {
  description = "ID of the VPC where to create security group"
  type        = number
  default     = 0
}

variable "security_group_tags" {
  description = "Additional tags for the security group."
  type        = map(string)
  default     = {}
}

variable "create_lite_rule" {
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


##########
# Ingress
##########
variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "The IPv4 CIDR ranges list to use on ingress cidrs rules."
  type        = list(string)
  default     = []
}

variable "ingress_policy" {
  description = "The ingress rule policy of security group"
  type        = string
  default     = "ACCEPT"
}

variable "ingress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = "List of ingress rules to create where `cidr_block` is used."
}

variable "ingress_with_source_sgids" {
  type        = list(map(string))
  default     = []
  description = "List of ingress rules to create where `source_sgid` is used."
}

##########
# Egress
##########
variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_cidr_blocks" {
  description = "The IPv4 CIDR ranges list to use on egress cidrs rules."
  type        = list(string)
  default     = []
}

variable "egress_policy" {
  description = "The egress rule policy of security group"
  type        = string
  default     = "ACCEPT"
}

variable "egress_with_cidr_blocks" {
  type        = list(map(string))
  default     = []
  description = "List of egress rules to create where `cidr_block` is used."
}

variable "egress_with_source_sgids" {
  type        = list(map(string))
  default     = []
  description = "List of egress rules to create where `source_sgid` is used."
}
