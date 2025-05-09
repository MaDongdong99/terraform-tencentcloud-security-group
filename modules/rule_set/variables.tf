variable "region" {
  type    = string
  default = "ap-jakarta"
}

variable "name" {
  type = string
  default = ""
  description = "name of the security group"
}

variable "create" {
  description = "Whether to create the resources from this module."
  type        = bool
  default     = true
}

variable "project_id" {
  description = "Project ID to create the firewall rules in."
  type        = string
  default = 0
}

variable "ingress" {
  type = any
  default = {}
  description = "ingress for security group"
}

variable "default_ingress_deny_all" {
  type = bool
  default = true
  description = "the bottom of the ingress, default deny all. "
}

variable "egress" {
  type = any
  default = {}
  description = "egress for security group"
}
variable "default_egress_deny_all" {
  type = bool
  default = true
  description = "the bottom of the egress, default deny all. "
}

