locals {
  well-known-cidrs = [
    "61.135.194.0/24",
  ]

  well-known-ports = ["80", "443"]
}
module "security_groups" {
  source  = "../../modules/rule_set"
  # source = "git::https://github.com/terraform-tencentcloud-modules-tmigrate/terraform-tencentcloud-security-group.git?ref=master"
  name = "demo"
  ingress = concat(
    [
      {
        action      = "ACCEPT"
        cidr_block  = "10.0.0.0/16" # vpc cidr
        protocol    = "TCP" # "TCP"  # TCP, UDP and ICMP
        port        = "ALL" # "80-90" # 80, 80,90 and 80-90
        description = ""
      }
    ],
    [
      for cidr in local.well-known-cidrs: {
      action      = "ACCEPT"
      cidr_block  = cidr
      protocol    = "TCP" # "TCP"  # TCP, UDP and ICMP
      port        = "ALL" # "80-90" # 80, 80,90 and 80-90
      description = ""
    }
    ], [
      for port in local.well-known-ports: {
        action      = "ACCEPT"
        cidr_block  = "0.0.0.0/0"
        protocol    = "TCP" # "TCP"  # TCP, UDP and ICMP
        port        = port # "80-90" # 80, 80,90 and 80-90
        description = ""
      }
    ]
  )
  default_ingress_deny_all = true

}