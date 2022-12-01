#################
# Security group
#################

variable "create" {
  description = "Whether to create security group. If false, you can specify an existing security group by setting `existing_group_id`."
  type        = bool
  default     = true
}

variable "name" {
  description = "Name of security group. It is used to create a new security group. A random name prefixed with 'terraform-sg-' will be set if it is empty."
  type        = string
  default     = ""
}

variable "description" {
  description = "Description of security group"
  type        = string
  default     = "Security Group managed by Terraform"
}

variable "project_id" {
  description = "ID of the VPC where to create security group"
  type        = number
  default     = 0
}

variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}


##########
# Ingress
##########

variable "ingress_rules" {
  description = "List of ingress rules to create by name"
  type        = list(string)
  default     = []
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used. The valid keys contains `cidr_blocks`, `from_port`, `to_port`, `protocol`, `description` and `rule`."
  type        = list(map(string))
  default     = []
}

variable "ingress_with_source_sgids" {
  description = "List of ingress rules to create where `source_sgid` is used"
  type        = list(map(string))
  default     = []
}

variable "ingress_cidr_blocks" {
  description = "The IPv4 CIDR ranges list to use on ingress cidrs rules."
  type        = list(string)
  default     = []
}


##########
# Egress
##########

variable "egress_rules" {
  description = "List of egress rules to create by name"
  type        = list(string)
  default     = []
}

variable "egress_with_cidr_blocks" {
  description = "List of egress rules to create where 'cidr_blocks' is used. The valid keys contains `cidr_blocks`, `from_port`, `to_port`, `protocol` and `description`."
  type        = list(map(string))
  default     = []
}

variable "egress_with_source_sgids" {
  description = "List of egress rules to create where 'source_sgid' is used"
  type        = list(map(string))
  default     = []
}

variable "egress_cidr_blocks" {
  description = "The IPv4 CIDR ranges list to use on egress cidrs rules."
  type        = list(string)
  default     = []
}
