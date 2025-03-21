#VPC
project_name    = "desafio_tecnico_ml"
aws_region      = "sa-east-1"
vpc_cidr        = "10.0.0.0/16"
azs             = ["sa-east-1a", "sa-east-1b"]
private_subnets = ["10.0.1.0/24", "10.0.2.0/24"]
public_subnets  = ["10.0.101.0/24", "10.0.102.0/24"]

#Instances
instance_count = 1
instance_type  = "t2.micro"
ami_id         = "ami-08879933c9900d167"
