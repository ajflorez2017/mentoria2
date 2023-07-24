resource "aws_vpc" "vpc_mentoring2" {
  cidr_block       = var.vpc_cidr_global
  instance_tenancy = "default"

  tags = {
    Name = "mentoria2_vpc"
  }
}

#
# 2. Internet Gateway for Public Subnet
#

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.vpc_mentoring2.id
  tags = {
    Name = "${var.ig}-igw"
  }
}

#
# 3. Elastic-IP (eip) for NAT
#

resource "aws_eip" "nat_eip_0" {
  #vpc        = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  depends_on = [aws_internet_gateway.ig]
}

resource "aws_eip" "nat_eip_1" {
  #vpc        = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  depends_on = [aws_internet_gateway.ig]
}

#
# 4. NAT
#

resource "aws_nat_gateway" "nat_0" {
  allocation_id = aws_eip.nat_eip_0.id
  subnet_id     = aws_subnet.subnets_private_0.id

  tags = {
    Name = "nat"
  }
}

resource "aws_nat_gateway" "nat_1" {
  allocation_id = aws_eip.nat_eip_1.id
  subnet_id     = aws_subnet.subnets_private_1.id

  tags = {
    Name = "nat"
  }
}
#
# Important:
# This local definition calculates the subnet ranges
#
# cidrsubnets: Calculates a sequence of consecutive IP address ranges within a particular CIDR prefix.
#

locals {
  subnet_cidrs = ["192.168.0.0/16", "192.168.0.0/24", "192.168.1.0/24", "192.168.2.0/24"]
}


#
# Creating Subnets
#

#
# 5. Public subnets
#
resource "aws_subnet" "subnets_public" {
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[1]

  tags = {
    Name = "Subnet_Public-1"
  }
}

#
# 6. Private subnets
#

data "aws_availability_zones" "available" {
  state = "available"
}

resource "aws_subnet" "subnets_private_0" {
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[2]
  availability_zone = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "Subnet_Private-1"
  }
}
resource "aws_subnet" "subnets_private_1" {
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[3]
  availability_zone = data.aws_availability_zones.available.names[1]
  tags = {
    Name = "Subnet_Private-2"
  }
}


#
# 7. Routing tables to route traffic for Private Subnet
#

resource "aws_route_table" "route_table_private" {
  vpc_id = aws_vpc.vpc_mentoring2.id

  tags = {
    Name        = "${var.environment}-private-route-table"
    Environment = "${var.environment}"
  }
}

#
# 8. Routing tables to route traffic for Public Subnet
# 

resource "aws_route_table" "route_table_public" {
  vpc_id = aws_vpc.vpc_mentoring2.id

  tags = {
    Name        = "${var.environment}-public-route-table"
    Environment = "${var.environment}"
  }
}

#
# 9. Route for Internet Gateway
#

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.ig.id

}

#
# 10. Route for NAT
#

resource "aws_route" "private_nat_gateway_0" {
  route_table_id         = aws_route_table.route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_0.id 
}

#resource "aws_route" "private_nat_gateway_1" {
#  route_table_id         = aws_route_table.route_table_private.id
#  destination_cidr_block = "0.0.0.0/0"
#  nat_gateway_id         = aws_nat_gateway.nat_1.id
#}


#
# 11. Route table associations for both Public & Private Subnets
#

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.subnets_public.id
  route_table_id = aws_route_table.route_table_public.id
}

resource "aws_route_table_association" "private_0" {
  subnet_id      = aws_subnet.subnets_private_0.id
  route_table_id = aws_route_table.route_table_private.id
}


resource "aws_route_table_association" "private_1" {
  subnet_id      = aws_subnet.subnets_private_1.id
  route_table_id = aws_route_table.route_table_private.id
}


# ------------------------------------------------------------------------------------------

#---------------------------------------------------------------
# Security group for Webserver 
#
#---------------------------------------------------------------

resource "aws_security_group" "sg_webserver" {

    name = "sg_webserver"
    vpc_id = aws_vpc.vpc_mentoring2.id

    ingress  {
      description   = "ingress to web server"
      from_port     = var.ini_port
      to_port       = var.fin_port
      protocol      = "tcp"      
      cidr_blocks   = [ "0.0.0.0/0" ]
    } 
  
}

#---------------------------------------------------------------
# Security group for Load Balancer 
#
#---------------------------------------------------------------

resource "aws_security_group" "sg_lb" {
  name = "sg_lb"
  vpc_id = aws_vpc.vpc_mentoring2.id

  # Allow inbound HTTP requests

  ingress {
    from_port     = var.ii_port
    to_port       = var.if_port
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }


  # Allow outbound requests

  egress {
    from_port     = var.ei_port
    to_port       = var.ef_port
    protocol      = "tcp"
    cidr_blocks   = ["0.0.0.0/0"]
  }

}

#---------------------------------------------------------------
# Datasource for VPC's 
#
#---------------------------------------------------------------

# data "aws_vpc" "vpc_mentoring2" {
#   default                = true

#   filter {
#     name                = "vpc-id"
#     values              = [data.aws_vpc.vpc_mentoring2.id]
#   }
# }


# data "aws_subnets" "vpc_mentoring2" {
# # vpc_id = data.aws_vpc.mentoria2_vpc.id
  
#   filter {
#     name                = "vpc-id"
#     values              = [data.aws_vpc.vpc_mentoring2.id]
#   }
# }

output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.vpc_mentoring2.id
}

#---------------------------------------------------------------
# Target group for web servers balancing
#
#---------------------------------------------------------------

resource "aws_lb_target_group" "tg-webserver" {
  name            = "tg-webserver"
  port            = var.tg_port
  protocol        = "HTTP"
  # vpc_id          = data.aws_vpc.vpc_mentoring2.id
  vpc_id          = aws_vpc.vpc_mentoring2.id


  health_check {
    path                  = "/"
    protocol              = "HTTP"
    matcher               = "200"
    interval              = 15
    timeout               = 3
    healthy_threshold     = 2
    unhealthy_threshold   = 2
  }
}

#---------------------------------------------------------------
# Attachment resource 
#
#---------------------------------------------------------------

resource "aws_lb_target_group_attachment" "tg_attachment_webserver" {
    target_group_arn = aws_lb_target_group.tg-webserver.arn
    target_id = aws_autoscaling_group.asg_webserver.id
    port = var.tg_port
  
}

#---------------------------------------------------------------
# Load Balancer definition
#---------------------------------------------------------------

resource "aws_lb" "lb_webserver" {
  name                    = "lb-webserver"
  load_balancer_type      = "application"
  # subnets                 = data.aws_subnets.vpc_mentoring2
  subnets                 = [aws_subnet.subnets_private_0.id, aws_subnet.subnets_private_1.id]
  security_groups         = [aws_security_group.sg_lb.id]

}

#---------------------------------------------------------------
# Listener definition
#
#---------------------------------------------------------------

resource "aws_lb_listener" "http" {

  load_balancer_arn       = aws_lb.lb_webserver.arn
  port                    = var.listener_port
  protocol                = "HTTP"

  default_action {
    target_group_arn = aws_lb_target_group.tg-webserver.id
    type             = "forward"
  }
}

#---------------------------------------------------------------
# Listener rule for HTTP
#
#---------------------------------------------------------------

resource "aws_lb_listener_rule" "asg_webserver" {
  listener_arn = aws_lb_listener.http.arn
  priority = 100

  condition {
    path_pattern {
      values = [ "*" ]
    }
  }

  action {
    type = "forward"
    target_group_arn = aws_autoscaling_group.asg_webserver.arn
  }
}

#---------------------------------------------------------------
# Lanuch configuration for ASG
#
#---------------------------------------------------------------


resource "aws_launch_configuration" "cfg_webserver" {

  image_id                = var.ec2_image
  instance_type           = var.ec2_instype
  security_groups         = [aws_security_group.sg_webserver.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p ${var.server_port} &
              EOF

  lifecycle {
    create_before_destroy = true
  }

}

#---------------------------------------------------------------
# Autoscaling group
#
#---------------------------------------------------------------


resource "aws_autoscaling_group" "asg_webserver" {
  launch_configuration    = aws_launch_configuration.cfg_webserver.name
  #vpc_zone_identifier     = data.aws_subnets.vpc_mentoring2.ids
  vpc_zone_identifier     = [aws_subnet.subnets_private_0.id, aws_subnet.subnets_private_1.id]
  target_group_arns       = [aws_lb_target_group.tg-webserver.arn]
  health_check_type       = "ELB"

  min_size                = var.min_size
  max_size                = var.max_size

  tag {
    key                   = "Name"
    value                 = "SG-personal-project-bench"
    propagate_at_launch   = true
  }
}