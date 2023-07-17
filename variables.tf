variable "vpc_cidr_global" {
  default = "192.168.0.0/16"
}


variable "nro_subnets_private" {
  default = 2
}

variable "nro_subnets_public" {
  default = 1
}

variable "nro_pri_instances" {
  default = 1
}

variable "nro_pub_instances" {
  default = 1
}

variable "ec2_image" {
  description = "Imagen Id"
  type        = string
  default     = "ami-0261755bbcb8c4a84"
}

variable "ec2_instype" {
  description = "Instance type"
  type        = string
  default     = "t2.micro"
}

variable "ig" {
  description = "Internet gateway"
  type        = string
  default     = "igw"
}

variable "environment" {
  description = "Deployment Environment"
  default     = "dev"
}
