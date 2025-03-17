resource "aws_security_group" "web_sg" {
  name        = "web-server-sg"
  description = "Reglas de seguridad para el servidor web"
  vpc_id      = module.vpc.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = concat(var.private_subnets, var.public_subnets)
    description = "Permitir trafico HTTP desde las subredes privadas y publicas"
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.private_subnets
    description = "Permitir solo acceso SSH desde la red privada"
  }

  egress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "Permitir salida a internet (HTTPS)"
  }

  tags = {
    Name        = "SG-Web-Server"
    Environment = "dev"
  }
}
