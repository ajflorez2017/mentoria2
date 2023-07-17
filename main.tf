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

resource "aws_eip" "nat_eip" {
  count      = var.nro_subnets_private
  #vpc        = true                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                
  depends_on = [aws_internet_gateway.ig]
}

#
# 4. NAT
#

resource "aws_nat_gateway" "nat" {
  count         = var.nro_subnets_private
  allocation_id = aws_eip.nat_eip[count.index].id
  subnet_id     = aws_subnet.subnets_private[count.index].id

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
  subnet_cidrs = ["192.168.0.0/16", "192.168.0.0/24", "192.168,1,0/24", "192,168,2,0/24"]
}

#
# Creating Subnets
#

#
# 5. Public subnets
#
resource "aws_subnet" "subnets_public" {
  count      = var.nro_subnets_public
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[count.index + 1]

  tags = {
    Name = "Subnet_Public-${count.index + 1}"
  }
}

#
# 6. Private subnets
#
resource "aws_subnet" "subnets_private" {
  count      = var.nro_subnets_private
  vpc_id     = aws_vpc.vpc_mentoring2.id
  cidr_block = local.subnet_cidrs[count.index + 2]

  tags = {
    Name = "Subnet_Private-${count.index + 1}"
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
  count                  = var.nro_subnets_public
  route_table_id         = aws_route_table.route_table_public.id
  destination_cidr_block = "0.0.0.0/0"
  # gateway_id             = aws_internet_gateway.ig[count.index].id
  gateway_id             = aws_internet_gateway.ig.id

}

#
# 10. Route for NAT
#

resource "aws_route" "private_nat_gateway" {
  count                  = var.nro_subnets_private
  route_table_id         = aws_route_table.route_table_private.id
  destination_cidr_block = "0.0.0.0/0"
  # nat_gateway_id         = aws_nat_gateway.nat.ig[count.index].id
  nat_gateway_id         = aws_nat_gateway.nat[count.index].id 
}

#
# 11. Route table associations for both Public & Private Subnets
#

# resource "aws_route_table_association" "public" {
#  count          = length(var.public_subnets_cidr)
#  subnet_id      = element(aws_subnet.public_subnet.*.id, count.index)
#  route_table_id = aws_route_table.public.id
#}

# resource "aws_route_table_association" "private" {
#  count          = length(var.private_subnets_cidr)
#  subnet_id      = element(aws_subnet.private_subnet.*.id, count.index)
#  route_table_id = aws_route_table.private.id
#}

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

resource "aws_instance" "EC2_private" {
  count         = var.nro_pri_instances
  ami           = var.ec2_image
  instance_type = var.ec2_instype
  subnet_id     = aws_subnet.subnets_private[count.index].id
  tags = {
    Name = "Instance-${count.index + 0}"
  }
}

resource "aws_instance" "EC2_public" {
  count         = var.nro_pub_instances
  ami           = var.ec2_image
  instance_type = var.ec2_instype
  subnet_id     = aws_subnet.subnets_public[count.index].id
  tags = {
    Name = "Instance-${count.index + 0}"
  }
}

