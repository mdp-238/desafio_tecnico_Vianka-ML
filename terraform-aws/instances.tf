resource "aws_instance" "web_servers" {
  count                = var.instance_count
  ami                  = var.ami_id
  instance_type        = var.instance_type
  subnet_id            = element(module.vpc.private_subnets, count.index)
  security_groups      = [aws_security_group.web_sg.id]
  iam_instance_profile = aws_iam_instance_profile.ec2_combined_profile.name

  tags = {
    Name = "Web-Server"
  }

  user_data = <<-EOF
    #!/bin/bash
    apt update -y
    apt install -y nginx awscli
    systemctl start nginx
    systemctl enable nginx
    echo "<h1>Servidor Web - Desafío Técnico ML</h1>" > /var/www/html/index.html

    mkdir -p /var/backups/

    until aws s3 ls s3://desafio-tecnico-ml-web/; do
        echo "Esperando a que el bucket esté disponible..."
        sleep 5
    done

    tar -czvf /var/backups/web_server.tar.gz /var/www/html/
    aws s3 cp /var/backups/web_server.tar.gz s3://desafio-tecnico-ml-web/
  EOF
}
