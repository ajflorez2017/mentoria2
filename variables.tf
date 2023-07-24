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

variable "ini_port" {
  description = "Initial port definition"
  type = number
  default = 8080
}

variable "fin_port" {
  description = "Final port definition"
  type = number
  default = 8080
}

# Security group for Load Balancer

variable "ii_port" {
  description = "Initial port definition"
  type = number
  default = 80
}

variable "if_port" {
  description = "Final port definition"
  type = number
  default = 80
}

variable "ei_port" {
  description = "Initial port definition"
  type = number
  default = 80
}

variable "ef_port" {
  description = "Final port definition"
  type = number
  default = 80
}

# Target group for web servers balancing

variable "tg_port" {
  description = "Port definition"
  type = number
  default = 80
}

variable "server_port" {
  description = "The port the server will use for HTTP Request"
  type = string
  default = "8080"
}

variable "listener_port" {
  description = "Listener port"
  type = number
  default = 80
}

variable "min_size" {
  description = "Min size ASG"
  type = number
  default = 2
}

variable "max_size" {
  description = "Max size ASG"
  type = number
  default = 5
}