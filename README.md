# mentoria2
Lab 2 Mentoring

<!-- BEGIN_TF_DOCS -->
## Requirements

No requirements.

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.8.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_eip.nat_eip_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.nat_eip_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_instance.EC2_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_instance.EC2_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.nat_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.nat_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat_gateway_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.route_table_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.route_table_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.subnets_private_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnets_private_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnets_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc_mentoring2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_image"></a> [ec2\_image](#input\_ec2\_image) | Imagen Id | `string` | `"ami-0261755bbcb8c4a84"` | no |
| <a name="input_ec2_instype"></a> [ec2\_instype](#input\_ec2\_instype) | Instance type | `string` | `"t2.micro"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment Environment | `string` | `"dev"` | no |
| <a name="input_ig"></a> [ig](#input\_ig) | Internet gateway | `string` | `"igw"` | no |
| <a name="input_nro_pri_instances"></a> [nro\_pri\_instances](#input\_nro\_pri\_instances) | n/a | `number` | `1` | no |
| <a name="input_nro_pub_instances"></a> [nro\_pub\_instances](#input\_nro\_pub\_instances) | n/a | `number` | `1` | no |
| <a name="input_nro_subnets_private"></a> [nro\_subnets\_private](#input\_nro\_subnets\_private) | n/a | `number` | `2` | no |
| <a name="input_nro_subnets_public"></a> [nro\_subnets\_public](#input\_nro\_subnets\_public) | n/a | `number` | `1` | no |
| <a name="input_vpc_cidr_global"></a> [vpc\_cidr\_global](#input\_vpc\_cidr\_global) | n/a | `string` | `"192.168.0.0/16"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->