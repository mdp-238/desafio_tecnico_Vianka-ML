#VPC
variable "project_name" {
  type = string
}

variable "aws_region" {
  type = string
}

variable "vpc_cidr" {
  type = string
}

variable "azs" {
  type = list(string)
}

variable "private_subnets" {
  type = list(string)
}

variable "public_subnets" {
  type = list(string)
}

#Instances
variable "instance_count" {
  type = number
}

variable "instance_type" {
  type = string
}

variable "ami_id" {
  description = "Ubuntu 22.04 LTS"
  type        = string
}

#Security Groups
variable "my_ip" {
  description = "IP publica de ejemplo permitida para acceder por SSH"
  type        = string
}