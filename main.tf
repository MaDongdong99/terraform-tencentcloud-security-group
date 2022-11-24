# ------------------------
# Security group with name
# ------------------------
resource "tencentcloud_security_group" "sg" {
  count       = var.security_group_id == "" ? 1 : 0
  name        = var.security_group_name
  description = var.security_group_description
  tags        = merge(var.tags, var.security_group_tags)
}

# -------------------------
# Security group lite rules
# -------------------------
# NOTE:It can't be used with tencentcloud_security_group_rule, and don't create multiple 
# tencentcloud_security_group_rule resources, otherwise it may cause problems.
resource "tencentcloud_security_group_lite_rule" "lite_rule" {
  count       = var.lite_rule ? 1 : 0
  security_group_id = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
  ingress = var.ingress_for_lite_rule
  egress = var.egress_for_lite_rule
}

# --------------------------------------------------------------------------
# Security group ingress rules with "cidr_blocks", but without "source_sgid"
# --------------------------------------------------------------------------
resource "tencentcloud_security_group_rule" "ingress_with_cidr_blocks" {
  count             = length(var.ingress_with_cidr_blocks) > 0 ? length(var.ingress_with_cidr_blocks) : 0
  security_group_id = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
  type              = "ingress"
  ip_protocol       = lookup(var.ingress_with_cidr_blocks[count.index], "protocol", "TCP")
  port_range        = lookup(var.ingress_with_cidr_blocks[count.index], "port", null)
  cidr_ip           = lookup(var.ingress_with_cidr_blocks[count.index], "cidr_block", "")
  policy            = lookup(var.ingress_with_cidr_blocks[count.index], "policy", "ACCEPT")
  description       = lookup(var.ingress_with_cidr_blocks[count.index], "description", null)
}

# -------------------------------------------------------------------------------------------------
# Security group ingress rules with "source_sgid", but without "cidr_blocks" and "address_template"
# -------------------------------------------------------------------------------------------------
resource "tencentcloud_security_group_rule" "ingress_with_source_sgids" {
  count             = length(var.ingress_with_source_sgids) > 0 ? length(var.ingress_with_source_sgids) : 0
  security_group_id = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
  type              = "ingress"
  ip_protocol       = lookup(var.ingress_with_source_sgids[count.index], "protocol", "TCP")
  port_range        = lookup(var.ingress_with_source_sgids[count.index], "port", null)
  source_sgid       = lookup(var.ingress_with_source_sgids[count.index], "source_sgid", "")
  policy            = lookup(var.ingress_with_source_sgids[count.index], "policy", "ACCEPT")
  description       = lookup(var.ingress_with_source_sgids[count.index], "description", null)
}

# -------------------------------------------------------------------------
# Security group egress rules with "cidr_blocks", but without "source_sgid"
# -------------------------------------------------------------------------
resource "tencentcloud_security_group_rule" "egress_with_cidr_blocks" {
  count             = length(var.egress_with_cidr_blocks) > 0 ? length(var.egress_with_cidr_blocks) : 0
  security_group_id = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
  type              = "egress"
  ip_protocol       = lookup(var.egress_with_cidr_blocks[count.index], "protocol", "TCP")
  port_range        = lookup(var.egress_with_cidr_blocks[count.index], "port", null)
  cidr_ip           = lookup(var.egress_with_cidr_blocks[count.index], "cidr_block", "")
  policy            = lookup(var.egress_with_cidr_blocks[count.index], "policy", "ACCEPT")
  description       = lookup(var.egress_with_cidr_blocks[count.index], "description", null)
}

# ------------------------------------------------------------------------------------------------
# Security group egress rules with "source_sgid", but without "cidr_blocks" and "address_template"
# ------------------------------------------------------------------------------------------------
resource "tencentcloud_security_group_rule" "egress_with_source_sgids" {
  count             = length(var.egress_with_source_sgids) > 0 ? length(var.egress_with_source_sgids) : 0
  security_group_id = var.security_group_id != "" ? var.security_group_id : concat(tencentcloud_security_group.sg.*.id, [""])[0]
  type              = "egress"
  ip_protocol       = lookup(var.egress_with_source_sgids[count.index], "protocol", "TCP")
  port_range        = lookup(var.egress_with_source_sgids[count.index], "port", null)
  source_sgid       = lookup(var.egress_with_source_sgids[count.index], "source_sgid", "")
  policy            = lookup(var.egress_with_source_sgids[count.index], "policy", "ACCEPT")
  description       = lookup(var.egress_with_source_sgids[count.index], "description", null)
}
