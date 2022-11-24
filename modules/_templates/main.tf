module "sg" {
  source = "../.."
  create = var.create
  name = var.name
  description = var.description
  project_id = var.project_id   
  tags = var.tags

  ##########
  # Ingress
  ##########
  # Rules by names - open for default CIDR
  ingress_rules = sort(compact(distinct(concat(var.auto_ingress_rules, var.ingress_rules, [""]))))

  # Open to IPv4 cidr blocks with a cidr block list
  ingress_with_cidr_blocks = var.ingress_with_cidr_blocks

  # Open for security group id
  ingress_with_source_security_group_id = var.ingress_with_source_security_group_id

  # The IPv4 CIDR ranges list to use on ingress cidrs rules.
  ingress_cidr_blocks = var.ingress_cidr_blocks

  
  ##########
  # Egress
  ##########
  # Rules by names - open for default CIDR
  egress_rules = sort(compact(distinct(concat(var.auto_egress_rules, var.egress_rules, [""]))))

  # Open to IPv4 cidr blocks with a cidr block list
  egress_with_cidr_blocks = var.egress_with_cidr_blocks

  # Open for security group id
  egress_with_source_security_group_id = var.egress_with_source_security_group_id

  # The IPv4 CIDR ranges list to use on egress cidrs rules.
  egress_cidr_blocks = var.egress_cidr_blocks
}




















}
