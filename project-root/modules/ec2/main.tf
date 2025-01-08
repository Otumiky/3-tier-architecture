resource "aws_instance" "web-server" {
  ami           = var.ami_id
  instance_type = var.instance_type
  subnet_id     = var.subnet_id
  security_groups = [var.security_group_id]
  user_data     =  base64encode(<<-EOF
              #!/bin/bash
              sudo yum update -y
              sudo yum install -y httpd
              sudo systemctl start httpd
              sudo systemctl enable httpd
              echo "Hello from Server $(hostname)" > /var/www/html/index.html
              EOF
  )

  tags = {
    Name = "web-server-instance"
  }
}