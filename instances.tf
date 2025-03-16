resource "aws_instance" "web_servers" {
  count           = var.instance_count
  ami             = var.ami_id
  instance_type   = var.instance_type
  subnet_id       = element(module.vpc.private_subnets, count.index)
  security_groups = [aws_security_group.web_sg.id]

  tags = {
    Name = "Web-Server-${count.index + 1}"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Servidor Web ${count.index + 1} - $(hostname)</h1>" > /var/www/html/index.html
  EOF
}
