provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "minikube" {
  ami             = "ami-005fc0f236362e99f"
  instance_type   = "t2.medium"
  security_groups = [aws_security_group.group1.name]
  key_name        = "TF_key"
  tags = {
    Name = var.server_names[0]
  }

  root_block_device {
    volume_size = 20
    volume_type = "gp2"
  }
}

resource "aws_eip" "eip2" {
  instance = aws_instance.minikube.id
}

#Security group
resource "aws_security_group" "group1" {
  name        = "Production"
  description = "Allow inbound and outbound traffic"

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
  dynamic "egress" {
    iterator = port
    for_each = var.egress
    content {
      from_port   = port.value
      to_port     = port.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }
}

#SSH .pem key
resource "aws_key_pair" "TF_key" {
  key_name   = "TF_key"
  public_key = tls_private_key.rsa.public_key_openssh
}

resource "tls_private_key" "rsa" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "local_file" "TF-key" {
  content  = tls_private_key.rsa.private_key_pem
  filename = "tfkey.pem"
}
