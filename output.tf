#output "aws_subnet_private" {
#  value = aws_subnet.subnets_private
#}

#output "aws_subnet_public" {
#  value = aws_subnet.subnets_public
#}

#output "subnet_cidrs" {
#  value = local.subnet_cidrs
#}

output "aws_instance_0" {
  value = aws_instance.EC2_private_0
}

output "aws_instance_1" {
  value = aws_instance.EC2_private_1
}

output "aws_lb_listener" {
  value = aws_lb_listener.http
}