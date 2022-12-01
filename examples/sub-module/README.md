# SecurityGroup Module Example

This module will create SecurityGroup Rules by sub module http-80

## Usage

To run this example, you need first add terraform provider declaration:

```bash
$ terraform init
$ terraform plan
$ terraform apply
```

Note, this example may create resources which cost money. Run `terraform destroy` if you don't need these resources.

## Outputs

| Name | Description |
|------|-------------|
| security_group_id  | The id of security group. |
| security_group_name  | The name of security group. |
| security_group_description  | The description of security group. |
