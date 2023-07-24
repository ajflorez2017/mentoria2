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
| [aws_autoscaling_group.asg_webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/autoscaling_group) | resource |
| [aws_eip.nat_eip_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_eip.nat_eip_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_internet_gateway.ig](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_launch_configuration.cfg_webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_configuration) | resource |
| [aws_lb.lb_webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_lb_listener.http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.asg_webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |
| [aws_lb_target_group.tg-webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_nat_gateway.nat_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_nat_gateway.nat_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_route.private_nat_gateway_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.public_internet_gateway](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route_table.route_table_private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.route_table_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table_association.private_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.private_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table_association) | resource |
| [aws_security_group.sg_lb](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.sg_webserver](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_subnet.subnets_private_0](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnets_private_1](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.subnets_public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_vpc.vpc_mentoring2](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_availability_zones.available](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/availability_zones) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_image"></a> [ec2\_image](#input\_ec2\_image) | Imagen Id | `string` | `"ami-0261755bbcb8c4a84"` | no |
| <a name="input_ec2_instype"></a> [ec2\_instype](#input\_ec2\_instype) | Instance type | `string` | `"t2.micro"` | no |
| <a name="input_ef_port"></a> [ef\_port](#input\_ef\_port) | Final port definition | `number` | `80` | no |
| <a name="input_ei_port"></a> [ei\_port](#input\_ei\_port) | Initial port definition | `number` | `80` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Deployment Environment | `string` | `"dev"` | no |
| <a name="input_fin_port"></a> [fin\_port](#input\_fin\_port) | Final port definition | `number` | `8080` | no |
| <a name="input_if_port"></a> [if\_port](#input\_if\_port) | Final port definition | `number` | `80` | no |
| <a name="input_ig"></a> [ig](#input\_ig) | Internet gateway | `string` | `"igw"` | no |
| <a name="input_ii_port"></a> [ii\_port](#input\_ii\_port) | Initial port definition | `number` | `80` | no |
| <a name="input_ini_port"></a> [ini\_port](#input\_ini\_port) | Initial port definition | `number` | `8080` | no |
| <a name="input_listener_port"></a> [listener\_port](#input\_listener\_port) | Listener port | `number` | `80` | no |
| <a name="input_max_size"></a> [max\_size](#input\_max\_size) | Max size ASG | `number` | `5` | no |
| <a name="input_min_size"></a> [min\_size](#input\_min\_size) | Min size ASG | `number` | `2` | no |
| <a name="input_nro_pri_instances"></a> [nro\_pri\_instances](#input\_nro\_pri\_instances) | n/a | `number` | `1` | no |
| <a name="input_nro_pub_instances"></a> [nro\_pub\_instances](#input\_nro\_pub\_instances) | n/a | `number` | `1` | no |
| <a name="input_nro_subnets_private"></a> [nro\_subnets\_private](#input\_nro\_subnets\_private) | n/a | `number` | `2` | no |
| <a name="input_nro_subnets_public"></a> [nro\_subnets\_public](#input\_nro\_subnets\_public) | n/a | `number` | `1` | no |
| <a name="input_server_port"></a> [server\_port](#input\_server\_port) | The port the server will use for HTTP Request | `string` | `"8080"` | no |
| <a name="input_tg_port"></a> [tg\_port](#input\_tg\_port) | Port definition | `number` | `80` | no |
| <a name="input_vpc_cidr_global"></a> [vpc\_cidr\_global](#input\_vpc\_cidr\_global) | n/a | `string` | `"192.168.0.0/16"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_vpc_id"></a> [vpc\_id](#output\_vpc\_id) | The ID of the VPC |
<!-- END_TF_DOCS -->