terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}


provider "aws" {
  region     = "us-east-1"
  access_key = "ASIASDKBNIIVGMNWX45Z"
  secret_key = "n9ZyMlEvy/iNY7Xuqih9LWRynYdZUngN3oakV42r"
  token      = "FwoGZXIvYXdzEF0aDG2LPR8g9w8RfMclFCLBAVCgmFDl61Nos4IvxTqJWNPFBPrJDams6lxOX6BitSP8j1Nn3ADe4hcqh5ARv+sXQc6IqWTiYLeW710tZqN1l0S5z1apx8B9jg43X2x2PE2XsRVS3z4Cilc+b8owFWnSlL/miAdQkcxwDkOGbarpSZe53lQCpBJg0yxs0fGzilMkTws0+ZPI9HmwN1Pywzn/Qx+8BkC54+E53pyoHlQCA1rdDWEfg9opIR09lFK8kPwplBVXTEOxHf3J8jFodntOiEoox8iZnAYyLSwaps5I6rAaliJMQGJjRdBY7GJottkJaCPCHILYIZOnzBRTEva/U1xlNIktKA=="
}


resource "aws_security_group" "security_gp" {
  vpc_id = data.aws_vpc.default.id

  ingress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_instance" "stand-alone-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  user_data              = file("userdata.sh")
  key_name               = "vockey"
  tags = {
    Name = "Standalone"
  }
}

resource "aws_instance" "cluster-master-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Master"
  }
}

resource "aws_instance" "cluster-slave-instance-1" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Slave1"
  }
}

resource "aws_instance" "cluster-slave-instance-2" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Slave2"
  }
}

resource "aws_instance" "cluster-slave-instance-3" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Slave3"
  }
}

resource "aws_instance" "proxy-instance" {
  ami                    = "ami-0149b2da6ceec4bb0"
  instance_type          = "t2.large"
  vpc_security_group_ids = [aws_security_group.security_gp.id]
  availability_zone      = "us-east-1d"
  key_name               = "vockey"
  tags = {
    Name = "Proxy"
  }
}