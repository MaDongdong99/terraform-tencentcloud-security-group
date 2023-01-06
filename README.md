# TencentCloud SecurityGroup Module for Terraform

## terraform-tencentcloud-security-group

A terraform module used to create TencentCloud security group and rule.

The following resources are included.

* [SecurityGroup](https://www.terraform.io/docs/providers/tencentcloud/r/security_group.html)
* [SecurityGroup Rule](https://www.terraform.io/docs/providers/tencentcloud/r/security_group_rule.html)

## Features

This module aims to implement **ALL** combinations of arguments supported by Tencent Cloud and latest stable version of Terraform:
* IPv4 CIDR blocks
* Access from source security groups
* Named rules ([see the rules here](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/blob/master/rules.tf))
* Named groups of rules with ingress (inbound) and egress (outbound) for common scenarios (eg, [ssh](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/tree/master/modules/ssh), [http-80](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/tree/master/modules/http-80), [mysql](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/tree/master/modules/mysql), see the whole list [here](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/blob/master/modules/README.md))
* Conditionally create security group and all required security group rules ("single boolean switch").

Ingress and egress rules can be configured in a variety of ways. See [inputs variables](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/blob/master/variables.tf) for all supported arguments <!--and [complete example](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/tree/master/examples/complete) for the complete use-case.-->

If there is a missing feature or a bug - [open an issue](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group/issues/new).

## Usage

There are three ways to create security groups using this module:

1. [Specifying predefined rules (HTTP, SSH, etc)](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group#security-group-with-predefined-rules)
1. [Specifying custom rules of multiple cidr blocks](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group#security-group-with-custom-rules-of-multiple-cidr-blocks)
1. [Specifying custom rules of single cidr block](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group#security-group-with-custom-rules-of-single-cidr-block)
1. [Specifying custom rules of source security group id](https://github.com/terraform-tencentcloud-modules/terraform-tencentcloud-security-group#security-group-with-custom-rules-of-source-security-group-id)

### Security group with predefined rules

```hcl
module "web_server_sg" {
  source = "terraform-tencentcloud-modules/security-group/tencentcloud//modules/http-80"
  
  name = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id = "vpc-123-web"

  ingress_cidr_blocks = ["10.10.0.0/16"]
}
```

### Security group with custom rules of multiple cidr blocks
```hcl
module "service_sg_with_multi_cidr" {
  source  = "terraform-tencentcloud-modules/security-group/tencentcloud"

  name        = "user-service"
  description = "Security group for user-service with custom ports open within VPC"
  vpc_id      = "vpc-123456"

  ingress_cidr_blocks      = ["10.10.0.0/16"]
  ingress_rules            = ["https-443-tcp"]
  ingress_with_cidr_blocks = [
    {
      port   = 8080-8090
      protocol    = "tcp"
      cidr_block = "10.10.0.0/16"
      policy    = "accept"
      description = "User-service ports"
    },
    {
      rule        = "postgresql-tcp"
      cidr_block = "10.13.0.0/16,10.14.0.0/16"
    },
    {
      // Using ingress_cidr_blocks to set cidr_blocks
      rule = "postgresql-tcp"
    },
  ]
  egress_cidr_blocks      = ["10.10.0.0/16"]
  egress_with_cidr_blocks = [
    {
      port   = 8080-8090
      protocol    = "tcp"
      cidr_block = "10.13.0.0/16,10.12.0.0/16,10.14.0.0/16"
      policy = "accept"
      description = "User-service ports"
    },
    {
      // Using egress_cidr_blocks to set cidr_blocks
      rule = "postgresql-tcp"
    },
  ]
}
```

### Security group with custom rules of single cidr block
```hcl
module "security_group_with_single_cidr" {
  source  = "terraform-tencentcloud-modules/security-group/tencentcloud"
  version = "1.0.3"

  name        = "simple-security-group"
  description = "simple-security-group-test"

  ingress_with_cidr_blocks = [
    {
      cidr_block = "10.0.0.0/16"
    },
    {
      port       = "80"
      cidr_block = "10.1.0.0/16"
    },
    {
      port       = "808"
      cidr_block = "10.2.0.0/16"
      policy     = "drop"
    },
    {
      port       = "8088"
      protocol   = "UDP"
      cidr_block = "10.3.0.0/16"
      policy     = "accept"
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      cidr_block  = "10.4.0.0/16"
      policy      = "accept"
      description = "simple-security-group"
    },
  ]

  egress_with_cidr_blocks = [
    {
      cidr_block = "10.0.0.0/16"
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      cidr_block  = "10.4.0.0/16"
      policy      = "accept"
      description = "simple-security-group"
    },
  ]

  tags = {
    module = "security-group"
  }

  security_group_tags = {
    test = "security-group"
  }
}
```

### Security group with custom rules of source security group id
```hcl
module "security_group_with_source_gid" {
  source  = "terraform-tencentcloud-modules/security-group/tencentcloud"
  version = "1.0.3"

  name        = "simple-security-group"
  description = "simple-security-group-test"

  ingress_with_source_sgids = [
    {
      rule        = "mysql-tcp"
      source_sgid = "sg-123456"
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      source_sgid = "sg-123456"
      policy      = "accept"
      description = "simple-security-group"
    },
  ]

  egress_with_source_sgids = [
    {
      rule        = "mysql-tcp"
      source_sgid = "sg-123456"
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      source_sgid = "sg-123456"
      policy      = "accept"
      description = "simple-security-group"
    },
  ]

  tags = {
    module = "security-group"
  }

  security_group_tags = {
    test = "security-group"
  }
}
```

### Security group with custom rules of address template
```hcl
module "security_group_with_address_template" {
  source  = "terraform-tencentcloud-modules/security-group/tencentcloud"
  version = "1.0.3"

  name        = "simple-security-group"
  description = "simple-security-group-test"

  ingress_with_address_templates = [
    {
      rule        = "mysql-tcp"
      address_template = [
        {
            group_id = sg-123456
        }
      ]
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      address_template = [
        {
            group_id = sg-123456
        }
      ]
      policy      = "accept"
      description = "simple-security-group"
    }
  ]

  egress_with_address_templates = [
    {
      rule        = "mysql-tcp"
      address_template = [
        {
            template_id = sg-123456
        }
      ]
    },
    {
      port        = "8080-9090"
      protocol    = "TCP"
      address_template = [
        {
            template_id = sg-123456
        }
      ]
      policy      = "accept"
      description = "simple-security-group"
    }
  ]

  tags = {
    module = "security-group"
  }

  security_group_tags = {
    test = "security-group"
  }
}
```

## Conditional Creation
Sometimes you need to have a way to create security group conditionally but Terraform(current version) does not allow to use `count` inside `module` block, so the solution is to specify argument `create`.
```hcl
# This security group will not be created
module "vote_service_sg" {
  source  = "terraform-tencentcloud-modules/security-group/tencentcloud"

  create = false
  # ... omitted
}
```

Sometimes you need to have a way to use a existing security group conditionally, the solution is to specify argument `create` to false and specify a existing security group id.
```hcl
# This security group will not be created
module "vote_service_sg" {
  source  = "terraform-tencentcloud-modules/security-group/tencentcloud"
     
  security_group_id =  "sg-12345678"
  create = false
  # ... omitted
}
```

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| create | A switch to control whether to create a security group and rules. | bool | true | no
| tags | A map of tags to add to all resources. | map(string) | {} | no
| security_group_id | The security group id id used to launch resources. | string | "" | no
| name | The security group name used to launch a new security group when `security_group_id` is not specified. | string | tf-modules-sg | no
| description | The description used to launch a new security group when `security_group_id` is not specified. | string | "" | no
| security_group_tags | Additional tags for the security group. | map(string) | {} | no
| create_lite_rule | A switch to control whether to create a lie rules. | bool | false | no
| ingress_with_cidr_blocks | List of ingress rules to create where `cidr_block` is used. | list(map(string)) | [] | no
| egress_with_cidr_blocks | List of egress rules to create where `cidr_block` is used. | list(map(string)) | [] | no
| ingress_with_source_sgids | List of ingress rules to create where `source_sgid` is used. | list(map(string)) | [] | no
| egress_with_source_sgids | List of egress rules to create where `source_sgid` is used. | list(map(string)) | [] | no
| ingress_with_address_templates | List of address template id to create where `address_template` is used. | list(map(string)) | [] | no
| egress_with_address_templates | List of address template id to create where `address_template` is used. | list(map(string)) | [] | no
| ingress_for_lite_rule| List of ingress rules to create for lite rule. | list(string) | [] | no
| egress_for_lite_rule| List of egress rules to create for lite rule. | list(string) | [] | no

### ingress_with_cidr_blocks and egress_with_cidr_blocks

`ingress_with_cidr_blocks` and `egress_with_cidr_blocks` is a list of security group maps where `cidr_block` is used, the following name are defined.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| cidr_block | An IP address network or segment | string | "" | yes
| protocol | Type of ip protocol, the available value include TCP, UDP and ICMP. | string | "TCP" | no
| port | Range of the port. The available value can be one, multiple or one segment. E.g. 80, 80,90 and 80-90. Default to all ports. | string | "ALL" | no
| policy | Rule policy of security group, the available value include ACCEPT and DROP. | string | "ACCEPT" | no
| description | Description of the security group rule. | string | "" | no

### ingress_with_source_sgids and egress_with_source_sgids

`ingress_with_source_sgids` and `egress_with_source_sgids` is a list of security group maps where `source_sgid` is used, the following name are defined.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| source_sgid | ID of the nested security group | string | "" | yes
| protocol | Type of ip protocol, the available value include TCP, UDP and ICMP. | string | "TCP" | no
| port | Range of the port. The available value can be one, multiple or one segment. E.g. 80, 80,90 and 80-90. Default to all ports. | string | "ALL" | no
| policy | Rule policy of security group, the available value include ACCEPT and DROP. | string | "ACCEPT" | no
| description | Description of the security group rule. | string | "" | no

### ingress_with_address_templates and egress_with_address_templates

`ingress_with_address_templates` and `egress_with_address_templates` is a list of security group maps where `address_template` is used, the following name are defined.

| Name | Description | Type | Default | Required |
|------|-------------|:----:|:-----:|:-----:|
| address_template | ID list of address template for the security group | list(string) | [] | yes
| protocol | Type of ip protocol, the available value include TCP, UDP and ICMP. | string | "TCP" | no
| port | Range of the port. The available value can be one, multiple or one segment. E.g. 80, 80,90 and 80-90. Default to all ports. | string | "ALL" | no
| policy | Rule policy of security group, the available value include ACCEPT and DROP. | string | "ACCEPT" | no
| description | Description of the security group rule. | string | "" | no


## Outputs

| Name | Description |
|------|-------------|
| security_group_id | The id of security group. |
| security_group_name | The name of security group. |
| security_group_description | The description of security group. |

## Authors

Created and maintained by [TencentCloud](https://github.com/terraform-providers/terraform-provider-tencentcloud)

## License

Mozilla Public License Version 2.0.
See LICENSE for full details.
