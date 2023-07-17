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
resource "aws_subnet" "subnets_private_0" {
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[2]

  tags = {
    Name = "Subnet_Private-1"
  }
}
resource "aws_subnet" "subnets_private_1" {
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[3]

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
#
# 12. Default Security Group of VPC
#
resource "aws_security_group" "default" {
  name        = "${var.environment}-default-sg"
  description = "Default SG to alllow traffic from the VPC"
  vpc_id      = aws_vpc.vpc_mentoring2.id
  depends_on = [
    aws_vpc.vpc_mentoring2
  ]

  ingress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = true
  }

  egress {
    from_port = "0"
    to_port   = "0"
    protocol  = "-1"
    self      = "true"
  }

  tags = {
    Environment = "${var.environment}"
  }
}

resource "aws_lb" "ALB" {
  name = "mentoria"
  load_balancer_type = "application"
  security_groups = [ aws_security_group.lb.id ]
  subnets = [ "subnets_private_0", "subnets_private_1"  ]

}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.ALB.arn
  port = 80
  protocol = "HTTP"
  

  # By default, return a simple 404 page
  default_action {
    type = "fixed-response"

    fixed_response {
      
      content_type = "text/plain"
      message_body = "404: page not found"
      status_code = 404
    }
  }

}

resource "aws_security_group" "lb" {
  name        = "${var.environment}-default-lb"
  description = "Default SG to load balancer"
  vpc_id =  aws_vpc.vpc_mentoring2.id
  

  ingress {
    from_port = "80"
    to_port   = "80"
    protocol  = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = "80"
    to_port   = "80"
    protocol  = "ALL"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Environment = "${var.environment}"
  }
}


resource "aws_instance" "EC2_private_0" {
  count         = var.nro_pri_instances
  ami           = var.ec2_image
  instance_type = var.ec2_instype
  subnet_id     = aws_subnet.subnets_private_0.id
  user_data = <<EOF
          #!/bin/bash
          set -x
          yum install -y httpd.x86_64
          systemctl start httpd.service
          systemctl enable httpd.service
          echo "Hello World" > /var/www/html/index.html
  EOF
  tags = {
    Name = "Instance-${count.index + 0}"
  }
}

resource "aws_instance" "EC2_private_1" {
  count         = var.nro_pub_instances
  ami           = var.ec2_image
  instance_type = var.ec2_instype
  subnet_id     = aws_subnet.subnets_private_1.id
  user_data = <<EOF
          #!/bin/bash
          set -x
          yum install -y httpd.x86_64
          systemctl start httpd.service
          systemctl enable httpd.service
          echo "Hello World" > /var/www/html/index.html
  EOF
  tags = {
    Name = "Instance-${count.index + 0}"
  }
}

