provider "aws" {}

variable "key_name" {
  type    = string
  default = "wireguard-aws"
}

variable "ssh_ips" {
  type = list(string)
}

variable "wireguard_ips" {
  type    = list(string)
  default = ["0.0.0.0/0"]
}

# latest ami instance
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"] # Canonical

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

# security group
resource "aws_security_group" "allow_tls" {
  name        = "wireguard"
  description = "Allow UDP inbound traffic"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.ssh_ips
  }

  ingress {
    description = "UDP"
    from_port   = 51820
    to_port     = 51820
    protocol    = "udp"
    cidr_blocks = var.wireguard_ips
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "wireguard"
  }
}

# ec2 resource
resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t2.micro"
  key_name      = var.key_name

  tags = {
    Name = "wireguard"
  }

  root_block_device {
    volume_size = 16
  }

  security_groups = [aws_security_group.allow_tls.name]

  user_data = file("${path.module}/install.sh")
}
