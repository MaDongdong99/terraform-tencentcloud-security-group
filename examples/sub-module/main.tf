data "tencentcloud_security_groups" "foo" {
  name       = "default"
  project_id = 0
}

module "security_group" {
  source = "../..//modules/http-80"

  name        = "simple-http"
  description = "simple-http-test"

  ingress_with_cidr_blocks = [
    {
      cidr_block = "10.0.0.0/16"
    },
    {
      port       = "80"
      cidr_block = "10.1.0.0/16"
    },
  ]

  egress_with_cidr_blocks = [
    {
      cidr_block = "10.0.0.0/16"
    },
    {
      port       = "80"
      cidr_block = "10.1.0.0/16"
    },
  ]

  ingress_with_source_sgids = [
    {
      source_sgid = data.tencentcloud_security_groups.foo.security_groups.0.security_group_id
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      source_sgid = data.tencentcloud_security_groups.foo.security_groups.0.security_group_id
      policy      = "accept"
      description = "simple-security-group"
    },
  ]

  egress_with_source_sgids = [
    {
      source_sgid = data.tencentcloud_security_groups.foo.security_groups.0.security_group_id
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      source_sgid = data.tencentcloud_security_groups.foo.security_groups.0.security_group_id
      policy      = "accept"
      description = "simple-security-group"
    },
  ]

  tags = {
    test = "security-group"
  }
}
