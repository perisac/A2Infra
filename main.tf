terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.92"
    }
  }

  required_version = ">= 1.2"
}

provider "aws" {
  region = "sa-east-1"
}

# data "aws_ami" "ubuntu" {
#   most_recent = true

#   filter {
#     name = "name"
#     values = ["ubuntu/images/hvm-ssd-gp3/ubuntu-noble-24.04-amd64-server-*"]
#   }

#   owners = ["099720109477"] # Canonical
# }

  resource "aws_instance" "app_server" {
   ami           = "ami-077aec33f15de0896"
   instance_type = "t3.micro"
   key_name = "KeyIsac"
   vpc_security_group_ids = [aws_security_group.securityGroupIsac.id]
   tags = {
     Name = "Instancia Teste Isac V4"
   }
 }

resource "aws_security_group" "securityGroupIsac" {
  name = "securityGroupIsacAWS"
  description = "Liberar acesso SSH"
  ingress {
    description = "Liberar a porta 22 que ta dando erro"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }
    ingress {
    description = "Configurar pra HTTP"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = [ "0.0.0.0/0" ]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = -1
    cidr_blocks = [ "0.0.0.0/0" ]
  }
}

resource "aws_key_pair" "chaveIsacSSHa2" {
  key_name = "KeyIsac"
  public_key = file("KeyIsac.pub")
}

output "ipPublico" {
  value = aws_instance.app_server.public_ip
}