locals {
  security_group_id = var.create ? join("", tencentcloud_security_group.sg.*.id) : ""
}


resource "tencentcloud_security_group" "sg" {
  count = var.create ? 1 : 0
  name = var.name
  project_id = var.project_id
}

resource "tencentcloud_security_group_rule_set" "rule_set" {
  security_group_id = local.security_group_id
  dynamic "ingress" {
    for_each = try(var.ingress, [])
    content {
      action             = try(ingress.value.action, "ACCEPT")                                                               # ACCEPT and DROP
      cidr_block         = try(ingress.value.source_security_id, null) == null ? try(ingress.value.cidr_block, "") : null # "10.0.0.0/22"
      protocol           = ingress.value.protocol                                                 # "TCP"  # TCP, UDP and ICMP
      port               = ingress.value.port
      description        = try(ingress.value.description, "")
      source_security_id = try(ingress.value.source_security_id, null)
    }
  }


  dynamic "ingress" {
    for_each = var.default_ingress_deny_all ? ["1"] : []
    content {
      action      = "DROP"
      cidr_block  = "0.0.0.0/0"
      protocol    = "ALL"
      port        = "ALL"
      description = "ingress default deny all traffic"
    }
  }

  dynamic "egress" {
    for_each = try(var.egress, [])
    content {
      action      = try(egress.value.action, "ACCEPT") # ACCEPT and DROP
      cidr_block  = try(egress.value.source_security_id, null) == null ? try(egress.value.cidr_block, "") : null
      description = try(egress.value.description, "") #
      port        = try(egress.value.port, "ALL") == "ALL" ? null : egress.value.port
      protocol    = try(egress.value.protocol, "ALL")
      source_security_id = try(egress.value.source_security_id, null)
    }
  }

  dynamic "egress" {
    for_each = var.default_egress_deny_all ? ["1"] : []
    content {
      action      = "DROP"
      cidr_block  = "0.0.0.0/0"
      protocol    = "ALL"
      port        = "ALL"
      description = "egress default deny all traffic"
    }
  }
}